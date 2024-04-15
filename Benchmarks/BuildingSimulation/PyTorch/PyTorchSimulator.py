import torch

# Definitions

dTime = 0.1
π = 3.14159265359


# TubeType and other custom object holding primitives will be represented with a 1D Tensor,
# and SimParams will compose them into a 2D tensor

# make each 1D Tensor the same length, to avoid having to use Ragged Tensors
# with padding added to match length of other 1D Tensors
TubeType = torch.tensor([0.50292, 0.019, 0.001588, 2.43, 0.0], requires_grad=True)

# define indexes for sanity's sake
class TubeTypeIndices:
    itubeSpacing = 0
    idiameter = 1
    ithickness = 2
    iresistivity = 3

SlabType = torch.tensor([21.1111111, 100.0, 0.2, 2242.58, 0.101], requires_grad=True)

class SlabTypeIndices:
    itemp = 0
    iarea = 1
    iCp = 2
    idensity = 3
    ithickness = 4

QuantaType = torch.tensor([0.0, 60.0, 0.0006309, 1000.0, 4180.0], requires_grad=True)

class QuantaIndices:
    ipower = 0
    itemp = 1
    iflow = 2
    idensity = 3
    iCp = 4

TankType = torch.tensor([70.0, 0.0757082, 4180.0, 1000.0, 75.708], requires_grad=True)

class TankTypeIndices:
    itemp = 0
    ivolume = 1
    iCp = 2
    idensity = 3
    imass = 4

#------------------------------------------------------------------------
# represent starting temp as a 5 length padded Tensor to match other Tensor sizes
# (to avoid having to use Ragged Tensors)
startingTemperature = torch.tensor([33.3, 0, 0, 0, 0], requires_grad=True)


# SimParams will be represented with a 2D Tensor, where each
# member (a custom type itself) is represented by a 1D Tensor
SimParamsConstant = torch.stack([TubeType, SlabType, QuantaType, TankType, startingTemperature])
assert SimParamsConstant.size() == (5,5)

class SimParamsIndices:
    itube = 0
    islab = 1
    iquanta = 2
    itank = 3
    istartingTemp = 4


# Computations

def computeResistance(floor, tube, quanta):
    geometry_coeff = 10.0
    
    tubingSurfaceArea = (floor[SlabTypeIndices.iarea] / tube[TubeTypeIndices.itubeSpacing]) * π * tube[TubeTypeIndices.idiameter]
    resistance_abs = tube[TubeTypeIndices.iresistivity] * tube[TubeTypeIndices.ithickness] / tubingSurfaceArea
    
    resistance_corrected = resistance_abs * geometry_coeff

    return resistance_corrected


def computeLoadPower(floor, tube, quanta):
    resistance_abs = computeResistance(floor, tube, quanta)
    
    conductance = 1/resistance_abs
    dTemp = floor[SlabTypeIndices.itemp] - quanta[QuantaIndices.itemp]
    power = dTemp * conductance

    loadPower = -power

    resultQuanta = quanta * torch.tensor([0.0, 1, 1, 1, 1], requires_grad=True) + power * torch.tensor([1.0, 0, 0, 0, 0], requires_grad=True)

    return (resultQuanta, loadPower)

def updateQuanta(quanta):
    workingVolume = (quanta[QuantaIndices.iflow] * dTime)
    workingMass = (workingVolume * quanta[QuantaIndices.idensity])
    workingEnergy = quanta[QuantaIndices.ipower] * dTime
    TempRise = workingEnergy / quanta[QuantaIndices.iCp] / workingMass

    resultQuanta = quanta + TempRise * torch.tensor([0.0, 1, 0, 0, 0])
    resultQuanta = resultQuanta * torch.tensor([0.0, 1, 1, 1, 1])

    return resultQuanta

def updateBuildingModel(power, floor):
    floorVolume = floor[SlabTypeIndices.iarea] * floor[SlabTypeIndices.ithickness]
    floorMass = floorVolume * floor[SlabTypeIndices.idensity]
    floorTempChange = (power * dTime) / floor[SlabTypeIndices.iCp] / floorMass

    resultFloor = floor + floorTempChange * torch.Tensor([1.0, 0, 0, 0, 0])

    return resultFloor

def updateSourceTank(store, quanta):
    massPerTime = quanta[QuantaIndices.iflow] * quanta[QuantaIndices.idensity]
    dTemp = store[TankTypeIndices.itemp] - quanta[QuantaIndices.itemp]
    power = dTemp * massPerTime * quanta[QuantaIndices.iCp]

    updatedQuanta = quanta * torch.Tensor([0.0, 1, 1, 1, 1]) + power * torch.Tensor([1.0, 0, 0, 0, 0])

    tankMass = store[TankTypeIndices.ivolume] * store[TankTypeIndices.idensity]
    TempRise = (power * dTime) / store[TankTypeIndices.iCp] / tankMass

    updatedStore = store + TempRise * torch.Tensor([1.0, 0, 0, 0, 0])

    return (updatedStore, updatedQuanta)

def lossCalc(pred, gt):
    return torch.abs(pred - gt)

# Simulations

def simulate(simParams):
    pexTube = simParams[SimParamsIndices.itube]
    slab = simParams[SimParamsIndices.islab]
    tank = simParams[SimParamsIndices.itank]
    quanta = simParams[SimParamsIndices.iquanta]

    startingTemp = simParams[SimParamsIndices.istartingTemp][0]
    slab = slab * torch.Tensor([0.0, 1, 1, 1, 1]) + startingTemp * torch.Tensor([1.0, 0, 0, 0, 0])

    for i in range(0, timesteps):
        tankAndQuanta = updateSourceTank(tank, quanta)
        tank = tankAndQuanta[0]
        quanta = tankAndQuanta[1]

        quanta = updateQuanta(quanta)
        
        quantaAndPower = computeLoadPower(slab, pexTube, quanta)
        quanta = quantaAndPower[0]
        powerToBuilding = quantaAndPower[1]
        quanta = updateQuanta(quanta)
        
        slab = updateBuildingModel(powerToBuilding, slab)
        
    return slab[SlabTypeIndices.itemp]

import time

def measure(function, arguments):
    start = time.time()
    result = function(arguments)
    end = time.time()
    return (end - start, result)


def fullPipe(simParams):
    pred = simulate(simParams)
    loss = lossCalc(pred, 27.344767)
    return loss


totalForwardTime = 0
totalGradientTime = 0

timesteps = 20
trials = 30
warmup = 3

for i in range(trials):
    
    inputs = SimParamsConstant
    forwardOnlyTime, forwardOutput = measure(fullPipe, inputs)
    
    simParams = SimParamsConstant
    def getGradient(simParams):
        gradient = torch.autograd.grad(forwardOutput, inputs)
        return gradient


    gradientTime, gradient = measure(getGradient, simParams)
    
    if i >= warmup:
        totalForwardTime += forwardOnlyTime
        totalGradientTime += gradientTime


averageForwardTime = totalForwardTime / (trials - warmup)
averageGradientTime = totalGradientTime / (trials - warmup)

print("timesteps:", timesteps)
print("trials:", trials)
print("average forward and backwards pass (gradient) time", averageGradientTime)

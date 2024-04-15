
import tensorflow as tf

@tf.function
def doMath(a):
    return a * 2

# Definitions

dTime = 0.1
π = 3.14159265359


# TubeType and other custom object holding primitives will be represented with a 1D Tensor,
# and SimParams will compose them into a 2D tensor

# make each 1D Tensor the same length, to avoid having to use Ragged Tensors
# with padding added to match length of other 1D Tensors
TubeType = tf.constant([0.50292, 0.019, 0.001588, 2.43, 0.0])

# define indexes for sanity's sake
class TubeTypeIndices:
    itubeSpacing = 0
    idiameter = 1
    ithickness = 2
    iresistivity = 3

SlabType = tf.constant([21.1111111, 100.0, 0.2, 2242.58, 0.101])

class SlabTypeIndices:
    itemp = 0
    iarea = 1
    iCp = 2
    idensity = 3
    ithickness = 4

QuantaType = tf.constant([0.0, 60.0, 0.0006309, 1000.0, 4180.0])

class QuantaIndices:
    ipower = 0
    itemp = 1
    iflow = 2
    idensity = 3
    iCp = 4

TankType = tf.constant([70.0, 0.0757082, 4180.0, 1000.0, 75.708])

class TankTypeIndices:
    itemp = 0
    ivolume = 1
    iCp = 2
    idensity = 3
    imass = 4

# represent starting temp as a 5 length padded Tensor to match other Tensor sizes
# (to avoid having to use Ragged Tensors)
startingTemperature = tf.constant([33.3, 0, 0, 0, 0])


# SimParams will be represented with a 2D Tensor, where each
# member (a custom type itself) is represented by a 1D Tensor
SimParamsConstant = tf.convert_to_tensor([TubeType, SlabType, QuantaType, TankType, startingTemperature])

class SimParamsIndices:
    itube = 0
    islab = 1
    iquanta = 2
    itank = 3
    istartingTemp = 4


# Computations

@tf.function
def computeResistance(floor, tube, quanta):
    geometry_coeff = 10.0
    
    tubingSurfaceArea = (floor[SlabTypeIndices.iarea] / tube[TubeTypeIndices.itubeSpacing]) * π * tube[TubeTypeIndices.idiameter]
    resistance_abs = tube[TubeTypeIndices.iresistivity] * tube[TubeTypeIndices.ithickness] / tubingSurfaceArea
    
    resistance_corrected = resistance_abs * geometry_coeff

    return resistance_corrected


@tf.function
def computeLoadPower(floor, tube, quanta):
    resistance_abs = computeResistance(floor, tube, quanta)
    
    conductance = 1/resistance_abs
    dTemp = floor[SlabTypeIndices.itemp] - quanta[QuantaIndices.itemp]
    power = dTemp * conductance

    loadPower = -power

    resultQuanta = quanta * tf.constant([0.0, 1, 1, 1, 1]) + power * tf.constant([1.0, 0, 0, 0, 0])

    return (resultQuanta, loadPower)


slab, tube, quanta = tf.Variable(SlabType), tf.Variable(TubeType), tf.Variable(QuantaType)
with tf.GradientTape() as tape:
    quantaAndPower = computeLoadPower(slab, tube, quanta)

gradient = tape.gradient(quantaAndPower, [slab, tube, quanta])

@tf.function
def updateQuanta(quanta: tf.Tensor) -> tf.Tensor:
    workingVolume = (quanta[QuantaIndices.iflow] * dTime)
    workingMass = (workingVolume * quanta[QuantaIndices.idensity])
    workingEnergy = quanta[QuantaIndices.ipower] * dTime
    TempRise = workingEnergy / quanta[QuantaIndices.iCp] / workingMass

    resultQuanta = quanta + TempRise * tf.constant([0.0, 1, 0, 0, 0])
    resultQuanta = resultQuanta * tf.constant([0.0, 1, 1, 1, 1])

    return resultQuanta

quanta = tf.Variable(QuantaType)
with tf.GradientTape() as tape:
    tape.watch(quanta)
    newQuanta = updateQuanta(quanta)

gradient = tape.gradient(newQuanta, [quanta])

@tf.function
def updateBuildingModel(power, floor):
    floorVolume = floor[SlabTypeIndices.iarea] * floor[SlabTypeIndices.ithickness]
    floorMass = floorVolume * floor[SlabTypeIndices.idensity]
    floorTempChange = (power * dTime) / floor[SlabTypeIndices.iCp] / floorMass

    resultFloor = floor + floorTempChange * tf.constant([1.0, 0, 0, 0, 0])

    return resultFloor

inputPower = tf.constant([1.0])[0]

inputPower = tf.Variable(inputPower)
slab = tf.Variable(SlabType)
with tf.GradientTape() as tape:
    tape.watch(inputPower)
    tape.watch(slab)
    newSlab = updateBuildingModel(inputPower, slab)

gradient = tape.gradient(newSlab, [inputPower, slab])

@tf.function
def updateSourceTank(store, quanta):
    massPerTime = quanta[QuantaIndices.iflow] * quanta[QuantaIndices.idensity]
    dTemp = store[TankTypeIndices.itemp] - quanta[QuantaIndices.itemp]
    power = dTemp * massPerTime * quanta[QuantaIndices.iCp]

    updatedQuanta = quanta * tf.constant([0.0, 1, 1, 1, 1]) + power * tf.constant([1.0, 0, 0, 0, 0])

    tankMass = store[TankTypeIndices.ivolume] * store[TankTypeIndices.idensity]
    TempRise = (power * dTime) / store[TankTypeIndices.iCp] / tankMass

    updatedStore = store + TempRise * tf.constant([1.0, 0, 0, 0, 0])

    return (updatedStore, updatedQuanta)

store = tf.Variable(TankType)
quanta = tf.Variable(QuantaType)
with tf.GradientTape() as tape:
    tape.watch(store)
    tape.watch(quanta)
    tankAndQuanta = updateSourceTank(store, quanta)

gradient = tape.gradient(tankAndQuanta, [store, quanta])

simParams = tf.Variable(SimParamsConstant)


@tf.function
def lossCalc(pred, gt):
    return tf.abs(pred - gt)

# Simulations

@tf.function
def simulate(simParams):
    pexTube = simParams[SimParamsIndices.itube]
    slab = simParams[SimParamsIndices.islab]
    tank = simParams[SimParamsIndices.itank]
    quanta = simParams[SimParamsIndices.iquanta]

    startingTemp = simParams[SimParamsIndices.istartingTemp][0]
    slab = slab * tf.constant([0.0, 1, 1, 1, 1]) + startingTemp * tf.constant([1.0, 0, 0, 0, 0])

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
    return end - start


@tf.function
def fullPipe(simParams):
    pred = simulate(simParams)
    loss = lossCalc(pred, 27.344767)
    return loss

learningRate = 0.1

totalForwardTime = 0
totalGradientTime = 0

timesteps = 20
trials = 30
warmup = 3

for i in range(trials + warmup):
    
    forwardOnly = measure(fullPipe, SimParamsConstant)
    
    simParams = tf.Variable(SimParamsConstant)
    def getGradient(simParams):
        with tf.GradientTape() as tape:
            endTemperature = simulate(simParams)

            gradient = tape.gradient(endTemperature, [simParams])
        return gradient


    gradientTime = measure(getGradient, simParams)
    
    if i >= warmup:
        totalForwardTime += forwardOnly
        totalGradientTime += gradientTime


averageForwardTime = totalForwardTime / (trials - warmup)
averageGradientTime = totalGradientTime / (trials - warmup)

print("timesteps:", timesteps)
print("trials:", trials)
print("average forward and backwards pass (gradient) time", averageGradientTime)

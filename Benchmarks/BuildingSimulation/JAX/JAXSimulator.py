import time
import dataclasses
from flax import struct
import jax
import jax.numpy as jnp
from jax import grad, jit
from typing import NamedTuple

# ---------------------------------
# Simulation parameters
# ---------------------------------
trials = 100
timesteps = 20
dTime = jnp.float32(0.1)
printGradToCompare = False

π = jnp.float32(jnp.pi)

# ---------------------------------
# Data classes
# ---------------------------------
@struct.dataclass
class TubeType:
    tubeSpacing: jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(0.50292))
    diameter:    jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(0.019))
    thickness:   jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(0.001588))
    resistivity: jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(2.43))

@struct.dataclass
class SlabType:
    temp:      jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(21.1111111))
    area:      jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(100.0))
    Cp:        jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(0.2))
    density:   jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(2242.58))
    thickness: jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(0.101))

@struct.dataclass
class QuantaType:
    power:   jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(0.0))
    temp:    jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(60.0))
    flow:    jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(0.0006309))
    density: jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(1000.0))
    Cp:      jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(4180.0))

@struct.dataclass
class TankType:
    temp:    jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(70.0))
    volume:  jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(0.0757082))
    Cp:      jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(4180.0))
    density: jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(1000.0))
    mass:    jnp.float32 = dataclasses.field(default_factory=lambda: jnp.float32(75.708))

@struct.dataclass
class SimParams:
    tube:         TubeType
    slab:         SlabType
    quanta:       QuantaType
    tank:         TankType
    startingTemp: jnp.float32

@struct.dataclass
class QuantaAndPower:
    quanta: QuantaType
    power:  jnp.float32

@struct.dataclass
class TankAndQuanta:
    tank:   TankType
    quanta: QuantaType

# ---------------------------------
# Default instance (like Swift's simParams)
# ---------------------------------
defaultSimParams = SimParams(
    tube=TubeType(),
    slab=SlabType(),
    quanta=QuantaType(),
    tank=TankType(),
    startingTemp=jnp.float32(33.3),
)

# ---------------------------------
# Physics computations
# ---------------------------------
def computeResistance(
    floor: SlabType,
    tube: TubeType,
    quanta: QuantaType
) -> jnp.float32:
    geometry_coeff = jnp.float32(10.0)
    tubingSurfaceArea = (floor.area / tube.tubeSpacing) * π * tube.diameter
    resistance_abs = tube.resistivity * tube.thickness / tubingSurfaceArea
    return resistance_abs * geometry_coeff

def computeLoadPower(
    floor: SlabType,
    tube: TubeType,
    quanta: QuantaType
) -> QuantaAndPower:
    """
    Returns a QuantaAndPower object with:
      quanta.power set to 'power = dTemp * conductance'
      and 'power' field being the negative of that (the "load power").
    """
    resistance_abs = computeResistance(floor, tube, quanta)
    conductance = 1.0 / resistance_abs
    dTemp = floor.temp - quanta.temp
    power = dTemp * conductance

    # updated quanta with new power
    updatedQuanta = quanta.replace(power=power)

    loadPower = -power  # negative
    return QuantaAndPower(quanta=updatedQuanta, power=loadPower)

def updateQuanta(quanta: QuantaType) -> QuantaType:
    """
    Based on the quanta.power, update the fluid temperature.
    Then set quanta.power = 0 at the end.
    """
    workingVolume = quanta.flow * dTime
    workingMass = workingVolume * quanta.density
    workingEnergy = quanta.power * dTime
    tempRise = workingEnergy / quanta.Cp / workingMass

    updatedQuanta = quanta.replace(
        temp = quanta.temp + tempRise,
        power = jnp.float32(0.0)
    )
    return updatedQuanta

def updateBuildingModel(power: jnp.float32, floor: SlabType) -> SlabType:
    floorVolume = floor.area * floor.thickness
    floorMass   = floorVolume * floor.density
    tempChange  = (power * dTime) / floor.Cp / floorMass

    updatedFloor = floor.replace(
        temp = floor.temp + tempChange
    )
    return updatedFloor

def updateSourceTank(store: TankType, quanta: QuantaType) -> TankAndQuanta:
    massPerTime = quanta.flow * quanta.density
    dTemp = store.temp - quanta.temp
    power = dTemp * massPerTime * quanta.Cp

    updatedQuanta = quanta.replace(power=power)

    tankMass = store.volume * store.density
    tempRise = (power * dTime) / store.Cp / tankMass
    updatedStore = store.replace(
        temp = store.temp + tempRise
    )
    return TankAndQuanta(tank=updatedStore, quanta=updatedQuanta)

def lossCalc(pred: jnp.float32, gt: jnp.float32) -> jnp.float32:
    diff = pred - gt
    return jnp.abs(diff)

# ---------------------------------
# Simulation
# ---------------------------------
def simulate(simParams: SimParams) -> jnp.float32:
    """
    Replicates the Swift `simulate(simParams:)` function:
      - Overwrite slab.temp with simParams.startingTemp
      - Loop timesteps times:
          * tankAndQuanta = updateSourceTank()
          * quanta = updateQuanta()
          * quantaAndPower = computeLoadPower()
          * quanta = updateQuanta()
          * slab = updateBuildingModel()
      - Return final slab.temp
    """
    tube   = simParams.tube
    slab   = simParams.slab.replace(temp = simParams.startingTemp)
    tank   = simParams.tank
    quanta = simParams.quanta

    for _ in range(timesteps):
        tq = updateSourceTank(tank, quanta)
        tank = tq.tank
        quanta = tq.quanta

        quanta = updateQuanta(quanta)

        qp = computeLoadPower(slab, tube, quanta)
        quanta = qp.quanta
        powerToBuilding = qp.power

        quanta = updateQuanta(quanta)

        slab = updateBuildingModel(powerToBuilding, slab)

    return slab.temp

def fullPipe(simParams: SimParams) -> jnp.float32:
    """
    Replicates `fullPipe(simParams:)` from Swift:
      - Runs `simulate(simParams:)`
      - Computes the loss vs. target = 27.344767
    """
    pred = simulate(simParams)
    the_loss = lossCalc(pred, jnp.float32(27.344767))
    return the_loss

# ---------------------------------
# JIT-compile for performance
# ---------------------------------
simulate_jit = jit(simulate)
fullPipe_jit = jit(fullPipe)
fullPipe_grad_jit = jit(grad(fullPipe))

# ---------------------------------
# Simple timer function
# ---------------------------------
def measure(func, *args, **kwargs):
    t0 = time.time()
    out = func(*args, **kwargs)
    t1 = time.time()
    return (t1 - t0), out

# ---------------------------------
# Run the trials
# ---------------------------------
totalPureForwardTime = 0.0
totalGradientTime = 0.0

simParams = defaultSimParams  # from above

# Warm up the JIT so that subsequent timing excludes compilation
_ = fullPipe_jit(simParams)
_ = fullPipe_grad_jit(simParams)

for _ in range(trials):
    # Forward only
    forwardTime, forwardVal = measure(fullPipe_jit, simParams)

    # Gradient
    gradientTime, gradVal = measure(fullPipe_grad_jit, simParams)

    if printGradToCompare:
        print(gradVal)

    totalPureForwardTime += forwardTime
    totalGradientTime += gradientTime

averagePureForward = totalPureForwardTime / trials
averageGradient    = totalGradientTime   / trials

print(f"trials: {trials}")
print(f"timesteps: {timesteps}")
print(f"average forward only time: {averagePureForward:.6f} seconds")
print(f"average forward+back (gradient) time: {averageGradient:.6f} seconds")

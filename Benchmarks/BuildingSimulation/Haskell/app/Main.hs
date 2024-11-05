{-# LANGUAGE BangPatterns          #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedRecordDot   #-}
{-# OPTIONS_GHC -fno-warn-name-shadowing #-}

module Main where

import Control.Monad
import Criterion
import Criterion.Main
import Criterion.Types
import Numeric.AD.Double
import Statistics.Types
import Text.Printf
import Prelude hiding (init)

import GHC.IsList


data SimParams a = SimParams
  { tube         :: !(Tube a)
  , slab         :: !(Slab a)
  , quanta       :: !(Quanta a)
  , tank         :: !(Tank a)
  , startingTemp :: !a
  }
  deriving Show

instance Fractional a => Init (SimParams a) where
  init = SimParams init init init init 33.3

data Tube a = Tube
  { spacing     :: !a   -- m
  , diameter    :: !a   -- m
  , thickness   :: !a   -- m
  , resistivity :: !a   -- (K/W)m
  }
  deriving Show

instance Fractional a => Init (Tube a) where
  init = Tube 0.50292 0.019 0.019 2.43

instance IsList (Tube a) where
  type Item (Tube a) = a
  toList (Tube a b c d) = [a,b,c,d]
  fromList [a,b,c,d] = Tube a b c d
  fromList _         = undefined

data Slab a = Slab
  { temp      :: !a   -- °C
  , area      :: !a   -- m³
  , cp        :: !a   -- ws / (kg K)
  , density   :: !a   -- kg / m³
  , thickness :: !a   -- m
  }
  deriving Show

instance Fractional a => Init (Slab a) where
  init = Slab 21.1111111 100.0 0.2 2242.58 0.101

instance IsList (Slab a) where
  type Item (Slab a) = a
  toList (Slab a b c d e) = [a,b,c,d,e]
  fromList [a,b,c,d,e] = Slab a b c d e
  fromList _           = undefined

data Quanta a = Quanta
  { power   :: !a   -- Watt
  , temp    :: !a   -- °C
  , flow    :: !a   -- m³ / sec
  , density :: !a   -- kg / m³
  , cp      :: !a   -- ws / (kg K)
  }
  deriving Show

instance Fractional a => Init (Quanta a) where
 init = Quanta 0.0 60.0 0.0006309 1000.0 4180.0

instance IsList (Quanta a) where
  type Item (Quanta a) = a
  toList (Quanta a b c d e) = [a,b,c,d,e]
  fromList [a,b,c,d,e] = Quanta a b c d e
  fromList _           = undefined

data Tank a = Tank
  { temp    :: !a   -- °C
  , volume  :: !a   -- m³
  , cp      :: !a   -- ws / (kg K)
  , density :: !a   -- kg / m³
  , mass    :: !a   -- kg
  }
  deriving Show

instance Fractional a => Init (Tank a) where
  init = Tank 70.0 0.0757082 4180.000 1000.000 75.708

instance IsList (Tank a) where
  type Item (Tank a) = a
  toList (Tank a b c d e) = [a,b,c,d,e]
  fromList [a,b,c,d,e] = Tank a b c d e
  fromList _           = undefined

data QuantaAndPower a = QuantaAndPower
  { quanta :: !(Quanta a)
  , power  :: !a
  }
  deriving Show

data TankAndQuanta a = TankAndQuanta
  { tank   :: !(Tank a)
  , quanta :: !(Quanta a)
  }
  deriving Show


{-# SPECIALIZE computeResistance :: Slab Float -> Tube Float -> Quanta Float -> Float #-}
{-# SPECIALIZE computeResistance :: Slab Double -> Tube Double -> Quanta Double -> Double #-}
computeResistance
    :: Floating a
    => Slab a
    -> Tube a
    -> Quanta a
    -> a
computeResistance floor tube _quanta =
  let geometry_coeff       = 10.0
      -- f_coff               = 0.3333333

      tubingSurfaceArea    = (floor.area / tube.spacing) * pi * tube.diameter
      resistance_abs       = tube.resistivity * tube.thickness / tubingSurfaceArea

      resistance_corrected = resistance_abs * geometry_coeff -- * (quanta.flow * f_coff)
  in
  resistance_corrected


{-# SPECIALIZE computeLoadPower :: Slab Float -> Tube Float -> Quanta Float -> QuantaAndPower Float #-}
{-# SPECIALIZE computeLoadPower :: Slab Double -> Tube Double -> Quanta Double -> QuantaAndPower Double #-}
computeLoadPower
    :: Floating a
    => Slab a
    -> Tube a
    -> Quanta a
    -> QuantaAndPower a
computeLoadPower floor tube quanta =
  let resistance_abs = computeResistance floor tube quanta

      conductance    = 1 / resistance_abs
      dTemp          = floor.temp - quanta.temp
      updatedPower   = dTemp * conductance

      -- TLM: We could simplify a lot of these by either (a) dropping duplicate
      -- record fields; or (b) allowing overloaded record update.
      loadPower      = -updatedPower
      updatedQuanta  = Quanta { power   = updatedPower
                              , temp    = quanta.temp
                              , flow    = quanta.flow
                              , density = quanta.density
                              , cp      = quanta.cp
                              }
  in
  QuantaAndPower { quanta = updatedQuanta, power = loadPower }


{-# SPECIALIZE updateQuanta :: Quanta Float -> Quanta Float #-}
{-# SPECIALIZE updateQuanta :: Quanta Double -> Quanta Double #-}
updateQuanta
    :: Floating a
    => Quanta a
    -> Quanta a
updateQuanta quanta =
  let workingVolume = (quanta.flow * dTime)
      workingMass   = (workingVolume * quanta.density)
      workingEnergy = quanta.power * dTime
      dTemp         = workingEnergy / quanta.cp / workingMass

      updatedQuanta = Quanta { power   = 0
                             , temp    = quanta.temp + dTemp
                             , flow    = quanta.flow
                             , density = quanta.density
                             , cp      = quanta.cp
                             }
  in
  updatedQuanta


{-# SPECIALIZE updateBuildingModel :: Float -> Slab Float -> Slab Float #-}
{-# SPECIALIZE updateBuildingModel :: Double -> Slab Double -> Slab Double #-}
updateBuildingModel
    :: Floating a
    => a
    -> Slab a
    -> Slab a
updateBuildingModel power floor =
  let floorVolume  = floor.area * floor.thickness
      floorMass    = floorVolume * floor.density

      updatedFloor = Slab { temp      = floor.temp + ((power * dTime) / floor.cp / floorMass)
                          , area      = floor.area
                          , cp        = floor.cp
                          , density   = floor.density
                          , thickness = floor.thickness
                          }
  in
  updatedFloor


{-# SPECIALIZE updateSourceTank :: Tank Float -> Quanta Float -> TankAndQuanta Float #-}
{-# SPECIALIZE updateSourceTank :: Tank Double -> Quanta Double -> TankAndQuanta Double #-}
updateSourceTank
    :: Floating a
    => Tank a
    -> Quanta a
    -> TankAndQuanta a
updateSourceTank store quanta =
  let massPerTime  = quanta.flow * quanta.density
      dTemp        = store.temp - quanta.temp
      updatedPower = dTemp * massPerTime * quanta.cp

      updatedQuanta = Quanta { power   = updatedPower
                             , temp    = quanta.temp
                             , flow    = quanta.flow
                             , density = quanta.density
                             , cp      = quanta.cp
                             }

      tankMass     = store.volume * store.density
      dTempTank    = (updatedPower * dTime) / store.cp / tankMass
      updatedStore = Tank { temp    = store.temp + dTempTank
                          , volume  = store.volume
                          , cp      = store.cp
                          , density = store.density
                          , mass    = store.mass
                          }
  in
  TankAndQuanta updatedStore updatedQuanta


{-# SPECIALIZE lossCalc :: Float -> Float -> Float #-}
{-# SPECIALIZE lossCalc :: Double -> Double -> Double #-}
lossCalc :: Num a => a -> a -> a
lossCalc pred gt =
  let diff = pred - gt
   in abs diff


{-# SPECIALIZE simulate :: SimParams Float -> Float #-}
{-# SPECIALIZE simulate :: SimParams Double -> Double #-}
simulate :: Floating a => SimParams a -> a
simulate (SimParams pexTube slab0 quanta0 tank0 temp0) =
  let
      slab0' = Slab temp0 slab0.area slab0.cp slab0.density slab0.thickness

      go !i !slab !tank !quanta
        | i >= timesteps = slab.temp
        | otherwise      =
            let TankAndQuanta tank' quanta'             = updateSourceTank tank quanta
                QuantaAndPower quanta'' powerToBuilding = computeLoadPower slab pexTube (updateQuanta quanta')
                slab'                                   = updateBuildingModel powerToBuilding slab
            in
            go (i+1) slab' tank' (updateQuanta quanta'')
  in
  go 0 slab0' tank0 quanta0


fullPipe :: Floating a => SimParams a -> a
fullPipe params =
  let pred = simulate params
      loss = lossCalc pred 27.344767
  in
  loss



-- TLM: could probably at least make this a vector? The pack operation becomes
-- more tedious however...
unpack :: SimParams a -> [a]
unpack (SimParams tube slab quanta tank startingTemp) =
  toList tube <> toList slab <> toList quanta <> toList tank <> [startingTemp]

pack :: [a] -> SimParams a
pack x0 =
  let (tube, x1)     = splitAt 4 x0
      (slab, x2)     = splitAt 5 x1
      (quanta, x3)   = splitAt 5 x2
      (tank, x4)     = splitAt 5 x3
      [startingTemp] = x4
  in
  SimParams (fromList tube) (fromList slab) (fromList quanta) (fromList tank) startingTemp
      

-- Simulation Parameters -------------------------------------------------------

dTime :: Fractional a => a
dTime = 0.1

timesteps :: Int
timesteps = 1000

printGradToCompare :: Bool
printGradToCompare = False

main :: IO ()
main = do
  let simParams  = init :: SimParams Double
      simParams' = unpack simParams
      fullPipe'  = grad (fullPipe . pack)
      config     = defaultConfig { verbosity = Quiet }

  when printGradToCompare $
    print (pack (fullPipe' simParams'))

  -- The default benchmarking setup will give more accurate information, but
  -- we'll prefer to just match the output of all benchmark programs instead
  -- defaultMain
  --   [ bench "primal"  $ nf fullPipe  simParams
  --   , bench "adjoint" $ nf fullPipe' simParams'
  --   ]

  result_forward  <- benchmarkWith' config $ nf fullPipe simParams
  result_gradient <- benchmarkWith' config $ nf fullPipe' simParams'

  printf "average forward only time: %f seconds\n" result_forward.reportAnalysis.anMean.estPoint
  printf "average forward and backwards (gradient) time: %f seconds\n" result_gradient.reportAnalysis.anMean.estPoint


-- Helpers ---------------------------------------------------------------------

class Init a where
  init :: a


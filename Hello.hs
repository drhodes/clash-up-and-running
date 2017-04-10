{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}

module FIR where 

import CLaSH.Sized.Internal.Signed
import CLaSH.Prelude
import CLaSH.Prelude as P
import CLaSH.Signal.Explicit
import Control.Monad.State
import Control.Monad.State.Class
import System.Random
import qualified Test.QuickCheck as QC
import qualified CLaSH.Sized.Vector as V
import qualified Prelude as HP -- haskell's default prelude


square :: SS32 -> SS32
square x = x*x

adder :: SS32 -> SS32 -> SS32
adder a b = a+b

testOneAdd (a, b, expected) = print $ (sampleN 1 (adder a b)) == [expected :: Signed 32]

testAdder = do
  mapM_ testOneAdd [ (0, 0, 0)
                   , (0xFFFFFFFF, 0, 0xFFFFFFFF)
                   , (0xFFFFFFFF, 0xFFFFFFFF, -2)
                   , (1, 2, 3)
                   ]

-- instance Arbitrary (Signed 32) where
--   -- minBound is a generic function using (Signed 32) as a type
--   -- maxBound also
--   -- choose is a generic function 
--   arbitrary = choose (minBound, maxBound) 

tempMin = minBound :: Signed 32
tempMax = maxBound :: Signed 32

-- sigcat a b = do
--   x <- a -- extracting the value from the signal!
--   y <- b -- extracting the value from the signal!
--   return (x HP.#++ y)




{-# ANN topEntity
  (defTop
    { t_name     = "vga"
    , t_inputs   = []
    , t_outputs  = ["RED", "GRE", "BLU", "VSYNC", "HSYNC", "PX"]
    , t_extraIn  = [ ("CLOCK_25", 1) ]
    , t_clocks   = [clockWizard "clkwiz25" "CLOCK_25(0)" "'0'"]
    }) #-}
    
data Vga = Vga { vgaR :: Bit
               , vgaG :: Bit
               , vgaB :: Bit
               , vgaVSync :: Bit
               , vgaHSync :: Bit
               , hCount :: Unsigned 32
               , vCount :: Unsigned 32
               , pxClock :: Bit
               }

newVga = Vga 0 0 0 0 0 0 0 0
           
type VgaState a = State Vga a

-----------------------------------------------------------------------------
topEntity :: Signal (Bit, Bit, Bit, Bit, Bit, Bit)
topEntity = blinker

-- plumbing
blinker = asStateM scanAll newVga $ signal True

scanAll :: Bool -> VgaState (Bit, Bit, Bit, Bit, Bit, Bit)
scanAll _ = do
  clk <- liftM pxClock get
  state <- get
  put state{pxClock = complement clk}
  scanV
  Vga c _ _ vsync hsync _ _ _ <- get  
  return (c, c, c, vsync, hsync, clk)


------------------------------------------------------------------
-- VERTICAL SCAN

activeHeightV = 480
frontPorchV = activeHeightV + 11
syncPulseV = backPorchV + 2
backPorchV = frontPorchV + 31

scanV :: VgaState ()
scanV = do
  -- this code executes one pixel clock.
  count <- liftM vCount get
  
  when (count < activeHeightV)
    scanLineActive
    
  when (count >= activeHeightV && count < frontPorchV)
    scanLineFrontPorch
    
  when (count >= frontPorchV && count < syncPulseV)
    scanLineSyncPulse
    
  when (count >= syncPulseV && count < backPorchV)
    scanLineBackPorch
    
  incrementCounters
  
scanLineFrontPorch = setVSync 1 >> setPixels 0
scanLineSyncPulse = setVSync 0 >> setPixels 0
scanLineBackPorch = setVSync 1 >> setPixels 0

activeWidthH = 640
frontPorchH = activeWidthH + 16
syncPulseH = backPorchH + 96
backPorchH = frontPorchH + 48

setHSync n = do state <- get
                put state{vgaHSync = n}
                
setVSync n = do state <- get
                put state{vgaVSync = n}

setPixels n = do state <- get
                 put state{ vgaR = n, vgaG = n, vgaB = n };
  
-- 32 micro seconds
scanLineActive :: VgaState ()
scanLineActive = do
  count <- liftM hCount get
  
  -- | active vid | front porch | sync Pulse | back porch
  let goHi = setHSync 1 >> setPixels 1 >> setVSync 1
      goLo = setHSync 0 >> setPixels 0 >> setVSync 1

  when (count < activeWidthH) goHi -- in active video
  when (count >= activeWidthH && count < frontPorchH) goHi -- on front porch
  when (count >= frontPorchH && count < syncPulseH) goLo -- in sync pulse
  when (count >= syncPulseH) goHi -- on back porch

  if count `mod` 3 == 0
    then setPixels 1
    else setPixels 0

incrementCounters = do
  state <- get
  let hc = hCount state
  let vc = vCount state
  
  let hLimit = activeWidthH + frontPorchH + syncPulseH + backPorchH
  let vLimit = activeHeightV + frontPorchV + syncPulseV + backPorchV
  let (hc', vc') = if hc >= hLimit
                   then (0, vc + 1) -- new line!
                   else (hc + 1, vc) -- next pixel.
  
                        
  put state{ hCount = hc'
           , vCount = if vc' >= vLimit then 0 else vc'
           }


------------------------------------------------------------------
-- state plumbing 
asStateM :: (i -> State s o) -> s -> (Signal i -> Signal o)
asStateM f i = mealy g i
  where
    g s x = let (o,s') = runState (f x) s
            in  (s',o)


type SS32 = Signal (Signed 32)


myCounter :: Applicative f => f (Signed 32) -> f (Signed 32)
myCounter curCount =
  do x <- curCount
     return (x + (1 :: Signed 32))



-- temp :: SS32
-- temp cin = (1 :: SS32) `xor` (12 :: SS32)

type SB = Signal Bit

--cla1 :: SB -> SB -> SB -> (SB, SB, SB)

-- cla1 :: SB -> SB -> SB -> SB
-- cla1 cin a b =
--   let p = xor a b
--       s = xor cin p
--       g = a .&&. b
--   in p
-- temp :: SB -> SB -> SB
-- temp x y = x .&&. y

{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module FIR where 

import qualified Prelude as HP -- haskell's default prelude
import CLaSH.Prelude

type SS32 = Signal (Signed 32)

square :: SS32 -> SS32
square x = x*x

adder :: SS32 -> SS32 -> SS32
adder a b = a+b



type B = Signal Bit
type V4 = Signal (BitVector 4)


nand'2 x y = complement (x * y)
not' x = complement x
nand'3 x y z = complement (x * y * z)
nand'4 a b c d = complement (a*b*c*d)

cl4Fast :: V4 -> V4 -> B -> (B, B, Signal (BitVector 3))
cl4Fast g p cin = undefined

asdf = 123 :: Signal (BitVector 4)

-- EXCELLENT.
temp :: V4 -> Signal Bit
temp sig = do -- this is applicative do
  a <- sig -- pull the datatype out of the signal.
  return (a ! 1) -- select bit 1 from BitVector a, and wrap it in a signal

zxcv :: V4 -> Signal Bit
zxcv sig =
  let s1 = do
        a <- sig
        return (a ! 1)
  in s1

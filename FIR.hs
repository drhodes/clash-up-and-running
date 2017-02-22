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

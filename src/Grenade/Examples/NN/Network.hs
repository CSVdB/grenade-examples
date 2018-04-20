{-# LANGUAGE DataKinds #-}

module Grenade.Examples.NN.Network
    ( randomNetworkM
    , param
    ) where

import Grenade
import Grenade.Examples.NN.Param

import Control.Monad.Random.Class

type NN
     = Network '[ Reshape, FullyConnected 784 30, Tanh, FullyConnected 30 10, Logit] '[ 'D2 28 28, 'D1 784, 'D1 30, 'D1 30, 'D1 10, 'D1 10]

randomNetworkM :: MonadRandom m => m NN
randomNetworkM = randomNetwork

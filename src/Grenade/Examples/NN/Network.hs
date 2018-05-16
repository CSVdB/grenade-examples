{-# LANGUAGE DataKinds #-}

module Grenade.Examples.NN.Network
    ( randomNetworkM
    , params
    , optInfo
    , Image
    , Label
    ) where

import Grenade
import Grenade.Examples.NN.Param

import Control.Monad.Random.Class

--type NN = Network '[ Reshape, FullyConnected 784 10] '[ Image, 'D1 784, Label]
type NN
     = Network '[ Reshape, FullyConnected 784 30, Tanh, FullyConnected 30 10, Logit] '[ Image, 'D1 784, 'D1 30, 'D1 30, 'D1 10, Label]

randomNetworkM :: MonadRandom m => m NN
randomNetworkM = randomNetwork

{-# LANGUAGE DataKinds #-}

module Grenade.Examples.CNN.Network
    ( randomNetworkM
    , param
    ) where

import Grenade
import Grenade.Examples.CNN.Param

import Control.Monad.Random.Class

type CNN = Network CNNLayers CNNShapes

type CNNLayers
     = '[ Convolution 1 10 5 5 1 1, Pooling 2 2 2 2, Relu, Convolution 10 16 5 5 1 1, Pooling 2 2 2 2, Reshape, Relu, FullyConnected 256 80, Logit, FullyConnected 80 10, Logit]

type CNNShapes
     = '[ 'D2 28 28, 'D3 24 24 10, 'D3 12 12 10, 'D3 12 12 10, 'D3 8 8 16, 'D3 4 4 16, 'D1 256, 'D1 256, 'D1 80, 'D1 80, 'D1 10, 'D1 10]

randomNetworkM :: MonadRandom m => m CNN
randomNetworkM = randomNetwork

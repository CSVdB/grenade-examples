module Main
    ( main
    ) where

import Grenade.Examples (run)
import qualified Grenade.Examples.MNIST.Load as MNIST
import Grenade.Examples.NN.Network (param, randomNetworkM)

nOfTrain, nOfVal, nOfTest :: Int
nOfTrain = 5000

nOfVal = 1000

nOfTest = 1000

epochs :: Int
epochs = 15

main :: IO ()
main = run epochs param randomNetworkM $ MNIST.load nOfTrain nOfVal nOfTest

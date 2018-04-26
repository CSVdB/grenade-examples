module Main
    ( main
    ) where

import Grenade.Examples (run)
import qualified Grenade.Examples.MNIST.Load as MNIST
import Grenade.Examples.NN.Network
import Grenade.Train.OptimiseHyper (findHyperParamsWithSeveralRuns)

nOfTrain, nOfVal, nOfTest :: Int
nOfTrain = 5000

nOfVal = 1000

nOfTest = 1000

epochs :: Int
epochs = 5

main :: IO ()
main = do
    net <- randomNetworkM
    (trainSet, valSet, _) <- MNIST.load nOfTrain nOfVal nOfTest
    optimisedParams <- findHyperParamsWithSeveralRuns epochs net trainSet valSet optInfo params
    run epochs optimisedParams randomNetworkM $ MNIST.load nOfTrain nOfVal nOfTest

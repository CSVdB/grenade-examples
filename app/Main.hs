module Main
    ( main
    ) where

import Grenade.Examples (run)
import qualified Grenade.Examples.MNIST.Load as MNIST
import Grenade.Examples.NN.Network
import Grenade.Train.HyperParamInfo
import Grenade.Train.OptimiseHyper.Internal

--import Grenade.Train.OptimiseHyper (findHyperParamsWithSeveralRuns)
import Data.Validity

import System.Exit

nOfTrain, nOfVal, nOfTest :: Int
nOfTrain = 5000

nOfVal = 1000

nOfTest = 1000

epochs :: Int
epochs = 5

printValidation :: Validity a => a -> IO ()
printValidation a =
    case prettyValidation a of
        Left errMess -> die errMess
        Right _ -> pure ()

main :: IO ()
main = do
    let load = MNIST.load nOfTrain nOfVal nOfTest
    net <- randomNetworkM
    printValidation net
    (trainSet, valSet, _) <- load
    printValidation trainSet
    printValidation valSet
    printValidation epochs
    printValidation optInfo
    printValidation params
    putStrLn "Starting the optimisation"
--    let trainInfo = getTrainInfo (head optInfo) trainSet valSet
    let info = getHyperParamInfo epochs net trainSet valSet params
    print info
    -- optimisedParams <- findHyperParams epochs net trainInfo Rate params
        --findHyperParamsWithSeveralRuns epochs net trainSet valSet optInfo params
    -- run epochs optimisedParams randomNetworkM load

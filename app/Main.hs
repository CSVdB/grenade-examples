{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}

module Main
    ( main
    ) where

import Data.List

import Grenade

--import Grenade.Examples (run)
--import qualified Grenade.Examples.MNIST.Load as MNIST
--import Grenade.Examples.NN.Network (param)
import Numeric.LinearAlgebra.Static

--nOfTrain, nOfVal, nOfTest :: Int
--nOfTrain = 5000
--
--nOfVal = 1000
--
--nOfTest = 1000
--
--epochs :: Int
--epochs = 5
--
--main :: IO ()
--main = run epochs param randomNetworkM $ MNIST.load nOfTrain nOfVal nOfTest
--
inputs :: [S ('D1 2)]
inputs = S1D <$> [vec2 0 0, vec2 0 1, vec2 1 0, vec2 1 1]

outputs :: [S ('D1 1)]
outputs = S1D <$> [0, 1, 1, 0]

randomNetworkM :: IO Net
randomNetworkM = randomNetwork

type Net
     = Network '[ FullyConnected 2 2, Logit, FullyConnected 2 1, Logit] '[ 'D1 2, 'D1 2, 'D1 2, 'D1 1, 'D1 1]

main :: IO ()
main = do
    let samples = take 100000 $ cycle $ zip inputs outputs
        params = LearningParameters 5e-4 0 0
    net <- randomNetworkM
    putStrLn "Before training:"
    print $ snd $ runNetwork net $ S1D $ vec2 0 0
    print $ snd $ runNetwork net $ S1D $ vec2 0 1
    print $ snd $ runNetwork net $ S1D $ vec2 1 0
    print $ snd $ runNetwork net $ S1D $ vec2 1 1
    let trained =
            foldl'
                (\net (inpt, outpt) -> train params net inpt outpt)
                net
                samples
    putStrLn "After training:"
    print $ snd $ runNetwork trained $ S1D $ vec2 0 0
    print $ snd $ runNetwork trained $ S1D $ vec2 0 1
    print $ snd $ runNetwork trained $ S1D $ vec2 1 0
    print $ snd $ runNetwork trained $ S1D $ vec2 1 1

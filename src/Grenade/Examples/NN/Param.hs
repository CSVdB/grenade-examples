{-# LANGUAGE DataKinds #-}

module Grenade.Examples.NN.Param where

import Import

import Grenade
import Grenade.Train.HyperParams
import Grenade.Train.OptimiseHyper

import Numeric.Natural

import Control.Monad.Catch

type Image = 'D2 28 28

type Label = 'D1 10

params :: HyperParams
params =
    case createHyperParams 3 0.9 2 0.99 of
        Left err -> error err
        Right params -> params

optInfo :: [HyperParamOptInfo]
optInfo = [unsafeHyperParamOptInfo 4 0.95 5000 1000 0.9 100 0.5]

unsafeHyperParamOptInfo ::
       Double
    -> Double
    -> Int
    -> Int
    -> Double
    -> Natural
    -> Double
    -> HyperParamOptInfo
unsafeHyperParamOptInfo updateFactor updateFactorDecay trainSize valSize requiredAcc maxIter alpha =
    case getHyperParamOptInfo uf ufd trainS valS requiredAcc maxIter alp of
        Left err -> error err
        Right x -> x
  where
    result = do
        ufE <- constructLogDouble updateFactor
        ufdE <- leftToString $ constructProperFraction updateFactorDecay
        trainSE <- leftToString $ constructPositiveInt trainSize
        valSE <- leftToString $ constructPositiveInt valSize
        alpE <- constructLogDouble alpha
        pure (ufE, ufdE, trainSE, valSE, alpE)
    (uf, ufd, trainS, valS, alp) =
        case result of
            Right x -> x
            Left err -> error err
    leftToString :: Either SomeException a -> Either String a
    leftToString (Left err) = Left $ displayException err
    leftToString (Right x) = Right x

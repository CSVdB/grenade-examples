{-# LANGUAGE DataKinds #-}

module Grenade.Examples.NN.Param where

import Import

import Grenade
import Grenade.Train.HyperParams
import Grenade.Train.OptimiseHyper

import Numeric.Natural

type Image = 'D2 28 28

type Label = 'D1 10

params :: HyperParams
params = case createHyperParams 3 0.9 2 0.99 of
    Left err -> error err
    Right params -> params

optInfo :: [HyperParamOptInfo]
optInfo = [unsafeHyperParamOptInfo 4 0.95 5000 1000 0.9 100 0.5]

unsafeHyperParamOptInfo :: Double -> Double -> Int -> Int -> Double -> Natural -> Double -> HyperParamOptInfo
unsafeHyperParamOptInfo updateFactor updateFactorDecay trainSize valSize requiredAcc maxIter alpha =
    case getHyperParamOptInfo updateFactor updateFactorDecay trainSize valSize requiredAcc maxIter alpha of
        Left err -> error err
        Right info -> info

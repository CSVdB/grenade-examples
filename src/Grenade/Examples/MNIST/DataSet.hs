{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DataKinds #-}

module Grenade.Examples.MNIST.DataSet
    ( MNISTData
    , MNISTDataPoint
    , MNISTDataSets
    , Image
    , Label
    , nOfOutputs
    , nOfRows
    , nOfCols
    ) where

import Import

import Grenade
import Grenade.Run

type NOfOutputs = 10

type NOfRows = 28

type NOfCols = 28

nOfOutputs, nOfRows, nOfCols :: Int
nOfOutputs = fromInteger $ natVal (Proxy @NOfOutputs)

nOfRows = fromInteger $ natVal (Proxy @NOfRows)

nOfCols = fromInteger $ natVal (Proxy @NOfCols)

type MNISTDataPoint = DataPoint Image Label

type Image = 'D2 NOfRows NOfCols

type Label = 'D1 NOfOutputs

type MNISTData = DataSet Image Label

type MNISTDataSets = DataSets Image Label

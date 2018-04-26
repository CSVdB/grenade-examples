module Grenade.Examples.CNN.Param
    ( param
    ) where

import Import

import Grenade

param :: LearningParameters
param = case createLearningParameters 0.0005 0 0000 of
    Left err -> error err
    Right params -> params

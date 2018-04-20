module Grenade.Examples.CNN.Param
    ( param
    ) where

import Grenade (LearningParameters(..))

param :: LearningParameters
param =
    LearningParameters
    {learningRate = 0.0005, learningMomentum = 0, learningRegulariser = 0.00000}

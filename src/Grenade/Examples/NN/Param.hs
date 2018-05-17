module Grenade.Examples.NN.Param
    ( param
    ) where

import Grenade (LearningParameters(..))

param :: LearningParameters
param =
    LearningParameters
        {learningRate = 1, learningMomentum = 0, learningRegulariser = 0.0000}

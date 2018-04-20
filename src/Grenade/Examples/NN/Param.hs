module Grenade.Examples.NN.Param
    ( param
    ) where

import Grenade (LearningParameters(..))

param :: LearningParameters
param =
    LearningParameters
    {learningRate = 3, learningMomentum = 1, learningRegulariser = 0}

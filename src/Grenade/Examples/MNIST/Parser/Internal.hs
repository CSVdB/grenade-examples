module Grenade.Examples.MNIST.Parser.Internal where

import Import

import Grenade (S, fromStorable)
import Grenade.Utils.OneHot (oneHot)

import qualified Data.Vector.Storable as VS

import Grenade.Examples.MNIST.DataSet
import Utils.Parser

import Text.Megaparsec.Byte

type Pixel = Double

maxPixel :: Double
maxPixel = 256

pixelParser :: Parser Pixel
pixelParser = (/ maxPixel) . fromIntegral <$> anyChar

imageParser :: Parser (S Image)
imageParser = do
    pixels <- replicateM (nOfRows * nOfCols) pixelParser
    maybe (fail "Can't parse image") pure . fromStorable $ VS.fromList pixels

labelParser :: Parser (S Label)
labelParser = do
    c <- anyChar
    case oneHot $ fromIntegral c of
        Nothing -> fail "label > 9"
        Just x -> pure x

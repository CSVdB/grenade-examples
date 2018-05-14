module Grenade.NetSpec
    ( spec
    ) where

import TestImport

import Test.Hspec

import Grenade.Examples.MNIST.Parser.Internal

import qualified Data.ByteString.Lazy as BS

import qualified Text.Megaparsec as MP

spec :: Spec
spec =
    describe "pixelParser" $
    it "unit test" $
    let pixel = MP.runParser pixelParser "" $ BS.pack [5]
     in pixel `shouldBe` Right (5 / 256)

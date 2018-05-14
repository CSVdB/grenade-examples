module Grenade.Examples.MNIST.Load
    ( load
    ) where

import Import

import Grenade.Examples.MNIST.DataSet
import Grenade.Examples.MNIST.Parser
import Utils.Files
import Utils.Parser
import Utils.Zip

import Data.Validity

data DataSetException
    = NotEnoughDataPoints String
    | MissingDataSet String
    deriving (Show, Eq)

instance Exception DataSetException where
    displayException (NotEnoughDataPoints action) =
        "There are not enough data points for " ++ action ++ "."
    displayException (MissingDataSet name) =
        "There is no data set called " ++ name ++ "."

dataDir :: MonadIO m => m (Path Abs Dir)
dataDir = resolveDir' "data/"

notEnoughData :: MonadThrow m => String -> m a
notEnoughData = throwM . NotEnoughDataPoints

load ::
       (MonadIO m, MonadThrow m)
    => Int
    -> Int
    -> Int
    -> m (MNISTData, MNISTData, MNISTData)
load nOfTrain nOfVal nOfTest = do
    dir <- dataDir
    (_, files) <- liftIO $ listDir dir
    fullTrainDataSet <- getDataSet files "train"
    fullTestDataSet <- getDataSet files "test"
    let (trainSet, valSet) = take nOfVal <$> splitAt nOfTrain fullTrainDataSet
        testSet = take nOfTest fullTestDataSet
    when (length trainSet /= nOfTrain) $ notEnoughData "training"
    when (length valSet /= nOfVal) $ notEnoughData "validating"
    when (length testSet /= nOfTest) $ notEnoughData "testing"
    pure (trainSet, valSet, testSet)

getDataSet ::
       (MonadIO m, MonadThrow m) => [Path Abs File] -> String -> m MNISTData
getDataSet files name =
    case getFilesFromList files name of
        Nothing -> throwM $ MissingDataSet name
        Just (trainImageFile, trainLabelFile) -> do
            imagesAsBL <- readFilePretty trainImageFile
            labelsAsBL <- readFilePretty trainLabelFile
            loadDataSet (imagesAsBL, labelsAsBL)

getFilesFromList ::
       [Path Abs File] -> String -> Maybe (Path Abs File, Path Abs File)
getFilesFromList paths name = do
    imagePath <-
        find (\path -> toRelFilePath path == name ++ "-images-idx3-ubyte") paths
    labelPath <-
        find (\path -> toRelFilePath path == name ++ "-labels-idx1-ubyte") paths
    pure (imagePath, labelPath)

toRelFilePath :: Path Abs File -> FilePath
toRelFilePath = toFilePath . filename

loadDataSet :: MonadThrow m => (ByteString, ByteString) -> m MNISTData
loadDataSet (imageBL, labelBL) = do
    images <- runParserPretty imageFileParser imageBL
    labels <- runParserPretty labelFileParser labelBL
    dataSet <- images >< labels
    case prettyValidation dataSet of
        Left errMess -> error errMess
        Right dataSet -> pure dataSet

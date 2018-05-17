module Grenade.Examples.MNIST.Load
    ( load
    ) where

import Import

import Grenade.Examples.MNIST.DataSet
import Grenade.Examples.MNIST.Parser
import Grenade.Run
import Utils.Files
import Utils.Parser
import Utils.Zip

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

load :: (MonadIO m, MonadThrow m) => Int -> Int -> Int -> m MNISTDataSets
load nOfTrain nOfVal nOfTest = do
    dir <- dataDir
    (_, files) <- liftIO $ listDir dir
    fullTrainDataSet <- getDataSet (nOfTrain + nOfVal) files "train"
    testSet <- getDataSet nOfTest files "test"
    let (trainSet, valSet) = splitAt nOfTrain fullTrainDataSet
    when (length trainSet /= nOfTrain) $ notEnoughData "training"
    when (length valSet /= nOfVal) $ notEnoughData "validating"
    when (length testSet /= nOfTest) $ notEnoughData "testing"
    pure $ DataSets trainSet valSet testSet

getDataSet ::
       (MonadIO m, MonadThrow m)
    => Int
    -> [Path Abs File]
    -> String
    -> m MNISTData
getDataSet size files name =
    case getFilesFromList files name of
        Nothing -> throwM $ MissingDataSet name
        Just (trainImageFile, trainLabelFile) -> do
            imagesAsBL <- readFilePretty trainImageFile
            labelsAsBL <- readFilePretty trainLabelFile
            loadDataSet size (imagesAsBL, labelsAsBL)

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

loadDataSet :: MonadThrow m => Int -> (ByteString, ByteString) -> m MNISTData
loadDataSet size (imageBL, labelBL) = do
    images <- runParserPretty (imageFileParser size) imageBL
    labels <- runParserPretty (labelFileParser size) labelBL
    dataSet <- images >< labels
    pure $ fmap (\(a, b) -> (a / 256, b / 256)) dataSet

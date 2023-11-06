{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Application where

import System.Random
import Yesod

data App = App
  { appRandomNumber :: IO Int
  }

mkYesod "App" [parseRoutes|
/random RandomR GET
|]

instance Yesod App

randomNumber :: IO Int
randomNumber = randomRIO (1, 100)

getRandomR :: Handler Value
getRandomR = do
  n <- liftIO =<< getsYesod appRandomNumber
  returnJson $ isEven n
  where
    isEven :: Int -> String
    isEven n = if even n then "even" else "odd"

appMain :: IO ()
appMain = warp 3000 $ App randomNumber

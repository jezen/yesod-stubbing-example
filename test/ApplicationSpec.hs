{-# LANGUAGE OverloadedStrings #-}

module ApplicationSpec where

import TestImport

spec :: Spec
spec = withApp $ do

  describe "GET /random" $ do

    it "works with even numbers" $ do
      stub (\a -> a { appRandomNumber = pure 66 })
      get RandomR
      statusIs 200
      bodyEquals "\"even\""

    it "works with odd numbers" $ do
      stub (\a -> a { appRandomNumber = pure 17 })
      get RandomR
      statusIs 200
      bodyEquals "\"odd\""

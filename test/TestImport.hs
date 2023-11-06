module TestImport
  ( module TestImport
  , module X
  ) where

import Application as X
import Test.Hspec as X
import Yesod.Core (YesodDispatch)
import Yesod.Test as X

withApp :: SpecWith (TestApp App) -> Spec
withApp = before $ do
  pure (App randomNumber, id)

stub :: YesodDispatch a => (a -> a) -> YesodExample a ()
stub f = testModifySite (\app -> pure (f app, id))

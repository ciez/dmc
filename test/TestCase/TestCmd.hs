module TestCase.TestCmd where

import Test.Hspec
import Debug.Trace
import System.Process.Dmc
import System.Process.TypeDmc
import System.Exit


main::IO()
main = hspec $ do
       describe ".TestCmd" $ do
          it "call pwd" $ do
            (ExitSuccess, res1 , _) <- call (Cwd ".") (Cmd "pwd") []
            traceIO $ show res1
            Right () <- run (Cwd ".") (Cmd "echo") [Arg "dmc test run"]
            Right () <- shell (Cwd ".") (Cmd "echo \"dmc test shell\"")
            1 `shouldBe` 1
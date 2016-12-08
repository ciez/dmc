module System.Process.Dmc
        (run,
        shell,
        call,
        quote,
        join) where


import qualified System.Process as P
import System.Exit
import System.Process.TypeDmc
import Data.List
import Data.Coerce


{- | run executable with args
    
    waits 
    
    'Left' 'String' indicates error     -}
run::Cwd -> Cmd String -> [Arg String] -> IO (Either String ())
run = runCommon fn1
        where fn1 cwd1 (Cmd sh1) arg1 = P.proc sh1 $ coerce <$> arg1

{- | run shell cmd

    waits       
    
    'Left' 'String' indicates error     -}
shell::Cwd -> Cmd String -> IO (Either String ())
shell cwd0 cmd0 = runCommon fn1 cwd0 cmd0 []
        where fn1 cwd1 (Cmd sh1) _ = P.shell sh1


runCommon::(Cwd -> Cmd String -> [Arg String] -> P.CreateProcess) ->
    Cwd -> Cmd String -> [Arg String] ->
            IO (Either String ())
runCommon cp0 cwd0 sh0 arg0 = do
            (in1, out1, err1, ph1) <- P.createProcess p2
            code1 <- P.waitForProcess ph1
            case code1 of
                ExitSuccess -> pure $ Right ()
                ExitFailure i -> pure $ Left $ show ("cmd failed", i, cwd0, sh0, arg0)
        where p1 = cp0 cwd0 sh0 arg0
              Cwd cwd1 = cwd0
              p2 = p1 {
                P.cwd = Just cwd1
              }


-- | call cmd, get output 
call::Cwd -> Cmd String -> [Arg String] -> IO (ExitCode, Stdout, Stderr)
call (Cwd cwd0) (Cmd sh0) arg0 =
    P.readCreateProcessWithExitCode p2 "" >>= 
    \(code1, std1, err1) ->
        pure (code1, Stdout std1, Stderr err1) 
        where p1 = P.proc sh0 $ coerce <$> arg0
              p2 = p1 {
                P.cwd = Just cwd0
              }


-- | enclose 'String' in \"\"
quote::String -> String
quote s0 = "\"" ++ s0 ++ "\""


-- | join 'String' with \" \" : useful to construct 'shell' cmd 
join::[String] -> String
join = intercalate " "
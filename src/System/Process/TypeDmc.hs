{-# LANGUAGE DeriveFunctor #-}
module System.Process.TypeDmc where

-- | current working dir
newtype Cwd = Cwd FilePath deriving Show

-- | cmd or file
newtype Cmd a = Cmd a deriving (Show,Functor)   

-- | arg to executable
newtype Arg a = Arg a deriving (Show,Functor)

-- | stdout output
newtype Stdout = Stdout String deriving Show

-- | stderr output
newtype Stderr = Stderr String deriving Show

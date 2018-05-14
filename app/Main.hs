{-# LANGUAGE OverloadedStrings #-}
module Main where

import Task
import Data.Aeson
import qualified Data.ByteString.Lazy as BS

main :: IO ()
main = BS.putStr $ encode Task { title = "Hello"
                          , desc  = "World"
                          , done  = False
                          }

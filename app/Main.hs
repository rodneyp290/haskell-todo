{-# LANGUAGE OverloadedStrings #-}
module Main where

import Task
import Data.Aeson
import Data.Aeson.Encode.Pretty
import qualified Data.ByteString.Lazy as BS
import Options.Applicative
import Data.Semigroup ((<>))

pointless :: Task
pointless = Task {
              title = "Remove Todo"
              , desc = "I have too many todos, I need to remove some"
              , done = False
              }

data Usage = Usage {
               file :: FilePath
               }

usage :: Parser Usage
usage = Usage
        <$> strOption
          (long "file"
          <> metavar "TODO-FILE"
          <> value "todo.json"
          <> help "JSON file containing the todo lists"
          )


main :: IO ()
main = do
  todoFile <- pure.file =<< execParser (info (helper <*> usage)
          ( fullDesc
          <> progDesc "CLI todo app"
          <> header "todo - a CLI todo app written in haskell" ))
  json <- BS.readFile todoFile
  let eLists = eitherDecode json :: Either String Lists
  case eLists of
    Left reason -> do
      putStr reason
      putStr "\n"
    Right (lists) -> do
      print lists
      let new_lists = addTask lists "second_list" pointless
      print "Added new todo task"
      print new_lists
      BS.writeFile todoFile (encodePretty new_lists)


--BS.putStr $ encode Task { title = "Hello"
--                          , desc  = "World"
--                          , done  = False
--                          }

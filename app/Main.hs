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
               , tCmd :: TaskCommand
               }
     deriving Show

usage :: Parser Usage
usage = Usage <$> file <*> tCommand
  where file = strOption
          (long "file"
          <> metavar "TODO-FILE"
          <> value "todo.json"
          <> help "JSON file containing the todo lists"
          )
        tCommand = subparser $
             cmd addP "add" "Add task to list"
          <> cmd delP "delete" "Delete first matching task from list"
          <> cmd comP "complete" "Complete first matching uncompleted task from list" 
          <> cmd clrP "list" "Clear list"
          <> cmd seeP "clear" "Clear list"
        addP = Add <$> strArg "LIST" <*> strArg "TITLE" <*> strArg "DESC"
        delP = Delete <$> strArg "LIST" <*> strArg "TITLE"
        comP = Complete <$> strArg "LIST"<*> strArg "TITLE"
        clrP = Clear <$> strArg "LIST"
        seeP = See <$> strArg "LIST"
        cmd p n d = command n (info (helper <*> p) (progDesc d))
        strArg n = strArgument (metavar n)


main :: IO ()
main = do
  execution <- execParser (info (helper <*> usage)
          ( fullDesc
          <> progDesc "CLI todo app"
          <> header "todo - a CLI todo app written in haskell" ))

  let todoFile = file execution
  print execution

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

{-# LANGUAGE TemplateHaskell #-}
module Task where 

import Data.Text
import Data.HashMap.Strict
import Data.Aeson
import Data.Aeson.TH

data Task = Task 
  { title :: Text
  , desc  :: Text
  , done  :: Bool
  } deriving (Show,Eq)

type Lists = HashMap Text [Task]

addTask :: Lists -> Text -> Task -> Lists
addTask current list task = insertWith listAdd list [task] current
  where listAdd old new = old ++ new

$(deriveJSON defaultOptions ''Task ) -- "Haskell Macro" / "Template Haskell"
-- TIP: put templates at bottom of code

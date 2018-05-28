{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Task where 

import Data.String
import Data.Text
import Data.HashMap.Strict
import Data.Aeson
import Data.Aeson.TH

newtype LName = LName Text deriving (Show, Eq, IsString, ToJSON, FromJSON)
newtype TName = TName Text deriving (Show, Eq, IsString, ToJSON, FromJSON)
newtype TDesc = TDesc Text deriving (Show, Eq, IsString, ToJSON, FromJSON)

data Task = Task 
  { title :: TName
  , desc  :: TDesc
  , done  :: Bool
  } deriving (Show,Eq)

type Lists = HashMap Text [Task]

data TaskCommand = Add LName TName TDesc
                 | Delete LName TName
                 | Complete LName TName
                 | Clear LName
                 | See LName
      deriving (Show)

addTask :: Lists -> LName -> Task -> Lists
addTask current (LName list) task = insertWith (++) list [task] current

$(deriveJSON defaultOptions ''Task ) -- "Haskell Macro" / "Template Haskell"
-- TIP: put templates at bottom of code

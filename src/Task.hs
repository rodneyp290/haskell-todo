module Task where 
import Data.Text
import Data.HashMap.Strict

data Task = Task 
  { title :: Text
  , desc  :: Text
  , done  :: Bool
  }

type Lists = HashMap Text [Task]

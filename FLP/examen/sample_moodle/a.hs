import Control.Monad.Writer
import Control.Monad.State

import Control.Monad.Reader

-- Writer transformer

type M a = WriterT [String] IO a

doStuff :: M String
doStuff = do
    tell ["Entered dostufff"]
    return "Helloo"

getInputAndWrite :: M Int
getInputAndWrite = do
    stuff <- doStuff
    tell $ ["Received " ++ stuff]
    lift $ putStrLn ("Received " ++ stuff)
    lift $ putStr "Please enter a number:"
    val <- lift $ readLn
    return val

-- State transformer

type M2 a = StateT String IO a

doStateStuff :: M2 String
doStateStuff = do
    s_act <- get 
    put "Hello"
    return s_act
    

main = do
    let io = runWriterT getInputAndWrite
    val <- io
    print val


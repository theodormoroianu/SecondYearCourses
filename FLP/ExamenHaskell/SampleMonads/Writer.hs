import Control.Monad.Writer

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


main = do
    let io = runWriterT getInputAndWrite
    val <- io
    print val


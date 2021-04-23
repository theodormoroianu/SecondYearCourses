import Control.Monad.State

-- put
-- get
-- lift


doStuff :: StateT Int IO String
doStuff = do
    s <- get
    lift $ print s
    new_s <- lift getLine -- readLn :: IO Int as a type
    lift $ print new_s
    put 12
    return new_s

stopMaybe :: StateT a Maybe b
stopMaybe = StateT $ const Nothing 

maybeDoStuff :: StateT Int Maybe String
maybeDoStuff = do
    s <- get
    put (s + 1)
    return "Hello"

main :: IO ()
main = do
    let x = runStateT maybeDoStuff 10
    print x
    let i = runStateT doStuff 10
    s <- i
    print s

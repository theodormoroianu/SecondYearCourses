import Control.Monad.Reader

type M a = ReaderT Int IO a

showW :: M Int
showW = do
    x <- ask
    lift $ putStrLn (show x)
    lift $ putStrLn "Haha"
    return x

idkRandomFun :: M Int
idkRandomFun = do
    let new_mon = local (+1) showW
    lift $ putStrLn "Called local"
    new_mon

main = do
    let v_io = runReaderT idkRandomFun 10
    ans <- v_io
    print ans
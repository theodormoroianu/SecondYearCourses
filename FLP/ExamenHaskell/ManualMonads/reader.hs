import Data.Maybe

newtype Reader a b = Reader { runReader :: a -> b }

instance Monad (Reader a) where
    return x = Reader $ const x
    mon >>= fun =
        Reader $ \state ->
            let new_val = runReader mon state in
            runReader (fun new_val) state

instance Applicative (Reader a) where
    pure = return
    a <*> b = do
        f <- a
        x <- b
        return $ f x

instance Functor (Reader a) where
    fmap f x = do
        a <- x
        return $ f a

type Name = String

data AST
    = Var Name
    | AST :+: AST
    | Con Int
    | App AST AST
    | Lam Name AST

type Env = [(Name, Value)]
type M = Reader Env

get :: Reader a a
get = Reader id

local :: Env -> M a -> M a
local env mon = Reader $ \_ -> runReader mon env

data Value
    = Nr Int
    | Fn (Value -> Value)
    | Err

instance Show Value where
    show (Nr a) = show a
    show (Fn _) = "<function>"
    show Err = "<error>"

citeste :: AST -> M Value
citeste (Con x) = return $ Nr x
citeste (a :+: b) = do
    x <- citeste a
    y <- citeste b
    case (x, y) of
        (Nr a, Nr b) -> return $ Nr (a + b)
        _ -> return Err 
citeste (Var name) = do
    env <- get
    return $ fromJust $ lookup name env
citeste (App a b) = do
    x <- citeste a
    y <- citeste b
    case x of
        Fn f -> return $ f y
        _ -> return Err
citeste (Lam name b) = do
    env <- get
    let lambd :: Value -> Value
        lambd x =
            let new_env = (name, x):env
                value = runReader (citeste b) new_env in
            value
    return $ Fn lambd

expr = 
    App (Lam "x" (App (Lam "y"
                      (Var "x" :+: Var "y" :+: Con 10))
                      (Con 5)
                 ))
        (Con 6)
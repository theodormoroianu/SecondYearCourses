import Data.Maybe

newtype Reader a b = Reader { runReader :: a -> b }

instance Monad (Reader a) where
    return x = Reader (const x)
    r1 >>= f =
        Reader (\input ->
            let output1 = runReader r1 input in
            runReader (f output1) input)

instance Applicative (Reader a) where
    pure = return
    f <*> o = do
        a <- f
        b <- o
        return $ a b

instance Functor (Reader a) where
    fmap a b = do
        x <- b
        return $ a x

type Name = String

data AST
    = I Int
    | Var Name
    | App AST AST
    | Lam Name AST
    | AST :+: AST
    deriving Show

type Env = [(Name, Value)]

a = App (Lam "x" (I 10 :+: Var "x")) (I 20)

type M = Reader Env


data Value
    = Nr Int
    | Fn (Value -> M Value)
    | Err

instance Show Value where
    show (Nr a) = show a
    show (Fn _) = "<function>"
    show Err = "<err>"


get :: M Env
get = Reader id

changeEnv :: Env -> M a -> M a
changeEnv env m =
    Reader (\_ -> runReader m env)

eval :: AST -> M Value
eval (I a) = return $ Nr a
eval (Var name) = do
    env <- get
    return $ fromMaybe Err (lookup name env)
eval (App a b) = do
    v1 <- eval a
    v2 <- eval b
    case v1 of
        Fn f -> f v2
        _ -> return Err
eval (Lam name exp) = do
    env <- get
    let fn :: Value -> M Value
        fn val = do
            changeEnv ((name, val):env) (eval exp)
    return $ Fn fn
eval (a :+: b) = do
    x <- eval a
    y <- eval b
    case (x, y) of
        (Nr a, Nr b) -> return $ Nr (a + b)
        _ -> return Err

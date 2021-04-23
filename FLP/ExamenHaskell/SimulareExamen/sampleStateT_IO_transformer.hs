import Control.Monad.State

type Name = String

data Term
    = Var Name
    | Con Int
    | Term :+: Term
    | Lam Name Term
    | App Term Term
    | Out Term
    | In
    deriving Show

pgm = App (Lam "x" (Var "x" :+: Var "x")) (Out $ Con 10 :+: In)

type Env = [(Name, Int)]

data Value
    = Nr Int
    | Fn (Int -> M Value)
    | Err

instance Show Value where
    show (Nr a) = show a
    show (Fn _) = "<function>"
    show Err = "<error>"

type M = StateT Env IO

eval :: Term -> M Value
eval (Var name) = do
    env <- get
    case lookup name env of
        Nothing -> return Err
        Just a -> return $ Nr a
eval (Con i) = return $ Nr i
eval (a :+: b) = do
    x <- eval a
    y <- eval b
    case (x, y) of
        (Nr a, Nr b) -> return $ Nr (a + b)
        _ -> return Err
eval (Lam name exp) = do
    env <- get
    let f x = do
        old_env <- get
        put $ (name, x):env
        rez <- eval exp
        put old_env   
        return rez
    return $ Fn f
eval (App f e) = do
    fn <- eval f
    exp <- eval e
    case (fn, exp) of
        (Fn f, Nr a) -> f a
        _ -> return Err
eval (Out a) = do
    val <- eval a
    lift $ print val
    return val    
eval In = do
    i <- lift readLn
    return $ Nr i


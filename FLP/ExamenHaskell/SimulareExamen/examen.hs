import Control.Monad
import Data.Maybe

type Name = String
data Term
    = Var Name
    | Con Integer
    | Term :+: Term
    | Term :/: Term
    | Lam Name Term
    | App Term Term
    | Out Term
    deriving Show

pgm1 =
    App (Lam "x" (Var "x" :+: Var "x"))
    (Out (Con 10) :+: Out (Con 3))

newtype Writer a = Writer { runwriter :: Maybe (a, String) }

instance Monad Writer where
    return a = Writer $ Just (a, "")
    x >>= f =
        case runwriter x of
            Just (val1, str1) ->
                case runwriter (f val1) of
                    Just (val2, str2) ->
                        Writer $ Just (val2, str1 ++ "\n" ++ str2)
                    _ -> Writer Nothing
            _ -> Writer Nothing

instance Applicative Writer where
    pure = return
    f <*> g = do
        x <- f
        y <- g
        return $ x y

instance Functor Writer where
    fmap f a = pure f <*> a

type M a = Writer a

showM :: Show a => M a -> String
showM ma =
    case runwriter ma of
        Just (w, a) -> "Output: " ++ a ++ ", value: " ++ show w
        Nothing -> "Nothing"

data Value
    = Num Integer
    | Fun (Value -> M Value)

type Env = [(Name, Value)]

instance Show Value where
    show (Num x) = show x
    show (Fun _) = "<function>"

get :: Name -> Env -> M Value
get name env =
    case lookup name env of
        Just a -> return a
        _ -> Writer Nothing

tell :: String -> M ()
tell s = Writer $ Just ((), s)
    

interp :: Term -> Env -> M Value
interp (Var name) env = get name env
interp (Con i) _ = return $ Num i
interp (a :+: b) env = do
    x1 <- interp a env
    x2 <- interp b env
    case (x1, x2) of
        (Num a, Num b) -> return $ Num (a + b)
        _ -> Writer Nothing
interp (a :/: b) env = do
    x1 <- interp a env
    x2 <- interp b env
    case (x1, x2) of
        (_, Num 0) -> Writer Nothing
        (Num a, Num b) -> return $ Num $ a `div` b
        _ -> Writer Nothing
interp (Lam name term) env =
    return (Fun (\val -> interp term ((name, val) : env)))
interp (App a b) env = do
    v1 <- interp a env
    v2 <- interp b env
    case v1 of
        Fun f -> f v2
        _ -> Writer Nothing 
interp (Out x) env = do
    v <- interp x env
    tell $ "Value is " ++ show v
    return v



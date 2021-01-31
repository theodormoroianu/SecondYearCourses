
-- Recapitulare

-- Tipuri
b :: Bool
b = True

l :: [] Int -- [Int]
l = 1:2:3:[]


p :: IO Int
p = do
    a <- readLn :: IO Int
    return (a + 1)

afiseaza :: IO ()
afiseaza = do
    suma <- p
    print suma
import Data.Char

data Container a
    = Data a [String]
    | Error String

instance Foldable Container where
    foldMap f (Error _) = mempty 
    foldMap f (Data a _) = f a

instance Eq a => Eq (Container a) where
    (Error _) == (Error _) = True
    (Data a _) == (Data b _) = a == b
    _ == _ = False

instance Show a => Show (Container a) where
    show (Error s) = "Error: " ++ s
    show (Data a logs) =
        "Data: " ++ show a ++ "\nlogs: " ++ show logs


-- Monad, and then rest 
instance Monad Container where
    return a = Data a []
    (Error s) >>= f = Error s
    (Data a logs) >>= f =
        case f a of
            Error e -> Error e
            Data b logs2 -> Data b (logs ++ ["Apply monad"] ++ logs2)

instance Functor Container where
    fmap f container = do
        a <- container
        return $ f a

instance Applicative Container where
    pure = return
    c1 <*> c2 = do
        f <- c1
        a <- c2
        return $ f a



toIgnore :: Container ()
toIgnore = Data () ["Hahaha"]

fn = Data (^2) ["functie"]
val = Data 10 ["Val"]


-- clasic
fact :: Integer -> Integer
fact 0 = 1
fact n =
    let factn1 = fact (n - 1) in
    n * factn1

-- Tail-Recursive
fact' :: Integer -> Integer -> Integer
fact' 0 ans = ans
fact' n ans = fact' (n - 1) (ans * n)

-- Continuation-based
fact'' :: Integer -> (Integer -> Integer) -> Integer
fact'' 0 f = f 1
fact'' n f =
    fact'' (n - 1) (\x -> f $ x * n)


data Tree a
    = Leaf a
    | Node (Tree a) (Tree a)

dfs :: Tree a -> [a]
dfs (Leaf a) = [a]
dfs (Node st dr) = dfs st ++ dfs dr

dfs' :: Tree a -> ([a] -> [a]) -> [a]
dfs' (Leaf a) cont = cont [a]
dfs' (Node st dr) cont =
    dfs' st (\ans -> let dreapta = dfs' dr id in
                     cont $ ans ++ dreapta)


a = Node (Node (Leaf 10) (Leaf 44)) (Leaf 43)

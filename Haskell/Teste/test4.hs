import Data.List
import Data.Char
import Test.QuickCheck

data Pers = P String Integer deriving Show

data Collection = Collect [Pers] deriving Show

-- Ex 1

isValid :: Collection -> Bool
isValid (Collect p) =
    all (\(P _ x) -> x >= 1 && x <= 100) p

a = Collect [P "A" 4, P "B" 9]
b = Collect [P "A" 4, P "B" (-9)]

colectValid :: [Collection] -> [Collection]
colectValid =
    filter isValid

checkAge :: Collection -> Collection -> Bool
checkAge (Collect a) (Collect b) =
    if length a /= length b then
        error "Not the same length!"
    else
        let zipF :: Pers -> Pers -> Bool
            zipF (P _ x) (P _ y) = x == y in
        foldr (&&) True $ zipWith zipF a b


class ToFromList a where
    toList :: a -> ([String], [Integer])
    fromList :: [String] -> [Integer] -> a

instance ToFromList Collection where
    toList (Collect c) =
        let strs = map (\(P a _) -> a) c
            ints = map (\(P _ a) -> a) c in
        (strs, ints)
    fromList strs ints =
        Collect $ zipWith P strs ints


map' :: (a -> b) -> [a] -> [b]
map' f = foldr (\x acc -> f x : acc) []

filter' :: (a -> Bool) -> [a] -> [a]
filter' f = foldr (\x acc -> if f x then x : acc else acc) []

mapIsSame :: [Int] -> Bool
mapIsSame l = map' (\x -> x ^ 10) l == map (\x -> x ^ 10) l

filterIsSame :: [Int] -> Bool
filterIsSame l = filter' (\x -> even x) l == filter even l
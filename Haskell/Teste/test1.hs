import Data.List
import Data.Char
import Test.QuickCheck

data Punct
    = Pt [Int]
    deriving Show

nrPozitive :: Punct -> Int
nrPozitive (Pt l) =
    length . filter (>0) $ l

z3Poz :: [Punct] -> [Punct]
z3Poz =
    let isValid :: Punct -> Bool
        isValid (Pt p) =
            nrPozitive (Pt p) == 3 && length p == 3 in
    filter isValid

calculeaza :: Punct -> Punct -> Int
calculeaza (Pt a) (Pt b) =
    if length a /= length b then
        error "Lungimi diferite!"
    else
        sum $ zipWith (\a b -> (a + b) ^ 2) a b 

class ToFromParts a where
    toParts :: a -> [a]
    fromParts :: [a] -> a

instance ToFromParts Punct where
    toParts (Pt l) = [Pt [x] | x <- l]
    fromParts a =
        Pt $ foldr (\(Pt l) acc -> l ++ acc) [] a 


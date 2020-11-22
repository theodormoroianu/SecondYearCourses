import Test.QuickCheck
import Data.Char

-- L3.1
factori :: Int -> [Int]
factori f = [x | x <- [1..f], f `mod` x == 0]

prim :: Int -> Bool
prim n = factori n == [1, n]

numerePrime :: [Int]
numerePrime = [x | x <- [1..], prim x]

-- L3.2
aplica2 :: (a -> a) -> a -> a
aplica2 f a = f $ f a

-- L3.3
firstEl :: [(a, b)] -> [a]
firstEl = map fst

pre12 :: [Int] -> [Int]
pre12 =
    let modif :: Int -> Int
        modif x =
            if even x then
                x `div` 2
            else
                2 * x in
    map modif

-- L3.4
filterChar :: Char -> [[Char]] -> [[Char]]
filterChar c =
    filter (elem c)

patratImpare :: [Integer] -> [Integer]
patratImpare =
    map (^2) . filter odd

patrateAtImpare :: [Integer] -> [Integer]
patrateAtImpare l =
    let z = zip l [1..] in
    let good = filter (\(_, y) -> odd y) z in
    map (\(x, _) -> x^2) good

removeConsoane :: [[Char]] -> [[Char]]
removeConsoane l =
    let consoane = "aeiou" in
    let removeFromStr :: [Char] -> [Char]
        removeFromStr = filter (\x -> toLower x `notElem` consoane) in
    map removeFromStr l

-- L3.5
myMap :: (a -> b) -> [a] -> [b]
myMap _ [] = []
myMap f (h:t) = f h : myMap f t

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter _ [] = []
myFilter f (h:t) =
    let ans = myFilter f t in
    if f h then
        h : ans
    else
        ans
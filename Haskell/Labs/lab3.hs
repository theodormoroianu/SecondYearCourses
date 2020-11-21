import Test.QuickCheck

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
    map (^2) $ filter odd
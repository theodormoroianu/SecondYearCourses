import Test.QuickCheck

fibb :: Integer -> Integer
fibb 0 = 0
fibb 1 = 1
fibb n = fibb (n - 1) + fibb (n - 2)

fibb2 :: [Integer]
fibb2 = zipWith (+) (0:1:fibb2) (1:fibb2)

-- L2.2
inInterval :: Int -> Int -> [Int] -> [Int]
inInterval inf sup l =
    [x | x <- l, x >= inf, x <= sup]

inInterval' :: Int -> Int -> [Int] -> [Int]
inInterval' _ _ [] = []
inInterval' inf sup (h:t)
    | inf <= h && h <= sup = h : inInterval inf sup t
    | otherwise = inInterval inf sup t
    

-- L2.3
pozitive :: [Int] -> Int
pozitive [] = 0
pozitive (h:t)
    | h > 0 = 1 + pozitive t
    | otherwise = pozitive t

pozitive2 :: [Int] -> Int
pozitive2 l = length [1 | x <- l, x > 0]


-- L2.4
pozitiiImpareIntern :: Int -> [Int] -> [Int]
pozitiiImpareIntern _ [] = []
pozitiiImpareIntern a (h:t) =
    if odd h then
        a : pozitiiImpareIntern (a + 1) t
    else
        pozitiiImpareIntern (a + 1) t

pozitiiImpare :: [Int] -> [Int]
pozitiiImpare = pozitiiImpareIntern 0

pozitiiImpare' :: [Int] -> [Int]
pozitiiImpare' l =
    let zipped = zip l [1..] in
    [b | (a, b) <- zipped, odd a]

-- L2.5
multDigits :: [Char] -> Integer
multDigits s =
    product [read [x] :: Integer | x <- s, '0' <= x, x <= '9']

-- L2.6
discount :: [Double] -> [Double] 
discount l =
    let discounted = [x * 75 / 100 | x <- l] in
        [x | x <- discounted, x < 200]

discount' :: [Double] -> [Double]
discount' [] = []
discount' (h:t) =
    let rez = discount' t in
    let act = h * 75 / 100 in
    if act < 200 then
        act : rez
    else
        rez

propDiscount :: [Double] -> Bool
propDiscount l = discount l == discount' l

check = quickCheck propDiscount
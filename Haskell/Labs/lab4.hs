import Test.QuickCheck

-- Ex 1
produsRec :: [Integer] -> Integer
produsRec [] = 1
produsRec (h:t) = h * produsRec t

produsFold :: [Integer] -> Integer
produsFold = foldr (*) 1

propProdus l = produsRec l == produsFold l

-- Ex 2
andRec :: [Bool] -> Bool
andRec [] = True
andRec (h:t) = h && andRec t

andFold :: [Bool] -> Bool
andFold = foldr (&&) True

-- Ex 3
concatRec :: [[a]] -> [a]
concatRec [] = []
concatRec (h:t) = h ++ concatRec t

concatFold :: [[a]] -> [a]
concatFold = foldr (++) []

propConcat :: [[Int]] -> Bool
propConcat l = concatRec l == concatFold l

-- Ex 4
rmChar :: Char -> String -> String
rmChar c = filter (/= c)


rmCharsRec :: String -> String -> String
rmCharsRec _ [] = []
rmCharsRec s (h:t) =
    let ans = rmCharsRec s t in
    if h `notElem` s then
        h : ans
    else
        ans

rmChars :: String -> String -> String
rmChars a b = foldr rmChar b a

x = undefined
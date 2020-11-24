import Data.Char
import Data.List
import Test.QuickCheck

upperCaseRec :: String -> Bool
upperCaseRec [] = True
upperCaseRec (h:t) = isUpper h && upperCaseRec t

upperCaseComprehension :: String -> Bool
upperCaseComprehension s =
    and [isUpper c | c <- s]

upperCase :: String -> Bool
upperCase = foldr (&&) True . map isUpper

prop1 :: String -> Bool
prop1 s =
    let a = upperCaseRec s
        b = upperCaseComprehension s
        c = upperCase s in
        a == b && b == c

upperNormal :: String -> Bool
upperNormal = all isUpper


-- Pozitii cu punctuatii
punctuatii :: String
punctuatii = ".?!,:()"

pozitiiRec :: String -> [Int]
pozitiiRec =
    let internal :: Int -> String -> [Int]
        internal _ [] = []
        internal p (h:t) =
            let rest = internal (p + 1) t in
            if h `elem` punctuatii then
                p : rest
            else
                rest in
    internal 0

pozitiiComprehension :: String -> [Int]
pozitiiComprehension s =
    [y | (x, y) <- s `zip` [0..], x `elem` punctuatii]

pozitiiHigh :: String -> [Int]
pozitiiHigh s =
    map snd . filter (\(x, _) -> x `elem` punctuatii) $ s `zip` [0..]

propRecIsComprehension :: String -> Bool
propRecIsComprehension s =
    pozitiiRec s == pozitiiComprehension s

-- Pentru a rula testul se scrie
-- quickCheck propRecIsComprehension


-- Stringuri cu vocale mari
vocale :: String
vocale = "aeiou"

upperVocaleRec :: String -> Bool
upperVocaleRec [] = True
upperVocaleRec (h:t) =
    let rest = upperVocaleRec t in
    if h `elem` vocale then
        False
    else
        rest

upperVocaleComprehension :: String -> Bool
upperVocaleComprehension s =
    null [x | x <- s, x `elem` vocale]

upperHigh :: String -> Bool
upperHigh =
    null . filter (`elem` vocale)



-- Gaseste elementele care apar cel putin de doua ori
findDouble :: (Eq a) => [a] -> Int
findDouble [] = 0
findDouble (h:t) =
    let (a, b) = partition (== h) t in
    if null a then
        findDouble b
    else
        findDouble b + 1



-- Secventa marginita cifrata
f :: Int -> [Int] -> [Int]
f _ [] = []
f x (h:t) =
    if h <= 9 then
        if x >= 0 then
            x : f 0 t
        else
            f 0 t
    else
        f (x + 1) t


-- Cea mai mare cifra dintr-un sir
maxDigitRec :: String -> Int
maxDigitRec [] = -1
maxDigitRec (h:t) =
    let rest = maxDigitRec t in
    if isDigit h then
        max rest (ord h - ord '0')
    else
        rest

maxDigitComprehension :: String -> Int
maxDigitComprehension s =
    maximum (-1:[ord x - ord '0' | x <- s, isDigit x])

maxDigitHigh :: String -> Int
maxDigitHigh =
    foldr max (-1) . map (\x -> ord x - ord '0') . filter isDigit

propIsSame :: String -> Bool
propIsSame s =
    maxDigitComprehension s == maxDigitHigh s



--- Transforma o lista de numere dupa cv reguli
shady :: [Int] -> [Int]
shady [] = []
shady [x]
    | x `elem` [3, 7, 11, 101] = [x, 0]
    | x == 13 = [0, x]
    | otherwise = [x]
shady (0:x:t) 
    | x `elem` [3, 7, 11, 101] = shady (x:t)
    | x == 13 = shady t
    | otherwise = 0 : shady (x:t)
shady (a:0:t)
    | a `elem` [3, 7, 11, 101] = a : shady (0:t)
    | a == 13 = 0 : a : shady t
    | otherwise = a : shady (0 : t)
shady (x:t)
    | x `elem` [3, 7, 11, 101] = x : shady (0:t)
    | x == 13 = 0 : x : shady t
    | otherwise = x : shady t



-- Scoate spatii duble si inainte / dupa linia de despartire
format :: String -> String
format [] = []
format (' ':' ':t) = format (' ':t)
format ('-':' ':t) = format ('-':t)
format (' ':'-':t) = format ('-':t)
format (h:t) = h:format t
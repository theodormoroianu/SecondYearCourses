-- http://www.inf.ed.ac.uk/teaching/courses/inf1/fp/



import Data.Char
import Data.List
import Test.QuickCheck


-- 1.
rotate :: Int -> [Char] -> [Char]
rotate n l
  | n > 0
  , n < length l
  = suf ++ pre
  where
    (pre, suf) = splitAt n l
rotate _ _ = error "număr negativ sau prea mare"

-- 2.
prop_rotate :: Int -> String -> Bool
prop_rotate k str = rotate (l + 1 - m) (rotate m str') == str'
  where
    str' = "ab" ++ str
    l = length str + 1
    m = 1 + k `mod` l

-- 3.
makeKey :: Int -> [(Char, Char)]
makeKey n = zip alphabet (rotate n alphabet)
  where
    alphabet = ['A'..'Z']

-- 4.
lookUp :: Char -> [(Char, Char)] -> Char
lookUp c l = head $ [y | (x, y) <- l, x == c] ++ [c]

-- 5.
encipher :: Int -> Char -> Char
encipher n c = lookUp c (makeKey n)

-- 6.
normalize :: String -> String
normalize = map toUpper . filter isAlphaNum

-- 7.
encipherStr :: Int -> String -> String
encipherStr n = map (encipher n) . normalize

-- 8.
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey = map (\(x,y) -> (y,x))

-- 9.
decipher :: Int -> Char -> Char
decipher n c = lookup c (reverseKey (makeKey n))

decipherStr :: Int -> String -> String
decipherStr = map (decipher n)

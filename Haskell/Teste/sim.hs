import Data.Char
import Data.List
import Test.QuickCheck

-- Returneaza daca un caracter se afla in prima jumatate
fIsInFirstHalf :: Char -> Bool
fIsInFirstHalf c
 | 'a' <= c && c <= 'm' = True
 | 'A' <= c && c <= 'M' = True
 | isAlpha c = False
 | otherwise = error "Not a valid character!"


-- Vede cate sunt in prima jumate si cate nu, si dupa compara
fMoreInFirstHalf :: String -> Bool
fMoreInFirstHalf s =
    let clean = [c | c <- s, isAlpha c] in
    let nr_small = length [c | c <- clean, fIsInFirstHalf c] in
    let nr_big = length [c | c <- clean, not $ fIsInFirstHalf c] in
    nr_small > nr_big



-- Implementeaza fold, map si filder recursiv

map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (h:t) = f h : map' f t

filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' f (h:t) =
    if f h then
        h : filter' f t
    else
        filter' f t

foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' _ acc [] = acc
foldr' f acc (h:t) =
    let new_acc = foldr' f acc t in
    f h new_acc

fMoreInFirstHalfRec :: String -> Bool
fMoreInFirstHalfRec s =
    let clean = filter isAlpha s in
    let (small, big) = partition fIsInFirstHalf clean in
    length small > length big

fTestSame s =
    fMoreInFirstHalf s == fMoreInFirstHalfRec s


fCheckConsecutive :: String -> String
fCheckConsecutive s =
    if null s then
        []
    else
        [x | (x, y) <- s `zip` tail s, x == y]

fCheckConsecutiveRec :: String -> String
fCheckConsecutiveRec s =
    if null s then
        []
    else
        map fst . filter (\(x, y) -> x == y) $ s `zip` tail s

propCheckConsecutive :: String -> Bool
propCheckConsecutive s = fCheckConsecutive s == fCheckConsecutiveRec s

a1 = propCheckConsecutive "112233" -- True
a2 = propCheckConsecutive "" -- True
a3 = propCheckConsecutive "123" -- True
a4 = propCheckConsecutive "111333111222111" -- True
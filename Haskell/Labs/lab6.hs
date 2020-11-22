import Data.Char

rotate :: [a] -> Int -> [a]
rotate l i =
    drop i l ++ take i l

makeKey :: Int -> [(Char, Char)]
makeKey x = zip ['A'..'Z'] (rotate ['A'..'Z'] x)

lookUp :: Char -> [(Char, Char)] -> Char
lookUp c l =
    let f = filter (\(a, b) -> a == c) l in
    if null f then
        c
    else
        snd $ head f

encipher :: Int -> Char -> Char
encipher x c = lookUp c $ makeKey x

normalize :: String -> String
normalize =
    filter isAlphaNum . map toUpper

encipherStr :: Int -> String -> String
encipherStr x =
    map (encipher x) . normalize

reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey = map (\(x, y) -> (y, x))

decipher :: Int -> Char -> Char
decipher x n = lookUp n $ reverseKey $ makeKey x

decipherStr :: Int -> String -> String
decipherStr x = map (decipher x)

data Fruct
    = Mar String Bool
    | Portocala String Int
    deriving (Show)

ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Portocala x _) =
    x `elem` ["Moro", "Tarocco", "Sanguinello"]
ePortocalaDeSicilia _ = False

test_ePortocalaDeSicilia1 =
    ePortocalaDeSicilia (Portocala "Moro" 12)
test_ePortocalaDeSicilia2 =
    not $ ePortocalaDeSicilia (Mar "Ionatan" True)

nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia l =
    let siciliane = filter ePortocalaDeSicilia l in
    foldr (\(Portocala _ x) acc -> x + acc) 0 siciliane


listaFructe = [Mar "Ionatan" False,
    Portocala "Sanguinello" 10,
    Portocala "Valencia" 22,
    Mar "Golden Delicious" True,
    Portocala "Sanguinello" 15,
    Portocala "Moro" 12,
    Portocala "Tarocco" 3,
    Portocala "Moro" 12,
    Portocala "Valencia" 2,
    Mar "Golden Delicious" False,
    Mar "Golden" False,
    Mar "Golden" True]


nrMereViermi :: [Fruct] -> Int
nrMereViermi =
    let nr :: Fruct -> Int
        nr (Mar _ b) = if b then 1 else 0
        nr _ = 0 in
    sum . map nr

data Linie
    = L [Int]
    deriving Show

data Matrice = M [Linie]

verifica :: Matrice -> Int -> Bool
verifica (M mat) n =
    all (\(L lin) -> sum lin == n) mat

instance Show Matrice where
    show (M linii) =
        "[" ++ foldr (\x acc -> show x ++ "\n" ++ acc) "]" linii

doarPozN :: Matrice -> Int -> Bool
doarPozN (M mat) n =
    let verifLin :: Linie -> Bool
        verifLin (L lin) =
            length lin /= n || minimum lin > 0 in
    all verifLin mat
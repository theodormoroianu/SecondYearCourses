import Test.QuickCheck
import Data.Char
import Data.List


-- se termina cu MT


-- Ex 1

-- Caracterele majuscula care apar in sirul haskell
caractere :: String
caractere = "HASKELL"

-- Functie recursiva care calculeaza produsul cu recursie.
-- Daca caracterul este in `caractere` inmultim cu 10, daca nu
-- lasam asa cum e.
scorSirRecMT :: String -> Integer
scorSirRecMT [] = 1
scorSirRecMT (h:t) =
    let rest = scorSirRecMT t in
    if toUpper h `elem` caractere then
        10 * rest
    else
        rest

-- Functie care fac fix acelasi lucru, cu list comprehension.
scorSirComprehensionMT :: String -> Integer
scorSirComprehensionMT s =
    product [10 | x <- s, toUpper x `elem` caractere]

-- Functie care calculeaza de asemenea acelasi lucru, 
-- folosind un fold, care proceseaza cate un caracter.
scorSirHighMT :: String -> Integer
scorSirHighMT =
    let funFoldMT :: Char -> Integer -> Integer
        funFoldMT x
            | toUpper x `elem` caractere = (*10)
            | otherwise = id in
    foldr funFoldMT 1

-- Teste
ok11 = scorSirRecMT "hAsKeLl" == 10^7
ok21 = scorSirComprehensionMT "hAsKeLl" == 10^7
ok31 = scorSirHighMT "hAsKeLl" == 10^7
ok12 = scorSirRecMT "" == 1
ok22 = scorSirComprehensionMT "" == 1
ok32 = scorSirHighMT "" == 1
ok13 = scorSirRecMT "bBcCdD123123@#@#@l" == 10
ok23 = scorSirComprehensionMT "bBcCdD123123@#@#@l" == 10
ok33 = scorSirHighMT "bBcCdD123123@#@#@l" == 10

-- Se poate vedea ca toate variabililele okij sunt True.

-- Testare
propPunctDoiEgalPunctTreiMT :: String -> Bool
propPunctDoiEgalPunctTreiMT s =
    scorSirHighMT s == scorSirComprehensionMT s

-- testMT este o actiune IO care testeaza functiile
testMT :: IO ()
testMT = quickCheck propPunctDoiEgalPunctTreiMT




-- Ex 2
vocale :: String
vocale = "aeiou"

-- Inputul nu specifica daca este vorba de lowercase sau uppercase, deci
-- presupun ca trebuie sa fac ambele variante :/

-- Efectiv o iau taraneste prin cazuri.
-- Daca dau de 1 sau 2 caractere nu au voie sa fie vocale.
-- Daca un sir incepe cu o vocala, trebuie sa aiba un p in mijloc
-- si aceeasi vocala dupa.
-- Daca un sir incepe cu o consoana, o sa faca parte din raspuns.

decodeMT :: String -> String
decodeMT [] = []
decodeMT [c]
    | toLower c `elem` vocale = error "Cod invalid!"
    | otherwise = [c]
decodeMT [c, d]
    | toLower c `elem` vocale || toLower d `elem` vocale = error "Cod invalid!"
    | otherwise = [c, d]
decodeMT (a:b:c:t)
    | toLower a `notElem` vocale = a : decodeMT (b:c:t)
    | a /= c || toLower b /= 'p' = error "Cod invalid!"
    | otherwise = a : decodeMT t
    

okdec1 = decodeMT "apa EpE IPI B C" == "a E I B C"
okdec2 = decodeMT "Hepellopo Theperepe!" == "Hello There!"
okdec3 = decodeMT "Gepeneperapal Kepenopobipi" == "General Kenobi"

-- Functia de encodare.
encodeMT :: String -> String
encodeMT =
    (>>= (\c -> if toLower c `elem` vocale then [c, 'p', c] else [c]))

-- Testare
propEncodeWorksMT :: String -> Bool
propEncodeWorksMT s =
    decodeMT (encodeMT s) == s
import Test.QuickCheck
import System.Random
import Data.Char
import Data.List

-- mtr10

-- ce e definit in let sau where nu este obligat sa foloseasca sablonul

-- Tipul
-- Solutia aleasa
-- Teste (min 2)


-- Ex2
data E x = A | M x (E x) x

-- Exemple de date
e1 :: E Int
e1 = A
e2 :: E Int
e2 = M 10 (M 20 A 30) 20
e3 :: E [Int]
e3 = M [10] (M [] A [12]) []
e4 :: E [Int]
e4 = M [10, 11] (M [] A [12, 13]) [11]


-- Instance facut cu ajutorul lui foldMap
-- Nota: Foldr pastreaza ordinea relativa intre elemente, util al functia toList
instance Foldable E where
    foldMap _ A = mempty 
    foldMap f (M x fiu y) = (f x) <> (foldMap f fiu) <> (f y)


-- Testare
-- Nu pot folosi "toList" ca e definit mai jos
--      y do this tho??
test211 :: Bool
test211 = foldr (:) [] e2 == [10, 20, 30, 20]
test212 :: Bool
test212 = foldr (:) [] e1 == []
fTest0 :: Bool
fTest0 = maximum (M "Mama" (M "are" (M "patru" (M "mere" A "") "si") "doua") "pere") == "si"



-- Definim clasa
-- De ce clasa foloseste toList ??? e deja luat
class C e where
  cFilter :: Monoid a => (a -> Bool) -> e a -> e a
  toList :: (Monoid a, Eq a) => e a -> [a]



-- Instantiem E in C
instance C E where
    -- scoate elementele egale cu mempty
    -- Transformam la lista folosind faptul ca e foldable
    toList e = filter (/= mempty) $ foldr (:) [] e

    -- Schimba elementele in mempty daca f e fals
    cFilter f A = A
    cFilter f (M a fiu b) =
        -- functia asta ia un element si il modifica corespunzator
        let modif elem =
             if not (f elem) then
                mempty 
             else
                elem in
        -- apelam recursiv si folosim functia modif
        M (modif a) (cFilter f fiu) (modif b)


-- Facem E instance al lui eq pentru teste
instance Eq x => Eq (E x) where
    A == A = True
    (M x1 e1 x2) == (M y1 e2 y2) =
        x1 == y1 && x2 == y2 && e1 == e2
    _ == _ = False 

-- teste pentru toList si cFilter ale instantierii noastre
test221 :: Bool
test221 = toList e3 == [[10], [12]]
test222 :: Bool
test222 = toList e4 == [[10, 11], [12, 13], [11]]
test223 :: Bool
test223 = cFilter ((> 1) . length) e4 == M [10, 11] (M [] A [12, 13]) []
test224 :: Bool
test224 = cFilter (const True) e4 == e4
cTest0 :: Bool
cTest0 =
    toList (cFilter (\x -> length x > 3)
        (M "Mama" (M "are" (M "patru" (M "mere" A "") "si") "doua") "pere")) ==
     ["Mama", "patru", "mere", "doua", "pere"]






-- Ex 1

data Reteta =  Stop | R Ing Reteta

data Ing = Ing String Int

-- Exemple
reteta1 :: Reteta
reteta1 = R (Ing "Faina" 10) $ R (Ing "Oua" 4) $ R (Ing "Faina" 4) Stop
reteta2 :: Reteta
reteta2 = R (Ing "Faina" 10) $ R (Ing "Faina" 12) $ R (Ing "Faina" 4) Stop


-- Gaseste frecventa maxima a retetei cu un nume dat, si scoate toate aparitiile ale acesteia.
-- Matchul este case-insensitive, asa cum ar trebui sa fie ca sa aiba sens cerintele viitoare
mtr10RemoveAndFindMaximal :: Reteta -> String -> (Int, Reteta)
mtr10RemoveAndFindMaximal Stop _ = (0, Stop)
mtr10RemoveAndFindMaximal (R (Ing nume q) rest) ingredient 
 | (map toLower ingredient) == (map toLower nume) =
     let (max_rest, rest_reteta) = mtr10RemoveAndFindMaximal rest ingredient in
     (max max_rest q, rest_reteta)
 | otherwise =
     let (max_rest, rest_reteta) = mtr10RemoveAndFindMaximal rest ingredient in
     (max_rest, R (Ing nume q) rest_reteta)



-- Functie care retine pentru fiecare tip de ingredient cel cu valoarea maxima.
-- Note: Nu s-a mentionat ca trebuie pastrata ordinea in strucura Reteta (oricum
--          cat timp "reteta" nu este foldable -- si nu poate sa fie ca nu are kind-ul
--          bun, orice modificare a retetei ne da alta structura, deci nu pre ares sens
--          notiunea de-a pastra ordinea relativa).
-- Foarte lent (O(lungime^2)) dar oh well...
mtr10CleanReteta :: Reteta -> Reteta
mtr10CleanReteta Stop = Stop
mtr10CleanReteta reteta@(R (Ing nume q) rest) =
    let (max_frc, real_reteta) = mtr10RemoveAndFindMaximal reteta nume in
    R (Ing nume max_frc) $ mtr10CleanReteta real_reteta

-- Declaram diferite instantieri, ca sa putem sa facem teste
instance Show Ing where
    show (Ing nume quantity) =
        "Nume: " ++ nume ++ ", Nr: " ++ show quantity

instance Show Reteta where
    show Stop = ""
    show (R ing rest) = "(" ++ show ing ++ ") " ++ show rest

-- doua ingrediente sunt egale daca au aceeasi cantitate, si
-- numele e acelasi pana la caps lock
instance Eq Ing where
    (Ing nume q) == (Ing nume2 q2) =
        (map toLower nume) == (map toLower nume2) && q == q2

-- Ordinea e definita ca sa putem sa sortam liste de ingrediente
instance Ord Ing where
    (Ing s1 n1) <= (Ing s2 n2) = (map toLower s1, n1) <= (map toLower s2, n2)

-- Daca doua retete sunt egale.
-- Mai intai, cleanuim reteta cu functia mtr10CleanReteta
-- Dupa, o convertim la o lista (recursiv)
-- Dupa o sortam, si trebuie fiecare ingredient sa fie egal
-- Compararea a doua liste este astfel Theta(lungime * log(lungime)), pe
-- cand alte abordari fara sortare au Omega(lungime^2)
-- Nota: `<=` Nu tine cont de caps lock, deci nu apar probleme legate de 
-- lowercase sau uppercase
instance Eq Reteta where
    r1 == r2 =
        let mkList :: Reteta -> [Ing]
            mkList Stop = []
            mkList (R ing rest) =
                ing : mkList rest
            cleanr1 = mkList $ mtr10CleanReteta r1
            cleanr2 = mkList $ mtr10CleanReteta r2 in
        sort cleanr1 == sort cleanr2




-- Teste pentru mtr10CleanReteta
-- Din pacate cum si == foloseste mtr10CleanReteta, ca sa fim siguri ca este intr-adevar
-- bine, trebuie sa vericam si lungimea sa fie cea buna
mtr10LungimeRetea :: Reteta -> Int
mtr10LungimeRetea Stop = 0
mtr10LungimeRetea (R _ urm) = 1 + mtr10LungimeRetea urm
test111 :: Bool
test111 = mtr10CleanReteta reteta1 == R (Ing "Faina" 10) (R (Ing "Oua" 4) Stop) &&
          mtr10LungimeRetea (mtr10CleanReteta reteta1) == 2
test112 :: Bool
test112 = mtr10CleanReteta reteta2 == R (Ing "Faina" 12) Stop &&
          mtr10LungimeRetea (mtr10CleanReteta reteta2) == 1
test113 :: Bool
test113 = mtr10CleanReteta reteta1 == R (Ing "oUA" 4) (R (Ing "fAiNa" 10) Stop) &&
          mtr10LungimeRetea (mtr10CleanReteta reteta1) == 2
test114 :: Bool
test114 = mtr10CleanReteta reteta1 /= R (Ing "oUA" 5) (R (Ing "fAiNa" 10) Stop)

r1 =  R (Ing "faina" 500) (R (Ing "oua" 4) (R  (Ing "zahar" 500) (R (Ing "faina" 300) Stop)))
r2 =  R (Ing "fAIna" 500) (R (Ing "zahar" 500) (R (Ing "Oua" 4) Stop ))
r3 =  R (Ing "fAIna" 500) (R (Ing "zahar" 500) (R  (Ing "Oua" 55) Stop))

-- Teste pentru (==)
test121 :: Bool
test121 = R (Ing "faIna" 4) (R (Ing "FaIna" 3) Stop) == R (Ing "faInA" 1) (R (Ing "FAIna" 4) Stop)
test122 :: Bool
test122 = Stop == Stop
test123 :: Bool
test123 = Stop /= R (Ing "idk" 1) Stop



data Arb
    = Leaf Int String
    | Node Arb Int String Arb
    deriving (Show)

-- Operator care stie sa concateneze retete
-- Nota: +++ este asociativ la dreapta, si deci concatenarea
-- a N liste are complexitate O(suma_lungimi).
-- Daca era asociativ la stanga ar fi avut complexitatea 
-- O(suma_lungimi ^ 2)
-- Lasam prioritatea by default
infixr +++
(+++) :: Reteta -> Reteta -> Reteta
Stop +++ x = x
(R ing rest) +++ x = R ing (rest +++ x)


-- Functie care dintr-un arbore shady ne face o reteta fancy
-- Destul de izi, concatenam bucatile obtinute recursiv
mtr10MakeReteta :: Arb -> Reteta
mtr10MakeReteta (Leaf a b) = R (Ing b a) Stop
mtr10MakeReteta (Node st a b dr) = mtr10MakeReteta st +++ R (Ing b a) Stop +++ mtr10MakeReteta dr

-- Teste
arb1 :: Arb
arb1 = Leaf 10 "Faina"
arb2 :: Arb
arb2 = Node (Node (Leaf 4 "Faina") 4 "Oua" (Leaf 5 "oua")) 1 "Paine" (Leaf 10 "Oua")

test131 :: Bool
test131 = mtr10MakeReteta arb1 == R (Ing "FaInA" 10) Stop
test132 :: Bool
test132 = mtr10MakeReteta arb2 == R (Ing "Faina" 4) (R (Ing "Oua" 10) (R (Ing "Paine" 1) Stop))


toArbore :: Reteta -> Arb
toArbore (R (Ing nume nr) Stop) = Leaf nr nume
toArbore (R (Ing nume nr) rest) =
    Node (Leaf nr nume) nr nume $ toArbore rest 


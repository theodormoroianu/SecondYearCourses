import Data.Char
import Data.List

-- Nota: Testele nu sunt imediat sub functii, pentru ca exista un DAG mai dubios al dependintelor.
-- Toate functiile definite au teste tho

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
-- Nota: Pastreaza si ordinea elementelor in parcurgerea in-ordine (Be amazed)
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


import Data.Char
import Data.List
import Test.QuickCheck

data Clasament = Cl [String] deriving Show



exista :: String -> Clasament -> Bool
exista s (Cl strs) =
    any (isPrefixOf s) strs

extrage :: String -> [Clasament] -> [Clasament]
extrage s =
    filter (exista s)

pozitie :: Clasament -> Clasament -> [String]
pozitie (Cl a1) (Cl a2) =
    if length a1 /= length a2 then
        error "Not same length!!"
    else
        map fst . filter (uncurry (==)) $ a1 `zip` a2


data Pers = P String String deriving Show

class ToFromPers a where
    toPers :: a -> [Pers]
    fromPers :: [Pers] -> a

instance ToFromPers Clasament where
    toPers (Cl l) = map (\s -> let w = words s in P (w!!1) (w!!2)) l
    fromPers l = Cl $ [x ++ " " ++ y | P x y <- l]
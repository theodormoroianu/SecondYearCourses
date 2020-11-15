type RasaDePisic = String

data Linie = L [Int] deriving (Show)
data Matrice = M [Linie]

verifica :: Matrice -> Int -> Bool
verifica (M lista) suma =
    let x = map (\L l -> foldr (+) l 0) suma in
     
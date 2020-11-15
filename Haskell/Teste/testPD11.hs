data Punct = Pt [Int] deriving Show

-- Ex 1

nrPozitive :: Punct -> Int
nrPozitive (Pt []) = 0
nrPozitive (Pt (a:b)) =
    let ans = nrPozitive $ Pt b in
    if a > 0
    then 1 + ans
    else ans

-- Ex 2

z3Poz :: [Punct] -> [Punct]
z3Poz puncte =
    let goodPoint punct =
         let Pt v = punct in
         if length v /= 3
         then False
         else (nrPozitive punct) == 3 in
    filter goodPoint puncte


-- Ex 3

ex3 :: Punct -> Punct -> Int
ex3 (Pt v1) (Pt v2) =
    if length v1 /= length v2
        then error "Lungimi diferite!"
        else let zipped = zip v1 v2 in
             let sumed = map (\(x, y) -> (x + y) ^ 2) zipped in
             foldl1 (+) sumed

-- Ex 4

class ToFromParts a where
    toParts :: a -> [a]
    fromParts :: [a] -> a

instance ToFromParts Punct where
    toParts (Pt []) = []
    toParts (Pt (a:b)) = (Pt [a]) : (toParts $ Pt b)

    fromParts [] = Pt []
    fromParts (a:b) =
        let (Pt v) = fromParts b in
        let (Pt va) = a in
        Pt (va ++ v)

main = do
    print $ toParts ( Pt [ 1 , 2 , 3 , 4 ] )
    print $ fromParts [Pt [1], Pt [2, 3], Pt [1, 2, 3]]
    print $ ex3 (Pt [1, 2, 3, 4]) (Pt [1, 2, 3, 4])
    print $ z3Poz [Pt [1, 2], Pt [1, 2, 3], Pt [1, -2, 3], Pt [1 -3, -4, -5]]



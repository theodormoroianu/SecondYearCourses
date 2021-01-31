import Data.Foldable

data Arbore a
    = Nod (Arbore a) a (Arbore a)
    | Frunza a
    | Gol

instance Eq a => Eq (Arbore a) where
    Gol == Gol = True
    (Frunza a) == (Frunza b) = a == b
    (Nod st val dr) == (Nod l v r) = l == st && r == dr && val == v

instance Show a => Show (Arbore a) where
    show arb = show $ toList arb

instance Functor Arbore where
    fmap _ Gol = Gol
    fmap f (Frunza a) = Frunza $ f a
    fmap f (Nod st a dr) = Nod (fmap f st) (f a) (fmap f dr)

instance Foldable Arbore where
    foldMap f Gol = mempty 
    foldMap f (Frunza a) = f a
    foldMap f (Nod st a dr) = (foldMap f st) <> (f a) <> (foldMap f dr)

isSearchTree :: (Ord a) => Arbore a -> Bool
isSearchTree Gol = True
isSearchTree arb =
    let lista = toList arb in
    all (\(a, b) -> a < b) $ zip lista (tail lista)

arb1 = Gol :: Arbore Integer
arb2 = Frunza 10
arb3 = Nod (Nod (Frunza 4) 6 (Frunza 10)) 15 (Frunza 20)
arb4 = Nod (Frunza 5) 6 (Frunza 4)

test11 = isSearchTree arb1
test12 = isSearchTree arb2
test13 = isSearchTree arb3
test14 = not $ isSearchTree arb4

insertTree :: (Ord a) => a -> Arbore a -> Arbore a
insertTree a Gol = Frunza a
insertTree a (Frunza val)
 | val > a = Nod (Frunza a) val Gol
 | val == a = Frunza val
 | otherwise = Nod Gol val $ Frunza a
insertTree a nod@(Nod st val dr)
 | val > a = Nod (insertTree a st) val dr
 | val == a = nod
 | otherwise = Nod st val (insertTree a dr)

test21 = insertTree 4 arb3 == arb3
test22 = insertTree 10 arb2 == arb2
test23 = insertTree 1 arb2 == Nod (Frunza 1) 10 Gol
test24 = insertTree 11 arb2 == Nod Gol 10 (Frunza 11)
test25 = insertTree 10 Gol == Frunza 10
test26 = insertTree 5 arb3 == Nod (Nod (Nod Gol 4 (Frunza 5)) 6 (Frunza 10)) 15 (Frunza 20)
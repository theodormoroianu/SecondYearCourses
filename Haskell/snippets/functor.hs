data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)

singleton :: (Eq a, Ord a) => a -> Tree a
singleton x = Node x EmptyTree EmptyTree

insertNode :: (Eq a, Ord a) => a -> Tree a -> Tree a
insertNode val EmptyTree = singleton val
insertNode val (Node x st dr)
    | val == x = Node x st dr
    | val < x = Node x (insertNode val st) dr
    | otherwise = Node x dr (insertNode val dr)

findNode :: (Eq a, Ord a) => a -> Tree a -> Bool
findNode _ EmptyTree = False
findNode val (Node x st dr)
    | x == val = True
    | val < x = findNode val st
    | otherwise = findNode val dr

tree :: Tree Int
tree = foldr insertNode EmptyTree [1 .. 10]

instance Functor Tree where
    fmap f EmptyTree = EmptyTree
    fmap f (Node a st dr) = Node (f a) (fmap f st) (fmap f dr)

tostr :: Either Int String -> String
tostr (Left a) = show a
tostr (Right x) = x

main = do
    print $ fmap (*10) tree
    print $ tostr $ Right "123"
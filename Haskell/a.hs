data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)

singleton :: (Eq a, Ord a) => a -> Tree a
singleton x = Node x EmptyTree EmptyTree

insertNode :: (Eq a, Ord a) => Tree a -> a -> Tree a
insertNode EmptyTree val = singleton val
insertNode (Node x st dr) val
    | val == x = Node x st dr
    | val < x = Node x (insertNode st val) dr
    | otherwise = Node x dr (insertNode dr val)

findNode :: (Eq a, Ord a) => Tree a -> a -> Bool
findNode EmptyTree _ = False
findNode (Node x st dr) val
    | x == val = True
    | val < x = findNode st val
    | otherwise = findNode dr val

main = do
    let a = singleton 10
    let b = insertNode a 15
    print $ findNode b 5
    print $ findNode b 10
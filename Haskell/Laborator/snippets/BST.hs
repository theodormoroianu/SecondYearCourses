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

divby2 :: Int -> Maybe Int
divby2 x = if x `mod` 2 == 0 then Just (x `div` 2) else Nothing

process :: Int -> String
process x = case divby2 x of
                Nothing -> "Not able to compute!"
                Just val -> "Got " ++ (show val)


main = do
    print $ 5 `findNode` tree
    print $ 100 `findNode` tree
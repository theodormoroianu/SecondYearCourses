import Test.QuickCheck

foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' _ acc [] = acc
foldr' f acc (h:t) =
    let new_acc = foldr' f acc t in
    f h new_acc

prop :: Int -> [Int] -> Bool
prop acc l = foldr (\a acc -> 2 * a + acc * 3) acc l == foldr' (\a acc -> 2 * a + acc * 3) acc l


f :: (Show a) => Maybe a -> String
f = maybe "Noting" show
    -- case s of
    --     Just x -> show x
    --     Nothing -> "Nothing"
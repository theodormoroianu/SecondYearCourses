
solve :: Int -> [Int]
solve x = [a | a <- [1..x], x `mod` a == 0]

is_prime :: Int -> Bool
is_prime x = (solve x == [1, x])

main = do
    a <- getLine
    print $ is_prime $ read a
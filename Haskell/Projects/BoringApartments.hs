-- https://codeforces.com/contest/1433/problem/A
solve :: Int -> Int
solve x = 
    let l = len x in
    10 * (x `mod` 10 - 1) + l * (l + 1) `div` 2
    where len x
           | x == 0 = 0
           | otherwise = 1 + len (x `div` 10)

solveAll :: String -> String
solveAll s =
    let cases = map (\x -> read x :: Int) $ lines s in
    let sol = map solve cases in
    foldr (\a s -> show a ++ "\n" ++ s) "" sol


main = do
    n <- getLine
    interact solveAll
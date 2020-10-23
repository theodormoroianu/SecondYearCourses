
test :: String -> String
test s =
    let (n:x:[]) = map read $ words s :: [Int] in
    if n <= 2 then
        "1\n"
    else
        (show $ 2 + (n - 3) `div` x) ++ "\n"

solve :: String -> String
solve s =
    let ans = map test $ lines s in
    foldr1 (++) ans

main = do
    n <- getLine
    interact solve
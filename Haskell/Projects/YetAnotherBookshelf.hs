-- https://codeforces.com/contest/1433/problem/B

solve :: (String, String) -> String
solve (_, a) = ""

solver :: String -> String
solver input =
    let lins = zip2 $ lines input
        ans = map solve lins in
    foldl1 (++) ans
    where zip2 [] = []
          zip2 (a:b:rest) = (a, b) : zip2 rest


main = do
    n <- getLine
    interact solver

import Data.Bits
import Control.Monad

solve :: IO ()
solve = do
    str <- getLine
    let (a:b:[]) = map read $ words str :: [Int]
    print $ a + b - 2 * (a .&. b)

main = do
    
    tests_str <- getLine
    sequence $ take (read tests_str) $ repeat solve
    forM [1..10] (\a -> do
        print a)
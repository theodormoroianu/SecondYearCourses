import System.Environment
import Control.Monad

my_gcd :: Int -> Int -> Int
my_gcd 0 a = a
my_gcd a 0 = a
my_gcd a b = if a > b
             then gcd a (b - a)
             else gcd (a - b) b


tellname = do
    print "Hello what is your name?"
    name <- getLine
    print $ "Cool " ++ name ++ ", how old are you?"
    str_age <- getLine
    let age = read str_age :: Int
    print $ "Cool " ++ name ++ ", you are " ++ (show age) ++ " years old!"

reverseWords :: String -> String
reverseWords = unwords . map reverse . words

readlines :: IO ()
readlines = do
    line <- getLine
    if null line
        then return ()
        else do
            print  $ reverseWords line
            readlines


my_if_statment = do
    when (1 < 10) $ do
        print "12"


a = let x = (\a -> a + 1)
        y = [1..10] in
    map x y

numbers x = do
    y <- sequence $ take x $ repeat getLine        
    return $ map (\x -> read x :: Int) y

main = do
    nr <- numbers 3
    print nr

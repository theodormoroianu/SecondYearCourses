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

main = do
    tellname
    line <- getLine
    let (a, b) = read line ::(Int, Int)

    print $ my_gcd a b

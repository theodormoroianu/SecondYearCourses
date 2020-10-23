import Control.Monad

fact :: Integer -> Integer -> Integer
fact 0 ans = ans
fact n ans = fact (n - 1) (ans * n)

getColors :: IO [String]
getColors = forM [1..10] (\a -> do
    print $ "What is your " ++ show a ++ "th favourite color?"
    color <- getLine
    return color)

printlines n =
    sequence $ take n $ repeat $ print "Hello"

solve :: String -> String
solve a = if length a > 10 then
              ""
          else
              a
main = do
    n_str <- getLine
    forM [1..(read n_str)] (\_ -> do
        line <- getLine
        print $ solve line)
    colors <- getColors
    print colors

    mapM print [1..10]
    when (1 == 1) $ do
        print "Hello world!"
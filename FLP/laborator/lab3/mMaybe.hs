{- Monada Maybe este definita in GHC.Base 

instance Monad Maybe where
  return = Just
  Just va  >>= k   = k va
  Nothing >>= _   = Nothing


instance Applicative Maybe where
  pure = return
  mf <*> ma = do
    f <- mf
    va <- ma
    return (f va)       

instance Functor Maybe where              
  fmap f ma = pure f <*> ma   
-}

import Test.QuickCheck
import Data.Maybe

(<=<) :: (a -> Maybe b) -> (c -> Maybe a) -> c -> Maybe b
f <=< g = (\ x -> g x >>= f)

asoc :: (Int -> Maybe Int) -> (Int -> Maybe Int) -> (Int -> Maybe Int) -> Int -> Bool
asoc f g h x = (h <=< (g <=< f) $ x) == ((h <=< g) <=< f $ x)

test1 :: Int -> Bool
test1 =
    let justEven :: Int -> Maybe Int
        justEven x
         | even x = Just $ x `div` 2
         | otherwise = Nothing 
        mult2 :: Int -> Maybe Int
        mult2 = return . (*2)
        isSquare :: Int -> Maybe Int
        isSquare x =
            let s = floor . sqrt . fromIntegral $ x in
            if s * s == x then 
                Just 1
            else
                Just 0 in
    asoc isSquare mult2 justEven

validTest1 = quickCheck test1




pos :: Int -> Bool
pos  x = if (x>=0) then True else False


-- Nothing -> Nothing
-- Just x -> Just (x >= 0)
foo :: Maybe Int ->  Maybe Bool 
foo  mx =  mx  >>= (\x -> Just (pos x))  




addM :: Maybe Int -> Maybe Int -> Maybe Int  
addM mx my = do
    val1 <- mx
    val2 <- my
    return $ val1 + val2

addM2 :: Maybe Int -> Maybe Int -> Maybe Int
addM2 Nothing _ = Nothing
addM2 _ Nothing = Nothing
addM2 (Just a) (Just b) = Just (a + b)


prop2 :: Int -> Int -> Bool
prop2 a b =
    addM (Just a) (Just b) == addM2 (Just a) (Just b) &&
    addM Nothing (Just b) == addM2 Nothing (Just b) &&
    addM (Just a) Nothing == addM2 (Just a) Nothing 

validProp2 = quickCheck prop2




cartesian_product xs ys = xs >>= ( \x -> (ys >>= \y-> return (x,y)))

cartesianProductDo xs ys = do
    a <- xs
    b <- ys
    return (a, b)

cartezianProd =
    let prop :: [Int] -> [Int] -> Bool
        prop a b = cartesian_product a b == cartesianProductDo a b in
    quickCheck prop

prod f xs ys = [f x y | x <- xs, y<-ys]

prodDo :: Monad m => (a -> b -> c) -> m a -> m b -> m c
prodDo f xs ys = do
    a <- xs
    b <- ys
    return $ f a b


myGetLine :: IO String
myGetLine = getChar >>= \x ->
    if x == '\n' then
        return []
    else
        myGetLine >>= \xs -> return (x:xs)

myGetLineDo :: IO String
myGetLineDo = do
    c <- getChar
    if c == '\n' then do
        return []
    else do
        rest <- myGetLineDo
        return (c : rest)



prelNo noin = sqrt noin
ioNumber = do
    noin <- readLn :: IO Float
    putStrLn $ "Intrare\n" ++ (show noin)
    let noout = prelNo noin
    putStrLn $ "Iesire"
    print noout

ioNumberWODO =
    (readLn :: IO Float) >>= \noin -> 
        (putStrLn $ "Intrare\n" ++ (show noin)) >>= \_ ->
        let noout = prelNo noin in
        (putStrLn $ "Iesire") >>= \_ ->
        print noout


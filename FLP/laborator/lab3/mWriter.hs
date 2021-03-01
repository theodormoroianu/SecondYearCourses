
--- Monada Writer

newtype WriterS a = Writer { runWriter :: (a, String) } 


instance  Monad WriterS where
  return va = Writer (va, "")
  ma >>= k = let (va, log1) = runWriter ma
                 (vb, log2) = runWriter (k va)
             in  Writer (vb, log1 ++ log2)


instance  Applicative WriterS where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance  Functor WriterS where              
  fmap f ma = pure f <*> ma     

tell :: String -> WriterS () 
tell log = Writer ((), log)
  
logIncrement :: Int  -> WriterS Int
logIncrement x = Writer (x + 1, "Incremented " ++ show x ++ " to " ++ show (x + 1) ++ "\n")

logIncrementN :: Int -> Int -> WriterS Int
logIncrementN x 0 = Writer (x, "")
logIncrementN x a = do
  oth <- logIncrementN x (a - 1)
  logIncrement oth
   
                  


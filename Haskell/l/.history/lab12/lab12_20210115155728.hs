
import System.Random
import Data.Char

newtype MyRandom a = MyRandom { runRandom :: StdGen -> (a,StdGen) }

randomPositive :: MyRandom Int
randomPositive = (MyRandom next)

instance Functor MyRandom where
  fmap f ra = MyRandom rb
    where
      rb gen = (f a, gen')
        where
          (a,gen') = runRandom ra gen

randomBoundedInt :: Int -> MyRandom Int
randomBoundedInt n = fmap (`mod` n) randomPositive

randomLetter :: MyRandom Char
randomLetter = fmap toChar (randomBoundedInt 26)
  where
    toChar n = chr (ord 'a' + n)

instance Applicative MyRandom where
  pure x = MyRandom (\gen -> (x, gen))
  rf <*> ra = MyRandom rb
    where
      rb gen = (f a, gen'')
        where
          (f, gen') = runRandom rf gen
          (a, gen'') = runRandom ra gen'

randomString :: Int -> MyRandom String
randomString n
  | n <= 0 = pure ""
  | otherwise = pure (:) <*> randomLetter <*> randomString (n - 1)
  

random10LetterPair :: MyRandom (Int, Char)
random10LetterPair = undefined


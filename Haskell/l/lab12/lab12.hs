import System.Random
import Data.Char

newtype MyRandom a = MyRandom { runRandom :: StdGen -> (a,StdGen) }

randomPositive :: MyRandom Int
randomPositive = (MyRandom next)

instance Functor MyRandom where
    fmap f (MyRandom fnc) =
        MyRandom (\gen ->
            let (val, new_gen) = fnc gen in
            (f val, new_gen))

randomBoundedInt :: Int -> MyRandom Int
randomBoundedInt v_max =
    fmap (`mod` v_max) randomPositive

randomLetter :: MyRandom Char
randomLetter =
    fmap (\x -> chr $ ord 'a' + x) $ randomBoundedInt 27

instance Applicative MyRandom where
    pure f = MyRandom (\x -> (f, x))
    (MyRandom run_f) <*> (MyRandom run_val) =
        MyRandom (\gen ->
            let (f, new_gen) = run_f gen
                (val, final_gen) = run_val new_gen in
                (f val, final_gen))

random10LetterPair :: MyRandom (Int, Char)
random10LetterPair = (,) <$> randomBoundedInt 10 <*> randomLetter

randomDecimal :: MyRandom Int 
randomDecimal =
    (\x y -> 10 * x + y) <$> randomBoundedInt 10 <*> randomBoundedInt 10

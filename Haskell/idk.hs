import Test.QuickCheck

import System.Random

a :: StdGen
a = mkStdGen 10

(rnd, a') = random a :: (Int, StdGen)

infiniteRange = randomRs (1, 100) a' :: [Int]

prop :: Int -> Bool
prop x = maximum (take (abs x + 1) infiniteRange) <= 100

z = quickCheck prop
import Data.List
import Data.Char
import Test.QuickCheck

data Point = P Integer Integer deriving Show

data Geom = Geom [Point] deriving Show

-- Ex 1
vPozitive :: Geom -> Geom
vPozitive (Geom points) =
    Geom $ filter (\(P a b) -> a > 0 && b > 0) points

figPozitive :: [Geom] -> [Geom]
figPozitive =
    let filterFig :: Geom -> Bool
        filterFig (Geom p) =
            all (\(P a b) -> a > 0 && b > 0) p in
    filter filterFig


sumaDist :: Geom -> Geom -> Double
sumaDist (Geom a) (Geom b) =
    if length a /= length b then
        error "Nu au aceeasi lungime!"
    else
        let dist :: Point -> Point -> Double
            dist (P x1 y1) (P x2 y2) =
                sqrt . fromIntegral $ (x1 - x2) ^ 2 + (y1 - y2) ^ 2 in
        foldr (+) 0 $ zipWith dist a b

figs = [Geom [P 1 2], Geom [P 1 (-1)]]

a = 10 :: Int
b = sqrt (fromIntegral a) :: Double


class GeomList a where
    toListG :: a -> [(Integer, Integer)]
    fromListG :: [(Integer, Integer)] -> a

instance GeomList Geom where
    toListG (Geom l) = map (\(P a b) -> (a, b)) l
    fromListG l = Geom $ map (uncurry P) l
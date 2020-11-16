data Tree a
    = EmptyNode
    | Node a [Tree a]
    deriving (Show, Eq)

my_tree = Node 10 [Node 4 [], EmptyNode]

data Car = Car
    { name :: String
    , year :: Int
    } deriving (Show)

my_car = Car "Dacia" 2000
my_car2 = Car { name="Dacia", year=2000 }
car_age = year my_car2

infixr 5 :-:  
data List a
    = Empty
    | a :-: (List a)
    deriving (Show, Read, Eq, Ord)  

infixl 9 -=
(-=) :: Int -> Int -> Int
0 -= _ = 0
a -= b = a + b


data Lista a = Gol | Lista a (Lista a)

instance (Show a) => Show (Lista a) where
    show Gol = ""
    show (Lista a l) = show a ++ " " ++ show l



class MyEq a where
    (===) :: a -> a -> Bool
    (/==) :: a -> a -> Bool
    x === y = not (x /== y)
    x /== y = not (x === y)

tellVar :: Maybe Int -> String
tellVar m =
    case m of
        Just x -> "Value is " ++ show x
        otherwise -> "Nope"
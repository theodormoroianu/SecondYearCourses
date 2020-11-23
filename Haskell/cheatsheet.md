# Haskell CheatSheet

## Stuff to know

1. Types and Constructors ALWAYS start with an uppercase
2. Functions ALWAYS start with a lowercase
3. `Foldr` can be used on infinite lists but `foldl` can't
4. `:i Eq` gives informations on the `Eq` typeclass
5. Solutions can be:
    * Descriptive: list comprehension
    * Recursive: recursivity
    * Higher order: `map`, `filter`, `fold` etc.

## Writting `map`, `filter` and `fold` with recursion

``` haskell
map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (h:t) = f h : map' f t

filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' f (h:t) =
    if f h then
        h : filter' f t
    else
        filter' f t

foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' _ acc [] = acc
foldr' f acc (h:t) =
    let new_acc = foldr' f acc t in
    f h new_acc

foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' _ acc [] = acc
foldl' f acc (h:t) =
    foldl' f (f acc h) t
```

## Writting `map` and `filter` with list comprehension

``` haskell
map' :: (a -> b) -> [a] -> [b]
map' f l = [f x | x <- l]

filter' :: (a -> Bool) -> [a] -> [a]
filter' f l = [x | x <- l, f x]
```

## Writting `map` and `filter` with `foldr`

``` haskell
map' :: (a -> b) -> [a] -> [b]
map' f = foldr (\x acc -> f x : acc) []

filter' :: (a -> Bool) -> [a] -> [a]
filter' f = foldr (\x acc -> if f x then x : acc else acc) []
```

## Defining Type Synonims

``` haskell
type IntList = [Int]

my_list = read "[1, 2, 3]" :: IntList
```

## Defining own Types

``` haskell
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
```

## Including type in Typeclass

``` haskell
data Lista a = Gol | Lista a (Lista a)

instance (Show a) => Show (Lista a) where
    show Gol = ""
    show (Lista a l) = show a ++ " " ++ show l
```

## Creating new typeclases

``` haskell
class MyEq a where
    (===) :: a -> a -> Bool
    (/==) :: a -> a -> Bool
    x === y = not (x /== y)
    x /== y = not (x === y)
```

## Cusom operators

Operators have a `fixity`.
Basic operators are:
1. `infixl 7 *`
2. `infixl 6 +`
3. `infixr 0 $`

For defining own operators:
``` haskell
infixr 5 :-:  
data List a
    = Empty
    | a :-: (List a)
    deriving (Show, Read, Eq, Ord)  

infixl 9 -=
(-=) :: Int -> Int -> Int
0 -= _ = 0
a -= b = a + b
```

## Case Expressions

``` haskell
tellVar :: Maybe Int -> String
tellVar m =
    case m of
        Just x -> "Value is " ++ show x
        otherwise -> "Nope"

tellVar $ Just 10 -- returns "Value is 10"
tellVar Nothing   -- returns "Nope"
```

## QuickCheck

``` haskell
import Test.QuickCheck

prop :: Int -> Int -> Bool
prop a b = (a + b) == (b + a)

quickCheck prop
```

## Specify type within function

``` haskell
mapTimes2 :: [Int] -> [Int]
mapTimes2 =
    let mul2 :: Int -> Int
        mul2 x = 2 * x in
    map mul2
```

## Lista de functii utile

| Nume      | Descriere         | Inclus 
| --------- | ------------      | ---------
| `elem`    | x exista in lista | `Prelude`
| `isDigit` | este digit        | `Data.Char`
| `isUpper` | este litara mare  | `Data.Char`
| `isLower` | este litera mica  | `Data.Char`
| `isAlpha` | este litera       | `Data.Char`
|`isAphaNum`| este litera/cifra | `Data.Char`
| `toLower` | face litera mica  | `Data.Char`
| `toUpper` | face litera mare  | `Data.Char`
| `and`     | vectorul are true | `prelude`
| `all`     | verifica o contitie| `prelude`
| `lookup`  | daca a e in [(a, b)] | `prelude`
| `partition` | splituieste dupa o conditie | `Data.List`

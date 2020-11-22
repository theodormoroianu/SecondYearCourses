import Test.QuickCheck

double :: Int -> Int
double = (*2)

triple :: Int -> Int
triple = (*3)

penta :: Int -> Int
penta = (*4)

test:: Int -> Bool
test x = double x + triple x == penta x


myLookUp :: Int -> [(Int, String)]-> Maybe String
myLookUp x l =
    let f = filter (\(a, _) -> a == x) l in
    if  null f then
        Nothing
    else
        Just $ snd $ head f



// TODO


testLookUp :: Int -> [(Int, String)] -> Bool
testLookUp = undefined

-- testLookUpCond :: Int -> [(Int,String)] -> Property
-- testLookUpCond n list = n > 0 && n `div` 5 == 0 ==> testLookUp n list

data ElemIS = I Int | S String
     deriving (Show,Eq)

myLookUpElem :: Int -> [(Int,ElemIS)]-> Maybe ElemIS
myLookUpElem = undefined

testLookUpElem :: Int -> [(Int,ElemIS)] -> Bool
testLookUpElem = undefined

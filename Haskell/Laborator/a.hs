--import Control.Applicative

cmmdc :: Int -> Int -> Int
cmmdc 0 b = b
cmmdc a 0 = a
cmmdc a b =
    if a > b then
        cmmdc (a - b) b
    else
        cmmdc a (b - a)

main = do
    return (cmmdc 10 4)

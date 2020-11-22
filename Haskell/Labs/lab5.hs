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

semn :: [Int] -> String
semn =
    let f :: Int -> String -> String
        f x
            | x < 0 && x > -10 = ('-':)
            | x == 0 = ('0':)
            | x < 10 && x > 0  = ('+':)
            | otherwise = id in
    foldr' f ""


-- Ex 3
corect :: [[a]] -> Bool
corect m =
    let lungimi = map length m in
    null lungimi ||
    all (\x -> x == head lungimi) lungimi

el :: [[a]] -> Int -> Int -> a
el m a b = (m !! a) !! b

transforma :: [[a]] -> [(a, Int, Int)]
transforma m =
    let modif_lin :: ([a], Int) -> [(a, Int, Int)]
        modif_lin (l, id) =
            zip l [1..] >>= (\(val, i) -> [(val, id, i)]) in
    zip m [1..] >>= modif_lin
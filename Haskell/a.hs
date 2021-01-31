
-- Recapitulare

-- Tipuri
b :: Bool
b = True

l :: [] Int -- [Int]
l = 1:2:3:[]


p :: IO Int
p = do
    a <- readLn :: IO Int
    return (a + 1)

afiseaza :: IO ()
afiseaza = do
    suma <- p
    print suma
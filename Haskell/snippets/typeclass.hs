data TraficLight = Red | Green | Yellow

instance Eq TraficLight where
    Red == Red = True
    Green == Green = True
    Yellow == Yellow = True
    _ == _ = False

instance Show TraficLight where
    show Red = "Red trafic"
    show Green = "Green trafic"
    show Yellow = "Yellow Trafic"

class YesNo a where
    yesno :: a -> Bool

instance YesNo [a] where
    yesno [] = False
    yesno _ = True

-- identity function
instance YesNo Bool where
    yesno = id

main = do
    let red = Red
    let green = Green
    print $ red == green
    print red
    print $ yesno "123"
import Control.Monad

-- compunerea functiilor

compunere :: (b -> c) -> (a -> b) -> a -> c
compunere f g x = f $ g x

data Lista a = Goala | a ::: (Lista a)

instance Foldable Lista where
    foldr _ d Goala = d
    foldr f d (x ::: rest) =
        let r = foldr f d rest in
        f x r

-- instance Foldable Lista where
--     foldMap _ Goala = mempty 
--     foldMap f (a ::: rest) = f a `mappend` foldMap f rest

infixr :::
instance Show a => Show (Lista a) where
    show Goala = "[]"
    show l = "[ " ++ foldr (\x acc -> show x ++ " " ++ acc) "" l ++ "]"

instance Eq a => Eq (Lista a) where
    Goala == Goala = True
    _ == Goala = False
    Goala == _ = False
    (a ::: rest) == (b ::: rest2) = (a == b) && rest == rest2

 
instance Functor Lista where
    fmap _ Goala = Goala
    fmap f (a ::: rest) = f a ::: fmap f rest


instance Semigroup (Lista a) where
    Goala <> a = a
    (x ::: y) <> a = x ::: (y <> a)

instance Monoid  (Lista a) where
    mempty = Goala

instance Applicative Lista where
    pure f = f ::: Goala
    Goala <*> _ = Goala
    _ <*> Goala = Goala
    (a ::: b) <*> l = fmap a l <> (b <*> l)

instance Monad Lista where
    Goala >>= _ = Goala
    (a ::: b) >>= f = f a <> (b >>= f)


readNLines :: Int -> IO (Lista String)
readNLines 0 = return Goala
readNLines n = do
    name <- getLine
    rest <- readNLines (n - 1)
    return $ name ::: rest

readNames :: IO (Lista String)
readNames = do
    n <- read <$> getLine :: IO Int
    readNLines n


salutPeople :: IO ()
salutPeople = do
    names <- readNames
    when (length names < 4) (do
        print "You won't have many friends!"
        return ())
    print names
    return ()

data Cutie a = Cutie a

instance Monad Cutie where
    return a = Cutie a
    (Cutie a) >>= f = f a

instance Applicative Cutie where
    a <*> b = do
        f <- a
        f <$> b
    pure = return

instance Functor Cutie where
    fmap f cutie = f <$> cutie


readstuff :: IO ()
readstuff = do
    n <- read <$> getLine
    when (n < 10) $ do
        print "Ce penal!"
        print "haha"
    print $ "You said " ++ show n
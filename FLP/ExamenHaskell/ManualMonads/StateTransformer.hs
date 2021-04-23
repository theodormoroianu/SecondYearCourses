{-# LANGUAGE FlexibleInstances #-}
import Data.Maybe

type Name = String

data Condition
    = Name :>: Int
    | Name :=: Name

data Op
    = If Condition Op Op
    | Name ::= Int
    | Increment Name
    | Chain [Op]

type Env = [(Name, Int)]

newtype StateT m a b = State { runState :: a -> m (b, a) }

type State = StateT Maybe

get :: State a a
get = State $ \a -> Just (a, a)

put :: a -> State a ()
put e = State $ \_ -> Just ((), e)

instance (Monad m) => Monad (StateT m hold) where
    return x = State $ \e -> return (x, e)
    mon >>= fun =
        State $ \e -> do
            (val, new_e) <- runState mon e
            runState (fun val) new_e

instance (Monad m) => Applicative (StateT m a) where
    pure = return
    a <*> b = do
        f <- a
        x <- b
        return $ f x

instance (Monad m) => Functor (StateT m a) where
    fmap f x = do
        a <- x
        return $ f a

type M = State Env

getValue :: Name -> M Int
getValue name = do
    env <- get
    case lookup name env of
        Nothing -> State $ const Nothing 
        Just x -> return x

checkCondition :: Condition -> M Bool
checkCondition (n1 :>: i) = do
    env <- get
    v1 <- getValue n1
    return (v1 > i)
checkCondition (n1 :=: n2) = do
    env <- get
    v1 <- getValue n1
    v2 <- getValue n2
    return (v1 == v2)

runOp :: Op -> M ()
runOp (If cond op1 op2) = do
    x <- checkCondition cond
    if x then
        runOp op1
    else
        runOp op2
runOp (name ::= val) = do
    env <- get
    put ((name, val):env)
runOp (Increment n) = do
    env <- get
    let val = fromJust $ lookup n env
    put ((n, val + 1):env)
runOp (Chain l) = mapM_ runOp l

expr = Chain [
    "A" ::= 10,
    "B" ::= 3,
    If ("C" :>: 5)
        (Increment "A")
        ("A" ::= 10),
    "B" ::= 5
    ]


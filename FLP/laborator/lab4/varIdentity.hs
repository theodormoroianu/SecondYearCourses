import Data.Maybe
--- Monada Identity

newtype Identity a = Identity { runIdentity :: a }

instance Monad Identity where
  return = Identity
  (Identity a) >>= f = f a

instance Applicative Identity where
  pure = return
  a <*> b = do
    f <- a
    f <$> b

instance Functor Identity where
  fmap f a = f <$> a

--- Limbajul si  Interpretorul

type M = Identity


showM :: Show a => M a -> String
showM (Identity a) = show a

type Name = String

data Term = Var Name
          | Con Integer
          | Term :+: Term
          | Lam Name Term
          | App Term Term
  deriving (Show)

pgm :: Term
pgm = App
  (Lam "y"
    (App
      (App
        (Lam "f"
          (Lam "y"
            (App (Var "f") (Var "y"))
          )
        )
        (Lam "x"
          (Var "x" :+: Var "y")
        )
      )
      (Con 3)
    )
  )
  (Con 4)


data Value = Num Integer
           | Fun (Value -> M Value)
           | Wrong

instance Show Value where
 show (Num x) = show x
 show (Fun _) = "<function>"
 show Wrong   = "<wrong>"

type Environment = [(Name, Value)]

interp :: Term -> Environment -> M Value
interp (Var name) env =
  case lookup name env of
    Nothing -> Identity Wrong
    Just val -> Identity val
interp (Con x) _ = Identity $ Num x
interp (a :+: b) env =
  case (interp a env, interp b env) of
    (Identity (Num a), Identity (Num b)) -> Identity $ Num $ a + b
    _ -> Identity Wrong
interp (Lam name exp) env =
  Identity $ Fun (\x -> interp exp ((name, x) : env))
interp (App f v) env =
  case (interp f env, interp v env) of
    (Identity (Fun f), Identity x) -> f x

test :: Term -> String
test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))
          
s1 = test pgm
s2 = test pgm1

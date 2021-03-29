import Data.Maybe

--- Limbajul si  Interpretorul

type M = Maybe


showM :: Show a => M a -> String
showM (Just a) = show a
showM Nothing = "<wrong>"

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

instance Show Value where
 show (Num x) = show x
 show (Fun _) = "<function>"

type Environment = [(Name, Value)]

interp :: Term -> Environment -> M Value
interp (Var name) env =
  lookup name env
interp (Con x) _ = Just $ Num x
interp (a :+: b) env =
  case (interp a env, interp b env) of
    (Just (Num a), Just (Num b)) -> Just $ Num $ a + b
    _ -> Nothing
interp (Lam name exp) env =
  Just $ Fun (\x -> interp exp ((name, x) : env))
interp (App f v) env =
  case (interp f env, interp v env) of
    (Just (Fun f), Just x) -> f x

test :: Term -> String
test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))
          
s1 = test pgm
s2 = test pgm1

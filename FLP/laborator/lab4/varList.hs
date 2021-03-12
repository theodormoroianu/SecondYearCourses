
--- Limbajul si  Interpretorul

type M = []

showM :: Show a => M a -> String
showM = foldMap (\a -> show a ++ " ")

type Name = String

data Term = Var Name
          | Con Integer
          | Term :+: Term
          | Lam Name Term
          | App Term Term
          | Fail
          | Amb Term Term
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
      (Amb (Con 3) (Con 1))
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
  case lookup name env of
    Just x -> return x
    Nothing -> []

interp (Con x) _ = return $ Num x

interp (a :+: b) env = do
  v1 <- interp a env
  v2 <- interp b env

  case (v1, v2) of
    (Num x, Num y) -> return $ Num (x + y)
    _ -> []

interp (Lam name exp) env =
  return $ Fun (\x -> interp exp ((name, x) : env))

interp (App f v) env = do
  intf <- interp f env
  intv <- interp v env

  case intf of
    Fun a -> a intv
    _ -> []

interp Fail _ = []

interp (Amb a b) env =
  (interp a env) ++ (interp b env)

test :: Term -> String
test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))
          
s1 = test pgm
s2 = test pgm1

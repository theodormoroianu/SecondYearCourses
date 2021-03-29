import Data.Maybe

--- Limbajul si  Interpretorul

type M = Either String


showM :: Show a => M a -> String
showM (Right a) = show a
showM (Left s) = "<wrong: " ++ s ++ ">"

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
          (Var "x" :+: Var "z")
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
  case lookup name env of
    Just x -> Right x
    Nothing -> Left $ "Unbound variable " ++ name

interp (Con x) _ = Right $ Num x

interp (a :+: b) env = do
  v1 <- interp a env
  v2 <- interp b env

  case (v1, v2) of
    (Num x, Num y) -> Right $ Num (x + y)
    _ -> Left $ "Should be numbers: " ++ show v1 ++ show v2

interp (Lam name exp) env =
  Right $ Fun (\x -> interp exp ((name, x) : env))

interp (App f v) env = do
  intf <- interp f env
  intv <- interp v env

  case intf of
    Fun a -> a intv
    _ -> Left $ "Should be function: " ++ show f

test :: Term -> String
test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))
          
s1 = test pgm
s2 = test pgm1

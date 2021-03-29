--- Limbajul si  Interpretorul

newtype EnvReader a = Reader { runEnvReader :: Environment -> a }

instance Monad EnvReader where
  return x = Reader $ const x
  a >>= f = Reader (\env ->
    let x = runEnvReader a env in
    runEnvReader (f x) env)
    
instance Applicative EnvReader where
  pure = return
  a <*> b = do
    f <- a
    f <$> b

instance Functor EnvReader where
  fmap f a = f <$> a


ask :: EnvReader Environment
ask = Reader id

local :: (Environment -> Environment) -> EnvReader a -> EnvReader a
local f (Reader transf) =
  Reader (\env -> transf (f env))

type M = EnvReader


data Value = Num Integer
           | Fun (Value -> M Value)
           | Wrong

instance Show Value where
 show (Num x) = show x
 show (Fun _) = "<function>"
 show Wrong   = "<wrong>"


type Environment = [(Name, Value)]

showM :: Show a => M a -> String
showM e = show $ runEnvReader e []

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
      (Con 2)
    )
  )
  (Con 4)



interp :: Term -> M Value
interp (Var name) = do
  env <- ask
  case lookup name env of
    Just x -> return x
    Nothing -> return Wrong

interp (Con x) = return $ Num x

interp (a :+: b) = do
  v1 <- interp a
  v2 <- interp b

  case (v1, v2) of
    (Num x, Num y) -> return $ Num (x + y)
    _ -> return Wrong

interp (Lam name exp) = do
  state <- ask
  return $ Fun $ \x ->
    local (const $ (name, x): state) $ interp exp

interp (App f v) = do
  intf <- interp f
  intv <- interp v

  case intf of
    Fun a -> a intv
    _ -> return Wrong

test :: Term -> String
test t = showM $ interp t

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))
          
s1 = test pgm
s2 = test pgm1

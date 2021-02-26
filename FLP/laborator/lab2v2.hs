import Data.Maybe
import Data.List

type Name = String

data  Pgm  = Pgm [Name] Stmt
        deriving (Read, Show)

data Stmt = Skip | Break | Stmt ::: Stmt | If BExp Stmt Stmt | While BExp Stmt | Name := AExp
        deriving (Read, Show)

data AExp = Lit Integer | AExp :+: AExp | AExp :*: AExp | Var Name
        deriving (Read, Show)

data BExp = BTrue | BFalse | AExp :==: AExp | Not BExp
        deriving (Read, Show)

infixr 2 :::
infix 3 :=
infix 4 :==:
infixl 6 :+:
infixl 7 :*:


type Env = [(Name, Integer)]


factStmt :: Stmt
factStmt =
  "p" := Lit 1 ::: "n" := Lit 5 :::
  While (Not (Var "n" :==: Lit 0))
    ( "p" := Var "p" :*: Var "n" :::
      "n" := Var "n" :+: Lit (-1)
    )
    
factStmt2 :: Stmt
factStmt2 =
    "p" := Lit 1 ::: "n" := Lit 5 :::
    While (BTrue) ( 
        If (Var "n" :==: Lit 0)
            Break
        (
            "act" := Lit 0 :::
            "cnt" := Lit 0 :::
            While (Not $ Var "cnt" :==: Var "n") (
                "act" := (Var "act" :+: Var "p") :::
                "cnt" := (Var "cnt" :+: Lit 1)
            ) :::
            "p" := Var "act" :::
            "n" := Var "n" :+: Lit (-1)
      
        )
    ) :::
    "p" := (Var "p" :+: Lit 1)
    
pg1 = Pgm [] factStmt 
pg2 = Pgm [] factStmt2 


aEval :: AExp -> Env -> Integer
aEval (Lit a) _ = a
aEval (a :+: b) e = aEval a e + aEval b e  
aEval (a :*: b) e = aEval a e * aEval b e  
aEval (Var name) e = fromJust $ lookup name e

bEval :: BExp -> Env -> Bool
bEval BTrue _ = True
bEval BFalse _ = False
bEval (a :==: b) e = aEval a e == aEval b e
bEval (Not a) e = not $ bEval a e 

sEval :: Stmt -> Env -> Env
sEval Break env = ("__Break", undefined) : env
sEval Skip env = env
sEval (a ::: b) env =
    let new_env = sEval a env in
    if not (null new_env) && fst (head new_env) == "__Break" then
        env
    else sEval b new_env
sEval (If exp a b) env
 | not (null env) && fst (head env) == "__Break" = env
 | bEval exp env = sEval a env
 | otherwise = sEval b env
sEval s@(While exp a) env
 | not (null env) && fst (head env) == "__Break" = tail env
 | not $ bEval exp env = env
 | otherwise = sEval s $ sEval a env
sEval (name := a) env
 | not (null env) && fst (head env) == "__Break" = env
 | otherwise =
    let rez = aEval a env in
        if isNothing $ lookup name env then
            (name, rez) : env
        else
            map (\(n, val) -> if n == name then (n, rez) else (n, val)) env

pEval :: Pgm -> Env
pEval (Pgm names s) =
    sEval s $ map (\x -> (x, 0)) names

   
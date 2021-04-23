-- Theodor Moroianu
-- Grupa 234
-- 23 Aprilie 2021

{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are doua celule de memorie, care au valoarea initiala 0. Expresia `Mem := Expr` are urmatoarea semantica: 
`Expr` este evaluata, iar valoarea este pusa in `Mem`.  
Un program este o expresie de tip `Prog`iar rezultatul executiei este dat de valorile finale ale celulelor de memorie.
Testare se face apeland `run test`. 
-}


-- Monade folosite pentru punctul 3.
import Control.Monad.Writer
import Control.Monad.State

data Prog
    = Stmt ::: Prog
    | Off

data Stmt
    = Mem := Expr

data Mem
    = Mem1 | Mem2 

data Expr
    = M Mem
    | V Int
    | Expr :+ Expr
    | Expr :/ Expr

infixl 6 :+
infix 3 :=
infixr 2 :::

type Env = (Int,Int)   -- corespunzator celor doua celule de memorie (Mem1, Mem2)


-- Parseaza expresii.
-- Arunca o eroare daca intampina o impartire la 0
expr ::  Expr -> Env -> Int
expr (e1 :+  e2) m = expr  e1 m + expr  e2 m
expr (V a) _ = a
expr (M mem) m =
    case mem of
        Mem1 -> fst m
        Mem2 -> snd m
expr (exp1 :/ exp2) env =
    let v1 = expr exp1 env
        v2 = expr exp2 env in
    case v2 of
        0 -> error "Divizie cu 0!"
        _ -> v1 `div` v2

-- Parseaza un statment, si updateaza memoria corespunzator.
stmt :: Stmt -> Env -> Env
stmt (mem := exp) env =
    let val = expr exp env in
    case mem of
        Mem1 -> (val, snd env)
        Mem2 -> (fst env, val)

-- Parseaza un program.
prog :: Prog -> Env -> Env
prog Off m = m
prog (stm ::: rest) env =
    let mem1 = stmt stm env in
    prog rest mem1

-- Ruleaza un program, plecand de la env = (0, 0)
run :: Prog -> Env
run p = prog p (0, 0)


-- Exemple de programe
prg1 = Mem1 := V 3 ::: Mem2 := M Mem1 :+ V 5 ::: Off
prg2 = Mem2 := V 3 ::: Mem1 := V 4 ::: Mem2 := (M Mem1 :+ M Mem2) :+ V 5 ::: Off
prg3 = Mem1 := V 3 :+  V 3 ::: Off
prg4 = Mem1 := V 6 ::: Mem2 := (V 5 :/ V 2) ::: Off

-- Testam functionalitatile
-- toate variabilele definite mai jos au valoarea adevarat
test1 = run prg1 == (3, 8)
test2 = run prg2 == (4, 12)
test3 = run prg3 == (6, 0)
test4 = run prg4 == (6, 2)



{--
    Partea a 3-a
    Pentru a salva starea, am decis sa folosesc monada State Env
    De asemenea, pentru a putea trage dupa noi logurile, am decis sa folosesc 
    monada Writer. Astfel, folosesc un monad transformer, mai precis WriterT.

    M-am gandit sa tin state-ul ca fiind Maybe Env (pentru divizia la 0), dar 
    ar fi insemnat sa am 3 monade una intr-alta si devenea cam urat, asa ca 
    pentru a nu arunca o exceptie la imparirea la 0, consider rezultatul unei 
    impartiri gresite ca fiind 0.
--}

-- Monad transformerul
type M a = WriterT [String] (State Env) a


-- Fac memoria afisabila, pentru mesajele de log.
instance Show Mem where
    show Mem1 = "M1"
    show Mem2 = "M2"

-- Evaluam o expresie.
-- De notat ca divizia la 0 nu mai arunca exceptii asa cum facea mai sus.
evalExpr :: Expr -> M Int
evalExpr (V a) = return a
evalExpr (e1 :+ e2) = (+) <$> evalExpr e1 <*> evalExpr e2
evalExpr (M mem) = do
    env <- lift get
    case mem of
        Mem1 -> return $ fst env
        Mem2 -> return $ snd env
evalExpr (e1 :/ e2) = do
    val1 <- evalExpr e1
    val2 <- evalExpr e2
    case val2 of
        0 -> -- puteam arunca o eroare cu `error "Division by 0"`
            tell ["  !!! Impartire la 0. Setez resultatul ca 0 pentru a nu da crash :("] >> return 0
        _ -> return $ val1 `div` val2

-- Evaluam un statment, 
-- marcand in Writer ce am modificat.
evalStmt :: Stmt -> M ()
evalStmt (mem := expr) = do
    env <- lift get
    val_expr <- evalExpr expr
    tell ["  Celula " ++ show mem ++ " a primit valoarea " ++ show val_expr]
    case mem of
        Mem1 -> lift $ put (val_expr, snd env)
        Mem2 -> lift $ put (fst env, val_expr)

-- Evaluam un program, spunand cand am terminat executia.
evalProg :: Prog -> M ()
evalProg Off = tell ["Finished execution: encountered 'Off' token"]
evalProg (stm ::: rest) = evalStmt stm >> evalProg rest

-- Ruleaza programul, afisand in IO raspunsul.
runM :: Prog -> IO ()
runM prog = do
    putStr "Care e valoarea initiala a lui M1? "
    val1 <- (readLn :: IO Int)
    putStr "Care e valoarea initiala a lui M2? "
    val2 <- (readLn :: IO Int)
    
    let env_init = (val1, val2)
    let ((_, logs), final_env) = runState (runWriterT $ evalProg prog) env_init
    putStrLn $ "Env final: " ++ show final_env
    putStrLn "Logs: "
    mapM_ putStrLn logs

-- Ruleaza programul dintr-un env.
runMFromEnv :: Prog -> Env -> (Env, [String])
runMFromEnv prog env =
    let ((_, logs), final_env) = runState (runWriterT $ evalProg prog) env in
    (final_env, logs)

-- Ruleaza programu dintr-un env gol, asa cum e cerinta
runMFromEmptyEnv :: Prog -> (Env, [String])
runMFromEmptyEnv = flip runMFromEnv (0, 0)

-- programe care considera si imparitea la 0
prg5 = Mem1 := V 3 ::: Mem2 := M Mem1 :+ V 5 ::: Mem1 := M Mem1 :/ V 0 ::: Off
prg6 = Mem2 := V 3 ::: Mem1 := V 4 ::: Mem2 := (M Mem1 :+ M Mem2) :+ V 5 ::: Mem1 := V 0 ::: Mem2 := M Mem2 :/ M Mem1 ::: Off

-- Testam functionalitatile
-- toate variabilele definite mai jos au valoarea adevarat
testM1 =
    let (env, logs) = runMFromEnv prg1 (0, 0) in
    env == (3, 8) && length logs == 3
testM2 =
    let (env, logs) = runMFromEnv prg2 (0, 0) in
    env == (4, 12) && length logs == 4
testM3 =
    let (env, logs) = runMFromEnv prg3 (0, 0) in
    env == (6, 0) && length logs == 2
testM4 =
    let (env, logs) = runMFromEnv prg4 (0, 0) in
    env == (6, 2) && length logs == 3
testM5 =
    let (env, logs) = runMFromEnv prg5 (0, 0) in
    env == (0, 8) && length logs == 5
testM6 =
    let (env, logs) = runMFromEnv prg6 (0, 0) in
    env == (0, 0) && length logs == 7


{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10 pct) Adaugati expresia `e1 :/ e2` care evaluează expresiile e1 și e2, apoi
  - dacă valoarea lui e2 e diferită de 0, se evaluează la câtul împărțirii lui e1 la e2;
  - în caz contrar va afișa eroarea "împarțire la 0" și va încheia execuția.
3)(20pct) Definiti interpretarea  limbajului extins astfel incat executia unui program fara erori sa intoarca valoarea finala si un mesaj
   care retine toate modificarile celulelor de memorie (pentru fiecare instructiune `m :< v` se adauga 
   mesajul final `Celula m a fost modificata cu valoarea v`), mesajele pastrand ordine de efectuare a instructiunilor.  
    Rezolvați subiectul 3) în același fișier redenumind funcțiile de interpretare. 

Indicati testele pe care le-ati folosit in verificarea solutiilor. 

-}
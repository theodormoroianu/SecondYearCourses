import Data.List

data Variable
    = Variable String Int
    deriving (Eq)

instance Show Variable where
    show (Variable name c) = name ++ "_" ++ show c

var :: String -> Variable
var x = Variable x 0

fresh :: Variable -> [Variable] -> Variable
fresh (Variable name _) lst =
    let useful = filter (\(Variable n _) -> n == name) lst
        nr = map (\(Variable _ x) -> x) useful
        count = foldr max 0 nr in
    Variable name (count + 1)

 
data Term
    = V Variable
    | App Term Term
    | Lam Variable Term

instance Show Term where
    show (V x) = show x
    show (App t1 t2) = "(" ++ show t1 ++ " " ++ show t2 ++ ")"
    show (Lam x t) = "(\\" ++ show x ++ "." ++ show t ++ ")"

v :: String -> Term
v x = V (var x)

lam :: String -> Term -> Term
lam x = Lam (var x)

lams :: [String] -> Term -> Term
lams xs t = foldr lam t xs

($$) :: Term -> Term -> Term
($$) = App
infixl 9 $$

test_1 = show (v "x") == "x"
test_2 = show (v "x" $$ v "y") == "(x y)"
test_3 = show (lam "x" (v "x")) == "(\\x.x)"
test_4 = show (lams ["x","y"] (v "x")) == "(\\x.(\\y.x))"


freeVars :: Term -> [Variable] 
freeVars term =
    freeVarsRec term []
    where
        freeVarsRec :: Term -> [Variable] -> [Variable]
        freeVarsRec (V var) lst
            | var `elem` lst = []
            | otherwise = [var]
        freeVarsRec (App t1 t2) lst =
            nub $ freeVarsRec t1 lst ++ freeVarsRec t2 lst
        freeVarsRec (Lam var t) lst =
            freeVarsRec t (nub $ var:lst)


test_5 = freeVars (lam "x" (v "x" $$ v "y")) == [var "y"]

allVars :: Term -> [Variable]
allVars (V var) = [var]
allVars (App t1 t2) =
    nub $ allVars t1 ++ allVars t2
allVars (Lam v t) =
    nub $ v:allVars t

test_6 = allVars (lam "x" (v "x" $$ v "y")) == [var "x", var "y"]

subst :: Term -> Variable -> Term -> Term -- [u/x]t
subst u x (V var)
    | x == var = u
    | otherwise = V var
subst u x (App t1 t2) =
    App (subst u x t1) (subst u x t2)
subst u x (Lam y t) -- usor diferita fata de curs
    | x == y = Lam y t
    | y `notElem` freeVarsU =
        Lam y $ subst u x t
    | x `notElem` freeVarsT =
        Lam y t
    | otherwise =
        Lam y' $ subst u x t'
    where
    freeVarsT = freeVars t
    freeVarsU = freeVars u
    allFreeVars = nub ([x] ++ freeVarsU ++ freeVarsT)
    y' = fresh y allFreeVars
    t' = subst (V y') y t -- t' = [y'/y]t

aEq :: Term -> Term -> Bool
aEq (V a) (V b) = a == b
aEq (App a1 a2) (App b1 b2) =
    a1 `aEq` b1 && a2 `aEq` b2
aEq (Lam x1 t1) (Lam x2 t2)
    | x1 == x2 = t1 `aEq` t2
    | otherwise =
        let new_var = fresh x1 $ nub $ allVars t1 ++ allVars t2 ++ [x1, x2]
            new_t1 = subst (V new_var) x1 t1
            new_t2 = subst (V new_var) x2 t2 in
        new_t1 `aEq` new_t2
aEq _ _ = False 

test_7 = aEq (lam "x" (v "x")) (lam "y" (v "y"))
test_8 = not $ aEq (lam "x" (v "x")) (lam "y" (v "z"))

exp1 = (lam "x" $ v "x")
exp2 = (lam "y" $ v "x")
test_9 = not $ aEq (lam "x" $ v "x") (lam "y" $ v "x")

reduce :: Term -> Term
reduce t =
    case reduceOnce t of
        Nothing -> t
        Just x -> reduce x
    where
        reduceOnce :: Term -> Maybe Term
        reduceOnce (App (Lam x t1) t2) =
            Just $ subst t2 x t1
        reduceOnce (App t1 t2) =
            case reduceOnce t1 of
                Nothing -> App t1 <$> reduceOnce t2
                Just a -> Just $ App a t2
        reduceOnce (Lam x t) =
            Lam x <$> reduceOnce t
        reduceOnce (V _) = Nothing       

omega = App (lam "x" $ App (v "x") (v "x")) (lam "x" $ App (v "x") (v "x"))

abEq :: Term -> Term -> Bool
abEq a b =
    let reda = reduce a
        redb = reduce b in
    aEq reda redb

test_10 = reduce (lams ["m", "n"] (v "n" $$ v "m")
                    $$ lams ["s", "z"] (v "s" $$ (v "s" $$ v "z"))
                    $$ lams ["s", "z"] (v "s" $$ (v "s" $$ (v "s" $$ v "z"))))
            `abEq`
                lams ["s", "z"] (v "s" $$ (v "s" $$ (v "s" $$ (v "s"
                $$ (v "s" $$ (v "s" $$ (v "s" $$ (v "s" $$ v "z"))))))))

exp3 = reduce (lams ["m", "n"] (v "n" $$ v "m")
                    $$ lams ["s", "z"] (v "s" $$ (v "s" $$ v "z"))
                    $$ lams ["s", "z"] (v "s" $$ (v "s" $$ (v "s" $$ v "z"))))
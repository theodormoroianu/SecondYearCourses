type Name = String
data Hask
    = HTrue
    | HFalse
    | HLit Int
    | HIf Hask Hask Hask
    | Hask :==: Hask
    | Hask :+: Hask
    | HVar Name
    | HLam Name Hask
    | Hask :$: Hask
    deriving (Read, Show)
infix 4 :==:
infixl 6 :+:
infixl 9 :$:

data Value
    = VBool Bool
    | VInt Int
    | VFun (Value -> Value)
    | VError -- pentru reprezentarea erorilor
type HEnv = [(Name, Value)]

type DomHask = HEnv -> Value



-- Ex 1
instance Show Value where
    show (VBool b) = show b
    show (VInt i) = show i
    show (VFun _) = "function"
    show VError = "error"

-- Ex 2
instance Eq Value where
    (VBool b1) == (VBool b2) = b1 == b2
    (VInt i1) == (VInt i2) = i1 == i2
    _ == _ = False

-- Ex 3

isError :: Value -> Bool
isError VError = True
isError _ = False

hEval :: Hask -> HEnv -> Value
hEval HTrue _ = VBool True
hEval HFalse _ = VBool False
hEval (HLit i) _ = VInt i
hEval (HIf a b c) env =
    case hEval a env of
        VBool True -> hEval b env
        VBool False -> hEval c env
        _ -> VError
hEval (a :==: b) env =
    let x :: Value
        x = hEval a env
        y :: Value
        y = hEval b env in
    if isError x || isError y then
        VError
    else
        VBool $ x == y
hEval (a :+: b) env =
    let x :: Value
        x = hEval a env
        y :: Value
        y = hEval b env in
    case (x, y) of
        (VInt a, VInt b) -> VInt (a + b)
        _ -> VError
hEval (HVar n) env =
    let rez = lookup n env in
    case rez of
        Nothing -> VError
        Just exp -> exp
hEval (HLam n exp) env =
    VFun (\x ->
        let new_entry = (n, x)
            new_env =
                if lookup n env == Nothing then
                    new_entry : env 
                else
                    map (\(name, val) ->
                        if name == n then
                            new_entry
                        else
                            (name, val)) env in
        hEval exp new_env)
hEval (a :$: b) env =
    let fun = hEval a env
        val = hEval b env in
    case fun of
        VError -> VError
        VFun f -> f val


lambdaExp :: Hask
lambdaExp = HLam "X" (HVar "X" :+: HVar "X") :$: HLit 10

eval :: Value
eval = hEval lambdaExp []
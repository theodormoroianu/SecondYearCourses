data Piesa = One   -- primul jucător
            | Two   -- al doilea jucător
            | Empty -- căsuță liberă pe tablă
   deriving (Show, Eq)

data Careu = C [Piesa]
      deriving (Show,Eq)

type Tabla = [Careu]

table1 :: Tabla
table1 = [C [Empty, One, Two, One, Empty, Empty, Two, One],
          C [Two, Empty, One, Two, One, Two, One, Two],
          C [Two, Two, One, Empty, Empty, One, Two, One]]

table2 :: Tabla
table2 = [C [Two, One, Two, One, Empty, Empty, Two, One],
          C [Two, Empty, One, Two, One, Two, One, Two],
          C [Two, Two, One, Empty, Empty, One, Two, One]]

table3 :: Tabla
table3 = [C [Empty, One, Empty, Empty, Empty, Empty, Two, One],
          C [Two, Empty, One, Two, One, Two, One, Two],
          C [Two, Empty, One, Empty, Empty, One, Two, One]]

table4 :: Tabla
table4 = [C [Empty,Empty,Two,One,Empty,Empty,Two,One],
          C [Two,One,One,Two,One,Two,One,Two],
          C [Two,Two,One,Empty,Empty,One,Two,One]]
table5 :: Tabla
table5 = [C [Empty,Empty,Two,One,Empty,Empty,Two,One],
          C [Two,One,One,Two,One,Two,One,Two]]



validTabla :: Tabla -> Bool
validTabla tabla =
    let length_elem_is_8 = all (\(C x) -> length x == 8) tabla
        length_tabla_is_3 = length tabla == 3
        count_piese :: Piesa -> Careu -> Int
        count_piese piesa (C l) = length $ filter (== piesa) l
        nr_one = sum $ map (count_piese One) tabla
        nr_two = sum $ map (count_piese Two) tabla in
    length_elem_is_8 && length_tabla_is_3 && nr_one <= 9 && nr_two <= 9

test11 = validTabla table1 == True
test12 = validTabla table2 == False
test13 = validTabla table3 == True
test14 = validTabla table5 == False



data Pozitie = Poz (Int,Int)

instance Show Pozitie where
  show (Poz (i,j)) = "careul " ++ show i ++ " pozitia " ++ show j


getAtPoz :: Tabla -> Pozitie -> Piesa
getAtPoz tabla (Poz (a, b)) =
    let (C careu) = tabla !! a
        piesa = careu !! b in
    piesa

changePozAt :: Tabla -> Pozitie -> Piesa -> Tabla
changePozAt tabla (Poz (a, b)) piesa =
    let prev = take a tabla
        urm = drop (a + 1) tabla
        (C careu) = tabla !! a
        good_careu = C (take b careu ++ [piesa] ++ drop (b + 1) careu) in
    prev ++ [good_careu] ++ urm

move :: Tabla -> Pozitie -> Pozitie -> Maybe Tabla
move tabla (Poz (a1, b1)) (Poz (a2, b2)) =
    if abs(a1 - a2) + abs(b1 - b2) /= 1 ||
            getAtPoz tabla (Poz (a1, b1)) == Empty ||
            getAtPoz tabla (Poz (a2, b2)) /= Empty then
        Nothing
    else
        let piesa = getAtPoz tabla (Poz (a1, b1))
            tabla_removed = changePozAt tabla (Poz (a1, b1)) Empty
            tabla_added = changePozAt tabla_removed (Poz (a2, b2)) piesa in
        Just tabla_added

test21 = move table2 (Poz (0,2)) (Poz(1,2)) == Nothing
test22 = move table1 (Poz (0,2)) (Poz(1,2)) == Nothing
test23 = move table1 (Poz (0,1)) (Poz(1,1))
       == Just ([C [Empty,Empty,Two,One,Empty,Empty,Two,One],
                  C [Two,One,One,Two,One,Two,One,Two],
                  C [Two,Two,One,Empty,Empty,One,Two,One]])
                      -- table4
test24 = move table1 (Poz (2,1)) (Poz(1,1))
        == Just ([C [Empty,One,Two,One,Empty,Empty,Two,One],
                  C [Two,Two,One,Two,One,Two,One,Two],
                  C [Two,Empty,One,Empty,Empty,One,Two,One]])



data EitherWriter a = EW {getvalue :: Either String (a, String)}

instance Functor EitherWriter where
    fmap f (EW (Left s)) = EW (Left s)
    fmap f (EW (Right (a, s))) = EW (Right (f a, s))

instance Applicative EitherWriter where
    pure f = EW (Right (f, ""))
    EW (Left s) <*> _ = EW (Left s)
    _ <*> EW (Left s) = EW (Left s)
    EW (Right (f, s1)) <*> EW (Right (a, s2)) = EW $ Right (f a, s1 ++ "\n" ++ s2)

instance Monad EitherWriter where
    EW (Left s) >>= _ = EW (Left s)
    EW (Right (a, s)) >>= f =
        case f a of
            EW (Left s) -> EW (Left s)
            EW (Right (v, s2)) ->
                EW $ Right (v, s ++ "\n" ++ s2)

movePiece :: Piesa -> Pozitie -> Pozitie -> Tabla -> EitherWriter Tabla
movePiece piesa (Poz (a1, b1)) (Poz (a2, b2)) tabla =
    if getAtPoz tabla (Poz (a1, b1)) /= piesa then
        EW $ Left $ "Jucatorul " ++ show piesa ++ " nu are piesa de la pozitia " ++ show a1 ++ ", " ++ show b1
    else
        case move tabla (Poz (a1, b1)) (Poz (a2, b2)) of
            Nothing -> EW $ Left $ "Jucatorul " ++ show piesa ++ " nu are voie sa mute (" ++ show a1 ++ ", " ++ show b1 ++ ")"
            Just tabla_noua -> EW $ Right (tabla_noua, "Jucatorul " ++ show piesa ++ " a mutat")

playGameInternal :: [(Pozitie, Pozitie)] -> [(Pozitie, Pozitie)] -> Piesa -> Piesa -> EitherWriter Tabla -> EitherWriter Tabla
playGameInternal [] _ _ _ tabla = tabla
playGameInternal ((poz1, poz2):poz_mele) poz_oth eu oth tabla =
    let tabla_noua = tabla >>= movePiece eu poz1 poz2 in
    playGameInternal poz_oth poz_mele oth eu tabla_noua


playGame :: Tabla -> [(Pozitie, Pozitie)] -> [(Pozitie, Pozitie)] -> EitherWriter Tabla
playGame tabla one two = playGameInternal one two  One Two $ EW $ Right (tabla, "")


printGame :: EitherWriter Tabla -> IO ()
printGame ewt = do
    let t = getvalue ewt
    case t of
      Left v -> putStrLn v
      Right (t,v) -> putStrLn v

list1, list2 :: [(Pozitie,Pozitie)]
list1 = [(Poz(0,1),Poz(0,0)), (Poz(1,2),Poz(1,1)), (Poz(0,3),Poz(1,3)) ]
list2 = [(Poz(0,6),Poz(0,5)), (Poz(1,3),Poz(2,3)), (Poz(0,2),Poz(0,3)) ]

test41 = printGame $ playGame table1 list1 list2


{-
> test41
Jucatorul One a mutat din careul 0 pozitia 1 in  careul 0 pozitia 0
Jucatorul Two a mutat din careul 0 pozitia 6 in  careul 0 pozitia 5
Jucatorul One a mutat din careul 1 pozitia 2 in  careul 1 pozitia 1
Jucatorul Two a mutat din careul 1 pozitia 3 in  careul 2 pozitia 3
Jucatorul One a mutat din careul 0 pozitia 3 in  careul 1 pozitia 3
Jucatorul Two a mutat din careul 0 pozitia 2 in  careul 0 pozitia 3
Tabla finala este [C [One,Empty,Empty,Two,Empty,Two,Empty,One],C [Two,One,Empty,One,One,Two,One,Two],C [Two,Two,One,Two,Empty,One,Two,One]]
-}
list3, list4 :: [(Pozitie,Pozitie)]
list3 = [(Poz(1,1),Poz(1,0)), (Poz(2,2),Poz(2,4)), (Poz(1,3),Poz(2,3)) ]
list4 = [(Poz(1,6),Poz(1,5)), (Poz(2,3),Poz(3,3)), (Poz(1,2),Poz(1,3)) ]

test42 = printGame $ playGame table1 list3 list4
-- test42
-- Jucatorul One nu poate muta din careul 1 pozitia 1 in  careul 1 pozitia 0
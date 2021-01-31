data Piece = One   -- primul jucător
            | Two   -- al doilea jucător
            | Empty -- căsuță liberă pe tablă
   deriving (Show, Eq)

data Table = Table [Piece] [Piece] [Piece]
   deriving (Show,Eq)

table1 :: Table
table1 = Table [Empty, One, Two, One, Empty, Empty, Two, One]
               [Two, Empty, One, Two, One, Two, One, Two]
               [Two, Two, One, Empty, Empty, One, Two, One]

table2 :: Table
table2 = Table [Two, One, Two, One, Empty, Empty, Two, One]
               [Two, Empty, One, Two, One, Two, One, Two]
               [Two, Two, One, Empty, Empty, One, Two, One]

table3 :: Table
table3 = Table [Empty, One, Empty, Empty, Empty, Empty, Two, One]
               [Two, Empty, One, Two, One, Two, One, Two]
               [Two, Empty, One, Empty, Empty, One, Two, One]

table4 :: Table
table4 = Table [Empty,Empty,Two,One,Empty,Empty,Two,One]
               [Two,One,One,Two,One,Two,One,Two]
               [Two,Two,One,Empty,Empty,One,Two,One]



validTable :: Table -> Bool
validTable (Table t1 t2 t3)=
    let length_is_9 = length t1 == 8 && length t2 == 8 && length t3 == 8
        sum_1 = length $ filter (== One) (t1 ++ t2 ++ t3)
        sum_2 = length $ filter (== Two) (t1 ++ t2 ++ t3) in    
    length_is_9 && sum_1 <= 9 && sum_2 <= 9

test11 = validTable table1 == True
test12 = validTable table2 == False
test13 = validTable table3 == True



data Position = P (Int,Int)

instance Show Position where
  show (P (i,j)) = "careul " ++ show i ++ " pozitia " ++ show j

getPiece :: Table -> Position -> Piece
getPiece (Table t1 t2 t3) (P (a, b)) =
    [t1, t2, t3] !! (a - 1) !! b

changeElem :: Table -> Position -> Piece -> Table
changeElem (Table t1 t2 t3) (P (a, b)) piesa
 | a == 1 = Table (take b t1 ++ [piesa] ++ drop (b + 1) t1) t2 t3
 | a == 2 = Table t1 (take b t2 ++ [piesa] ++ drop (b + 1) t2) t3
 | a == 3 = Table t1 t2 (take b t3 ++ [piesa] ++ drop (b + 1) t3)
 | otherwise = error "Poz is not valid!"

movePozWorks :: Position -> Position -> Bool
movePozWorks (P (a1, b1)) (P (a2, b2)) =
    if a1 == a2 then
        abs(b1 - b2) == 1 || abs(b1 - b2) == 7
    else
        abs(a1 - a2) == 1 && b1 == b2 && odd b1

move :: Table -> Position -> Position -> Maybe Table
move table p1@(P (a1, b1)) p2@(P (a2, b2)) =
    if movePozWorks p1 p2 then
        let piesa1 = getPiece table p1
            piesa2 = getPiece table p2 in
        if piesa1 == Empty || piesa2 /= Empty then
            Nothing
        else
            let tabla1 = changeElem table p1 Empty
                table2 = changeElem tabla1 p2 piesa1 in
            Just table2
    else
        Nothing 

test21 = move table2 (P (1,2)) (P(2,2)) == Nothing
test22 = move table1 (P (1,2)) (P(2,2)) == Nothing
test23 = move table1 (P (1,1)) (P(2,1))
       == Just (Table [Empty,Empty,Two,One,Empty,Empty,Two,One]
                      [Two,One,One,Two,One,Two,One,Two]
                      [Two,Two,One,Empty,Empty,One,Two,One])
                      -- table4
test24 = move table1 (P (3,1)) (P(2,1))
        == Just (Table [Empty,One,Two,One,Empty,Empty,Two,One]
                       [Two,Two,One,Two,One,Two,One,Two]
                       [Two,Empty,One,Empty,Empty,One,Two,One])



data EitherWriter a = EW {getvalue :: Either String (a, String)}

instance Functor EitherWriter where
    fmap f (EW (Left s)) = EW $ Left s
    fmap f (EW (Right (a, s))) = EW $ Right (f a, s)

instance Applicative EitherWriter where
    pure f = EW $ Right (f, "")
    EW (Left s) <*> _ = EW (Left s)
    _ <*> EW (Left s) = EW (Left s)
    EW (Right (f, s1)) <*> EW (Right (a, s2)) = EW $ Right (f a, s1 ++ "\n" ++ s2)

instance Monad EitherWriter where
    EW (Left s) >>= _ = EW (Left s)
    EW (Right (a, s)) >>= f =
        case f a of
            EW (Left er) -> EW (Left er)
            EW (Right (val, s2)) -> EW $ Right (val, s ++ "\n" ++ s2)

playMove :: Position -> Position -> Piece -> Table -> EitherWriter Table
playMove p1 p2 piesa table =
    let piesa_at_poz = getPiece table p1
        new_table = move table p1 p2 in
    if piesa_at_poz /= piesa then
        EW $ Left $ "Piece @(" ++ show p1 ++ " doesn't belong to " ++ show piesa
    else if new_table == Nothing then
        EW $ Left "Unable to move!"
    else
        let Just new_move = new_table in
        EW $ Right (new_move, "Moved " ++ show piesa ++ " from " ++ show p1 ++ " to " ++ show p2)

playPartialGame :: Piece -> Piece -> [(Position, Position)] -> [(Position, Position)] -> Table -> EitherWriter Table
playPartialGame _ _ [] _ table = EW $ Right (table, "")
playPartialGame eu oth ((p1, p2):move_eu) move_oth table =
    playMove p1 p2 eu table >>= playPartialGame oth eu move_oth move_eu

playGame :: Table -> [(Position, Position)] -> [(Position, Position)] -> EitherWriter Table
playGame table m1 m2 = playPartialGame One Two m1 m2 table 

printGame :: EitherWriter Table -> IO ()
printGame ewt = do
    let t = getvalue ewt
    case t of
      Left v -> putStrLn v
      Right (t,v) -> putStrLn (v ++ "\n" ++ show t) 

list1, list2 :: [(Position,Position)]
list1 = [(P(1,1),P(1,0)), (P(2,2),P(2,1)), (P(1,3),P(2,3)) ]
list2 = [(P(1,6),P(1,5)), (P(2,3),P(3,3)), (P(1,2),P(1,3)) ]

test41 = printGame $ playGame table1 list1 list2


{-
> test41
Jucatorul One a mutat din careul 1 pozitia 1 in  careul 1 pozitia 0
Jucatorul Two a mutat din careul 1 pozitia 6 in  careul 1 pozitia 5
Jucatorul One a mutat din careul 2 pozitia 2 in  careul 2 pozitia 1
Jucatorul Two a mutat din careul 2 pozitia 3 in  careul 3 pozitia 3
Jucatorul One a mutat din careul 1 pozitia 3 in  careul 2 pozitia 3
Jucatorul Two a mutat din careul 1 pozitia 2 in  careul 1 pozitia 3
Table finala este Table [One,Empty,Empty,Two,Empty,Two,Empty,One] [Two,One,Empty,One,One,Two,One,Two] [Two,Two,One,Two,Empty,One,Two,One]
-}
list3, list4 :: [(Position,Position)]
list3 = [(P(1,1),P(1,0)), (P(2,2),P(2,4)), (P(1,3),P(2,3)) ]
list4 = [(P(1,6),P(1,5)), (P(2,3),P(3,3)), (P(1,2),P(1,3)) ]

test42 = printGame $ playGame table1 list3 list4
-- test42
-- Jucatorul One nu poate muta din careul 2 pozitia 2 in  careul 2 pozitia 4
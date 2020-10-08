data Aint = Internal Aint Aint Int | Leaf Int

-- Update pe interval cu +1
update :: Aint -> Int -> Int -> Int -> Int -> Aint
update (Leaf val) left right st dr = if left <= st && right >= dr
                                     then Leaf (val + 1)
                                     else Leaf val
update (Internal fiu_st fiu_dr val) left right st dr =  
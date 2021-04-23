import Control.Applicative
import Data.Char

newtype Parser a = Parser { runParser :: String -> [(a, String)] }

instance Monad Parser where
    return x = Parser $ \s -> [(x, s)]
    box >>= f = Parser $ 
        \inp -> 
            let parsed = runParser box inp
            in parsed >>= \(x, s) -> runParser (f x) s
    
instance Applicative Parser where
    pure = return
    a <*> b = do
        f <- a
        x <- b
        return $ f x
    
instance Functor Parser where
    fmap f x = do 
        a <- x
        return $ f a

instance Alternative Parser where
    pa <|> pb = Parser $
        \inp -> let ra = runParser pa inp
                    rb = runParser pb inp
                in ra ++ rb
    empty = Parser $ const []

getAnyChar :: Parser Char
getAnyChar =
    Parser f
    where f "" = []
          f (x:xs) = [(x, xs)]

getAlpha :: Parser Char
getAlpha = do
    c <- getAnyChar
    if isAlpha c then
        return c
    else
        invalidState

invalidState :: Parser a
invalidState = Parser $ const []

expectChar :: Char -> Parser ()
expectChar c = do
    ch <- getAnyChar
    if ch == c then 
        return ()
    else 
        invalidState

expectString :: String -> Parser ()
expectString s = do
    str <- many getAnyChar
    if s == str then
        return ()
    else
        invalidState


skipSpaces :: Parser ()
skipSpaces = 
    Parser f
    where
        f (' ':xs) = f xs
        f ('\n':xs) = f xs
        f s = [((), s)]

parseDigit :: Parser Int
parseDigit = do
    ch <- getAnyChar
    if isDigit ch then
        return $ ord ch - ord '0'
    else
        invalidState

parsePozitive :: Parser Int
parsePozitive = do
    digits <- many parseDigit
    return $ foldl (\nr d -> 10 * nr + d) 0 digits

parseInt :: Parser Int
parseInt = parsePozitive 
    <|> (expectChar '-' *> ((* (-1)) <$> parsePozitive))
    <|> (expectChar '+' *> parsePozitive)

parseInts :: Parser [Int]
parseInts = skipSpaces *> many (parseInt <* expectChar ' ' <* skipSpaces)

parseName :: Parser String
parseName = skipSpaces *> many getAlpha <* skipSpaces

parse :: String -> Parser a -> Maybe a
parse input parser = 
    let results = runParser parser input
        valid_res = filter (\(ret, str) -> str == "") results
    in
    case valid_res of
        [] -> Nothing
        ((x, _):xs) -> Just x
     

type Name = String

data Condition
    = Name :>: Int
    | Name :=: Name
    deriving Show

data Op
    = If Condition Op Op
    | Name ::= Int
    | Increment Name
    | Chain [Op]
    deriving Show

prg1 = "\
    \if (   abc > 23     )     {\n\
    \    a   ++   ;    \n\
    \    a := 123;\n\
    \}   else    {\n\
    \    w   :=   124   ;\n\
    \}   ;\n\
    \abc :=   123;   \n\
    \var   ++  ;  "

parseInBrackets :: Parser Op
parseInBrackets = skipSpaces *> expectChar '{' *> skipSpaces *> parseChainOfStm <* skipSpaces <* expectChar '}' <* skipSpaces


parseOp :: Parser Op
parseOp =
    (do
        skipSpaces >> expectString "if" >> skipSpaces
        expectChar '('
        cond <- parseCondition
        skipSpaces >> expectChar ')' >> skipSpaces
        c1 <- parseInBrackets
        expectString "else"
        c2 <- parseInBrackets
        return $ If cond c1 c2
    ) <|> (do
        name <- parseName
        skipSpaces >> expectString ":=" >> skipSpaces
        val <- parseInt <* skipSpaces
        return $ name ::= val
    ) <|> (do
        name <- parseName
        skipSpaces >> expectString "++" >> skipSpaces
        return $ Increment name
    )

spaceFree :: Parser a -> Parser a
spaceFree m = skipSpaces *> m <* skipSpaces

parseChainOfStm :: Parser Op
parseChainOfStm = Chain <$> many (parseOp <* skipSpaces <* expectChar ';' <* skipSpaces)

parseCondition :: Parser Condition
parseCondition =
    (do
        name <- parseName
        expectChar '>'
        val <- skipSpaces *> parseInt <* skipSpaces
        return $ name :>: val
    ) <|> (do
        name1 <- parseName
        expectChar '='
        name2 <- parseName
        return $ name1 :=: name2
    )



str_input = " +3 1  +321321  -22   -4555  42 "

result = parse str_input parseInts
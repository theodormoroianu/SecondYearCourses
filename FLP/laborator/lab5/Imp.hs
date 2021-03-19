module Imp where

-- Import stuff.
import qualified Text.Parsec.Token as Token
import Text.Parsec.String ( Parser, parseFromFile )
import Text.Parsec.Expr
    ( buildExpressionParser, Assoc(..), Operator(..) )
import Text.ParserCombinators.Parsec.Language
    ( emptyDef, GenLanguageDef( .. ), LanguageDef)
import Text.Parsec ( alphaNum, letter, (<|>), eof )
import Control.Monad

--Defining AST.
type Name = String

data BinAop = Add | Mul | Sub | Div | Mod
  deriving (Show)

data BinCop = Lt | Lte | Gt | Gte
  deriving (Show)

data BinEop = Eq | Neq
  deriving (Show)

data BinLop = And | Or
  deriving (Show)

data Exp
    = Id Name
    | I Integer
    | B Bool
    | UMin Exp
    | BinA BinAop Exp Exp
    | BinC BinCop Exp Exp
    | BinE BinEop Exp Exp
    | BinL BinLop Exp Exp
    | Not Exp
  deriving (Show)

data Type = TInt | TBool
  deriving (Eq, Show)

data Stmt
    = Asgn Name Exp
    | If Exp Stmt Stmt
    | Read String Name
    | Print String Exp
    | While Exp Stmt
    | Block [Stmt]
    | Decl Type Name
  deriving (Show)

-- Creating parser.
impLanguageDef :: LanguageDef ()
impLanguageDef =
    emptyDef
    { commentStart = "/*"
    , commentEnd = "*/"
    , commentLine = "//"
    , nestedComments = False
    , caseSensitive = True
    , identStart = letter
    , identLetter = alphaNum
    , reservedNames =
        [ "while", "if", "else", "int", "bool"
        , "true", "false", "read", "print"
        ]
    , reservedOpNames =
        [ "+", "-", "*", "/", "%"
        , "==", "!=", "<", "<=", ">=", ">"
        , "&&", "||", "!", "="
        ]
    }

-- Root parser utilities.
impLexer :: Token.TokenParser ()
impLexer = Token.makeTokenParser impLanguageDef
identifier :: Parser String
identifier = Token.identifier impLexer
reserved :: String -> Parser ()
reserved = Token.reserved impLexer
reservedOp :: String -> Parser ()
reservedOp = Token.reservedOp impLexer
parens :: Parser a -> Parser a
parens = Token.parens impLexer
braces :: Parser a -> Parser a
braces = Token.braces impLexer
semiSep :: Parser a -> Parser [a]
semiSep = Token.semiSep impLexer
integer :: Parser Integer
integer = Token.integer impLexer
whiteSpace :: Parser ()
whiteSpace = Token.whiteSpace impLexer
stringParser :: Parser String
stringParser = Token.stringLiteral impLexer
commaParser :: Parser String
commaParser = Token.comma impLexer
bracesParser :: Parser a -> Parser a
bracesParser = Token.braces impLexer
semiParser :: Parser String
semiParser = Token.semi impLexer

-- Expression parser able to parse expressions.
expression :: Parser Exp
expression = buildExpressionParser operators term
    where
        operators =
            [ [ prefix "!" Not
              , prefix "-" UMin
              ]
            , [ binary "*" (BinA Mul) AssocLeft
              , binary "/" (BinA Div) AssocLeft
              , binary "%" (BinA Mod) AssocLeft
              ]
            , [ binary "+" (BinA Add) AssocLeft
              , binary "-" (BinA Sub) AssocLeft
              ]
            , [ binary "==" (BinE Eq) AssocNone
              , binary "<=" (BinC Lte) AssocNone
              , binary "<" (BinC Lt) AssocNone
              , binary ">=" (BinC Gte) AssocNone
              , binary ">" (BinC Gt) AssocNone
              ]
            , [ binary "&&" (BinL And) AssocLeft
              , binary "||" (BinL Or) AssocLeft
              ]
            ]
        binary name fun = Infix ( reservedOp name >> return fun)
        prefix name fun = Prefix ( reservedOp name >> return fun)

-- Expression term. Used for nested parans.
term :: Parser Exp
term =
    parens expression
    <|> I <$> integer
    <|> Id <$> identifier
    <|> boolExp

-- Boolean expression parser ("true" / "false").
-- Parsec doesn't have a predefined boolean parser.
boolExp :: Parser Exp
boolExp =
    (do
        reserved "true"
        return $ B True)
    <|>
    (do
        reserved "false"
        return $ B False)

-- Reads a bunch of lines, separated by ';'.
readLines :: Parser [Stmt]
readLines = do
    a <- statement
    (do
        semiParser
        stms <- readLines
        return $ a:stms)
     <|>
        return [a]

-- Reads lines, and closes them in a Block.
readBlock :: Parser Stmt
readBlock =
    (Block <$> bracesParser readLines) <|> bracesParser (return (Block [])) <|> statement

-- Parses a statement.
statement :: Parser Stmt
statement = ifStmt
        <|> asgnStmt
        <|> readStmt
        <|> printStmt
        <|> whileStmt
        <|> declStmt

-- Parses assignments.
asgnStmt :: Parser Stmt
asgnStmt = do
    varname <- identifier
    reservedOp "="
    Asgn varname <$> expression

-- Parses "Read(...)" commands.
readStmt :: Parser Stmt
readStmt = do
    reserved "read"

    let readParameters :: Parser (String, Name)
        readParameters = do
            str <- stringParser
            _ <- commaParser
            name <- identifier
            return (str, name)

    (str, name) <- parens readParameters

    return $ Read str name

-- Parses "Print(...)" commands.
printStmt :: Parser Stmt
printStmt = do
    reserved "print"

    let readParameters :: Parser (String, Exp)
        readParameters = do
            str <- stringParser
            _ <- commaParser
            expr <- expression
            return (str, expr)

    (str, expr) <- parens readParameters
    return $ Print str expr

-- Parses a type ("int" / "bool").
typeParser :: Parser Type
typeParser =
    (reserved "int" >> return TInt) <|> (reserved "bool" >> return TBool)

-- Parses a declaration ("int a;").
declStmt :: Parser Stmt
declStmt = do
    t <- typeParser
    Decl t <$> identifier

-- Parses an if/else statement ("if (...) { ... } else { ... }").
ifStmt :: Parser Stmt
ifStmt = do
    reserved "if"
    cond <- parens expression
    thenS <- readBlock
    reserved "else"
    If cond thenS <$> readBlock

-- Parses a While statement ("While (...) { ... }").
whileStmt :: Parser Stmt
whileStmt = do
    reserved "while"
    condition <- parens expression
    While condition <$> readBlock

-- Parses the "1.imp" file.
-- Or at least, it's supposed to :(
main :: IO ()
main = do
    result <- parseFromFile (readLines <* eof) "1.imp"
    case result of
        Left err  -> print err
        Right xs  -> print xs


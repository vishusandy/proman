import Control.Monad (unless) -- some very helpful functions in here, we'll use 'unless)
import Data.Word (Word8)      -- Assuming colors are 0-255, Word8 is a better type than Int
import Numeric (showHex)
import Text.Read (readEither)
import System.IO

-- Typically, you'll want to use a data type vs using just tuples.
-- When you name the fields of a type, it's called a record and it
-- gets automattic "getters".
data Color =
  Color { redVal   :: Word8
  , greenVal :: Word8
  , blueVal  :: Word8
  }

-- I'm doing this without whatever library splitOn comes from :)
splitOn :: Eq a => a -> [a] -> [[a]]
splitOn delim []   = []
splitOn delim list = before : splitOn delim (drop 1 after)
  where (before, after) = span (/= delim) list
    
{- 'read' and '!!!' can cause some really hard-to-debug exceptions in Haskell
   called "pure exceptions". They're a big wart from the early 90s when
   Haskell was first developed and are largely considered bad now.

   Instead, use pattern matching and 'readEither'. -}
type ParseError = String

parseColor :: String -> Either ParseError Color
parseColor colorString = do
  -- split the input string on commas and ensure only three elements are
  -- returned
  (rStr, gStr, bStr) <-
    case splitOn ',' colorString of
      [r, g, b] -> return (r, b, g)
      err       -> error (show err)
--Left "Error: expected a three-segment color string"

  -- read each color into an integer
  r <- readEither rStr
  g <- readEither gStr
  b <- readEither bStr
 
  -- done!
  return Color{ redVal   = r
              , greenVal = g
              , blueVal  = b
              }

-- You can also break out the logic for showing the hex values, too
colorHex :: Color -> String
colorHex color = do
  colorPart <- [redVal color, blueVal color, greenVal color]
  wordHex colorPart

wordHex :: Word8 -> String
wordHex n
  | n >= 16   = asHex
  | otherwise = '0' : asHex
  where asHex = showHex (fromIntegral n) ""


inputLoop p = do
  putStr "Color name: \t"
  colorName <- getLine
  if colorName == ""
    then do
      footer <- readFile "colorfooter.html"    
      appendFile (p ++ ".pal.html") footer
    else do
      putStr "Color r,g,b: \t"
      colorStr <- getLine
      case parseColor colorStr of
        Left  err   -> putStrLn err
        Right color -> do
          let colorSplit = splitOn ',' colorStr
          let curHexColor = "#" ++ (colorHex color)
          putStrLn ("Hex color: " ++ curHexColor)
          appendFile (p ++ ".pal.json") ("{\r\n\t\"colorname\": \"" ++ colorName ++ "\",\r\n\t\"colorvalues\": [\r\n\t\t{\r\n\t\t\t\"red\": " ++ colorSplit!!0 ++ "\r\n\t\t\t\"green\": " ++ colorSplit!!1 ++ "\r\n\t\t\t\"blue\": " ++ colorSplit!!2 ++ "\r\n\t\t}\r\n\t],\r\n\t\"hexcolor\": \"" ++ curHexColor ++ "\"\r\n},\r\n")
          appendFile (p ++ ".pal.csv") (colorName ++ "," ++ colorSplit!!0 ++ "," ++ colorSplit!!1 ++ "," ++ colorSplit!!2 ++ "," ++ curHexColor ++ "\r\n")
          let html = "        <div class=\"container\">\n\
          \            <div class=\"colorbox\">&nbsp;</div>\n\
          \            <div class=\"colortitle\">" ++ colorName ++ "</div>\n\
          \            <div class=\"colors\">" ++ colorStr ++ "</div>\n\
          \            <div class=\"colorhex\">" ++ curHexColor ++ "</div>\n\
          \        </div>\n"
          appendFile (p ++ ".pal.html") html
          inputLoop p


main :: IO ()
main = do
  putStrLn "Running this will overwrite any saved files from previous runs that have the same palette name."
  putStr "Enter palette name: "
  palette <- getLine
  header <- readFile "colorheader.html"
  writeFile (palette ++ ".pal.csv") ""
  writeFile (palette ++ ".pal.json") ""
  writeFile (palette ++ ".pal.html") (header)
  putStrLn "Enter a blank line to exit"
  inputLoop palette
  


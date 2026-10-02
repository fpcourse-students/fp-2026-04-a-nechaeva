module Main where

import System.IO

-- С помощью interact можем пока общаться с внешним миром, пока не изучили IO.
-- https://hackage.haskell.org/package/base-4.18.1.0/docs/Prelude.html#v:interact
-- Запустить main можно с помощью `cabal run homework-exe`.
main :: IO ()
main = interact' "> " 1 handler

handler :: String -> Int -> (String, Int)
handler input state
  | input == "mickey" = (mickey, state)
  | otherwise = (show state ++ ". Hello " ++ input ++ "!", state + 1)

-- interact с поддержкой состояния программы.
-- Вчитываться в реализацию не нужно, достаточно видеть тип.
interact'
  :: String -- ^ Приглашение ко вводу.
  -> a      -- ^ Начальное состояние программы
  -> (String -> a -> (String, a))
  -- ^ Функция из ввода пользователя и предыдущего состояния в вывод и новое состояние.
  -> IO ()
interact' prompt st f = do
  putStr prompt >> flush
  input <- getLine
  if null input then
    pure ()
  else do
    let (output, st') = f input st
    putStrLn output >> flush
    interact' prompt st' f
  where
    flush = hFlush stdout

-- В строковых литералах обратная косая черта и кавычка экранируются: \\ и \".
-- Многострочные литералы (расширение MultilineStrings) появились в GHC 9.12,
-- а домашки собираются на 9.10.3, поэтому картинка набрана списком строк.
mickey :: String
mickey = unlines
  [ "            .-\"\"\"-."
  , "           /       \\"
  , "           \\       /"
  , "    .-\"\"\"-.-`.-.-.<  _"
  , "   /      _,-\\ ()()_/:)"
  , "   \\     / ,  `     `|"
  , "    '-..-| \\-.,___,  /"
  , "          \\ `-.__/  /"
  , "     jgs / `-.__.-\\`"
  , "        / /|    ___\\"
  , "       ( ( |.-\"`   `'\\"
  , "        \\ \\/    {}{}  |"
  , "         \\|           /"
  , "          \\        , /"
  , "          ( __`;-;'__`)"
  , "          `//'`   `||`"
  , "         _//       ||"
  , " .-\"-._,(__)     .(__).-\"\"-."
  , "/          \\    /           \\"
  , "\\          /    \\           /"
  , " `'-------`      `--------'`"
  ]

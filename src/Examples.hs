{-# OPTIONS_GHC -Wno-unused-matches #-}
{- HLINT ignore "Redundant lambda" -}
{- HLINT ignore "Use id" -}
{- HLINT ignore "Use const" -}
{- HLINT ignore "Eta reduce" -}

-- | Примеры с пары и команды для знакомства с интерпретатором. Задач здесь нет.
module Examples where

{- Поиграйте с интерпретатором (`make repl`).
* 5 + 3
* 5 + (-3)
* (+) 5 (-3)
* (/) 5.0 (-3.0)
* (5.0 /) (-3.0)
* (/ 5.0) (-3.0)
* :t (==)
* 'c' == True
* "str" == True
* :t succ
* succ 'c'
* succ 15
* :type id
* :t id
* :info id
* :i id
* :i (+)
* :i Num
* :t \x -> x + x
* :doc id
* (\x -> x + x) 3
* Последовательно 3, it, it + it, it + it
* :t (5, True)
* :t fst
* :t () :: ()
* :t (,)
* :t (x, y) :: (a, b)
* :t (,) :: a -> b -> (,) a b
* fst (5, True)
* snd (5, True)
* if 3 == 3 then 15 else 14
* if 3 == 3 then 15 else True
* let x = 15 in x + x
* :t error
* if True then 4 + error "fail miserably" else 5
* Сначала import Data.Function, затем
  Data.Function.fix error
* fix (\f n -> if n <= 0 then 0 else succ (f (n - 1))) 100
* Создайте файл `H.hs' в этой же директории и поместите в него строку
  val = 3
  Затем из интерпретатора:
    :load H
    val
    it
  Не закрывая интерпретатор, измените значение val. В интерпретаторе
  сделайте
    :reload или :r
    val

Изучите базовые библиотечные функции и некоторые их комбинации (обычно
достаточно узнать тип) и найдите по возможности их аналоги в лямбда-исчислении:

* id
* const
* flip
* flip const
* (.)
* curry
* swap
* uncurry
* uncurry const
* uncurry (flip const)
-}

example1 :: a -> a
example1 = \x -> x

example2 :: a -> a -> a
example2 = \x y -> y

example3 :: a -> a -> a -> a
example3 = \x y z -> z

example4 :: a
example4 = undefined

example5 :: a -> b -> a
example5 = \x _ -> x

example6 :: a -> b -> (a -> b -> c) -> c
example6 x y f = f x y

example7 :: (a -> a) -> a -> a
example7 s z = s (s z)

example8 :: (a -> b -> b) -> b -> b
example8 = undefined

example9 :: ((a -> b) -> a) -> (a -> a -> b) -> b
example9 f g = let tmp = f $ \x -> g x x in g tmp tmp
  -- let - связывания
  -- Написание лямбд через доллар
  -- Без доллара у нас тоже можно, но для этого подключено специальное расширение

example10 :: ((((a -> b) -> a) -> a) -> b) -> b
example10 abaab = abaab $ \aba -> aba $ \a -> abaab (const a)

fac :: Integer -> Integer
fac n
  | n <= 1 = 1
  | otherwise = n * fac (n - 1)

-- Редукция с пары: умножения ждут, пока вернётся рекурсивный вызов, и копятся.
-- fac 4 ⇝ 4 * fac 3 ⇝ 4 * (3 * fac 2) ⇝ 4 * (3 * (2 * fac 1)) ⇝ 4 * (3 * (2 * 1)) ⇝ 24

fac' :: Integer -> Integer
fac' n = go 1 n
  where
    go acc n'
      | n' <= 1 = acc
      | otherwise = go (acc * n') (n' - 1)

-- С аккумулятором ждать нечего: рекурсивный вызов стоит последним действием.
-- fac' 4 ⇝ go 1 4 ⇝ go 4 3 ⇝ go 12 2 ⇝ go 24 1 ⇝ 24

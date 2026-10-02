{-# OPTIONS_GHC -Wno-missing-signatures #-}
-- Выражения записаны ровно так, как в условиях задач.
{- HLINT ignore -}

-- | Эталоны задач «предскажите тип» (1.6 и 2.6): выражения из условий без сигнатур.
-- Их типы выводит GHC, тесты сравнивают с ними запись типа, которую дал студент.
-- Отдельный модуль нужен Template Haskell: reify видит только уже скомпилированные имена.
module Predictions where

uncurryConst = uncurry const
curryFst = curry fst
flipPair = flip (,)

uncurryFlipConst = uncurry (flip const)
curryId = curry id
flipCompose = flip (.)

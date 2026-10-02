module SpecLevel2 where

import Data.Either (lefts)
import Data.Set qualified as Set
import Level2
import Predictions qualified
import Test.Prelude
import TypeCheck

tests :: NamedTests
tests = nameTests 2
  [ testVariant
  , testPred
  , testIsPrime
  , testSet
  , testFirst
  , testPredictions
  ]

testVariant :: Test
testVariant = TestList
  [ propertyToTest "variant inl law satisfied"
      \(x :: Char, Fun _ f :: Fun Char Int, Fun _ g :: Fun Int Int) ->
        eitherChurch f g (inl x) === f x
  , propertyToTest "variant inr law satisfied"
      \(x :: Int, Fun _ f :: Fun Char Int, Fun _ g :: Fun Int Int) ->
        eitherChurch f g (inr x) === g x
  ]

testPred :: Test
testPred = TestList
  [ propertyToTest "pred 0 law satisfied"
      \(Fun _ f :: Fun Int Int, ini :: Int) ->
        predChurch zero f ini === ini
  , propertyToTest "pred suc law satisfied"
      \(Positive n :: Positive Int, Fun _ f, ini :: Int) ->
        predChurch (toChurch n) f ini === toChurch (n - 1) f ini
  ]
  where
    zero _ z = z
    toChurch n s z
      | n == 0 = z
      | otherwise = s (toChurch (n - 1) s z)

testIsPrime :: Test
testIsPrime = TestList
  [ propertyToTest "isPrime works" \(NonNegative n) -> isPrime n === isPrimeRef n
  , TestCase $ assertEqual "primes below 60"
      [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59] $ filter isPrime [0 .. 60]
  ]
  where
    isPrimeRef :: Integer -> Bool
    isPrimeRef n = n > 1 && all (\k -> n `rem` k /= 0) (takeWhile (\k -> k * k <= n) [2 ..])

testSet :: Test
testSet = TestList
  [ propertyToTest "emptySet is empty" \(s :: String) -> not (emptySet s)
  , propertyToTest "adding adds" \(ss :: [String], new :: String) ->
      (setOf ss +++ new) new
  , propertyToTest "removing removes" \(ss :: [String], old :: String) ->
      not $ (setOf ss /// old) old
  , propertyToTest "non empty set contains its elements" \(NonEmpty ss) ->
      let set = setOf ss in
      forAll (oneof [elements ss, arbitrary]) \s ->
        elem s ss === set s
  , propertyToTest "remove works correctly" \(NonEmpty ini, actions :: [Either String String]) ->
      let expected = foldr (either Set.delete Set.insert) (Set.fromList ini) actions in
      let actual = foldr (either (flip (///)) (flip (+++))) (setOf ini) actions in
      let existing = elements $ "" : Set.toList expected in
      let removed = elements $ "" : lefts actions in
      forAll (oneof [existing, removed, arbitrary]) \s ->
        Set.member s expected === actual s
  , TestCase $ assertEqual "operators are left associative with the same precedence"
      [True, False, True] $ map (emptySet +++ "a" +++ "b" /// "b" +++ "c") ["a", "b", "c"]
  ]
  where
    setOf :: [String] -> (String -> Bool)
    setOf = foldl (+++) emptySet

testFirst :: Test
testFirst = TestList
  [ propertyToTest "first applies the function to the first component"
      \(Fun _ f :: Fun Int Char, x :: Int, y :: Bool) -> first f (x, y) === (f x, y)
  , TestCase $ assertEqual "first changes the type" ("1", 'c') $ first show (1 :: Int, 'c')
  ]

-- | См. задачу 1.6 в "SpecLevel1".
testPredictions :: Test
testPredictions = TestList
  [ assertShape "2.6 uncurry (flip const)" $(shapeOfType 'Predictions.uncurryFlipConst) $(shapeOfType 'typeOfUncurryFlipConst)
  , assertShape "2.6 curry id" $(shapeOfType 'Predictions.curryId) $(shapeOfType 'typeOfCurryId)
  , assertShape "2.6 flip (.)" $(shapeOfType 'Predictions.flipCompose) $(shapeOfType 'typeOfFlipCompose)
  ]

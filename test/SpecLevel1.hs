module SpecLevel1 where

import Data.Char (digitToInt)
import Data.List (genericLength)
import Level1 hiding (counterexample)
import Level1 qualified
import Predictions qualified
import Test.Prelude
import TypeCheck

tests :: NamedTests
tests = nameTests 1
  [ testPair
  , testEvenOdd
  , testCounterexample
  , testItemAt
  , testNSumDigits
  , testPredictions
  ]

testPair :: Test
testPair = TestList
  [ propertyToTest "fst law satisfied" \(x :: Char, y :: Int) -> fstChurch (pair x y) === x
  , propertyToTest "snd law satisfied" \(x :: Int, y :: Char) -> sndChurch (pair x y) === y
  ]

testEvenOdd :: Test
testEvenOdd = TestList
  [ propertyToTest "isEven works" \(Small n) -> isEven n === even n
  , propertyToTest "isOdd works" \(Small n) -> isOdd n === odd n
  ]

-- | Сообщения не называют ответ: только то, подходит ли аргумент.
-- Имя квалифицировано: у QuickCheck есть своя функция counterexample.
testCounterexample :: Test
testCounterexample = TestList
  [ TestCase $ assertBool "counterexample должен быть от 0 до 1000" inRange
  , TestCase $ assertBool "на этом аргументе facBuggy отвечает верно, ищите другой" $
      not inRange || facBuggy x /= product [1 .. x]
  ]
  where
    x = Level1.counterexample
    inRange = 0 <= x && x <= 1000

testItemAt :: Test
testItemAt = TestList $ uncurry mkTest <$> zip [0..] items
  where
    mkTest i x = TestCase $ assertEqual ("b[" ++ show i ++ "]") x (itemAt i)
    items = [1,2,3,2,2,7,9,1,4,29,24,-22,17,133,33,-182,151,614,-234,-1009]

testNSumDigits :: Test
testNSumDigits = TestList
  [ propertyToTest "nSumDigits works well" \n ->
      let ds = map (toInteger . digitToInt) $ show (abs n :: Integer) in
      nSumDigits n === (genericLength ds, sum ds)
  ]

-- | Тип сравнивается с типом, который GHC вывел для выражения из условия (см. "Predictions"
-- и "TypeCheck"): имена переменных не важны, нужен наиболее общий тип.
testPredictions :: Test
testPredictions = TestList
  [ assertShape "1.6 uncurry const" $(shapeOfType 'Predictions.uncurryConst) $(shapeOfType 'typeOfUncurryConst)
  , assertShape "1.6 curry fst" $(shapeOfType 'Predictions.curryFst) $(shapeOfType 'typeOfCurryFst)
  , assertShape "1.6 flip (,)" $(shapeOfType 'Predictions.flipPair) $(shapeOfType 'typeOfFlipPair)
  ]

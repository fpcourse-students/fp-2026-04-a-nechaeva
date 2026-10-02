module SpecLevel3 where

import Level3
import Test.Prelude
import TypeCheck

tests :: NamedTests
tests = nameTests 3
  [ testTypes
  , testDeepFirst
  ]

-- | Типы сравниваются по форме (см. "TypeCheck"): имена переменных не важны,
-- число параметров синонима и порядок аргументов — важны.
testTypes :: Test
testTypes = TestList
  [ assertShape "3.1 Pair" "2 (forall v3 (-> (-> v1 (-> v2 v3)) v3))" $(synonymShape ''Pair)
  , assertShape "3.1 Variant" "2 (forall v3 (-> (-> v1 v3) (-> (-> v2 v3) v3)))" $(synonymShape ''Variant)
  , assertShape "3.1 Nat" "0 (forall v1 (-> (-> v1 v1) (-> v1 v1)))" $(synonymShape ''Nat)
  ]

testDeepFirst :: Test
testDeepFirst = TestList
  [ propertyToTest "deepFirst applies the function to the innermost first component"
      \(Fun _ f :: Fun Int Char, x :: Int, y :: Bool, z :: Char) ->
        deepFirst f ((x, y), z) === ((f x, y), z)
  , TestCase $ assertEqual "deepFirst (+ 1)" ((2 :: Int, 'a'), True) $ deepFirst (+ 1) ((1, 'a'), True)
  ]

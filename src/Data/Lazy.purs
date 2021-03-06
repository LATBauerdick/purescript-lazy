module Data.Lazy where

import Prelude

import Control.Comonad (class Comonad)
import Control.Extend (class Extend)
import Control.Lazy as CL

import Data.HeytingAlgebra (implies, ff, tt)
import Data.Monoid (class Monoid, mempty)

-- | `Lazy a` represents lazily-computed values of type `a`.
-- |
-- | A lazy value is computed at most once - the result is saved
-- | after the first computation, and subsequent attempts to read
-- | the value simply return the saved value.
-- |
-- | `Lazy` values can be created with `defer`, or by using the provided
-- | type class instances.
-- |
-- | `Lazy` values can be evaluated by using the `force` function.
foreign import data Lazy :: Type -> Type

-- | Defer a computation, creating a `Lazy` value.
foreign import defer :: forall a. (Unit -> a) -> Lazy a

-- | Force evaluation of a `Lazy` value.
foreign import force :: forall a. Lazy a -> a

instance semiringLazy :: (Semiring a) => Semiring (Lazy a) where
  add a b = defer \_ -> force a + force b
  zero = defer \_ -> zero
  mul a b = defer \_ -> force a * force b
  one = defer \_ -> one

instance ringLazy :: (Ring a) => Ring (Lazy a) where
  sub a b = defer \_ -> force a - force b

instance commutativeRingLazy :: (CommutativeRing a) => CommutativeRing (Lazy a)

instance euclideanRingLazy :: (EuclideanRing a) => EuclideanRing (Lazy a) where
  degree = degree <<< force
  div a b = defer \_ -> force a / force b
  mod a b = defer \_ -> force a `mod` force b

instance fieldLazy :: (Field a) => Field (Lazy a)

instance eqLazy :: (Eq a) => Eq (Lazy a) where
  eq x y = (force x) == (force y)

instance ordLazy :: (Ord a) => Ord (Lazy a) where
  compare x y = compare (force x) (force y)

instance boundedLazy :: (Bounded a) => Bounded (Lazy a) where
  top = defer \_ -> top
  bottom = defer \_ -> bottom

instance semigroupLazy :: (Semigroup a) => Semigroup (Lazy a) where
  append a b = defer \_ -> force a <> force b

instance monoidLazy :: (Monoid a) => Monoid (Lazy a) where
  mempty = defer \_ -> mempty

instance heytingAlgebraLazy :: (HeytingAlgebra a) => HeytingAlgebra (Lazy a) where
  ff = defer \_ -> ff
  tt = defer \_ -> tt
  implies a b = implies <$> a <*> b
  conj a b = conj <$> a <*> b
  disj a b = disj <$> a <*> b
  not a = not <$> a

instance booleanAlgebraLazy :: (BooleanAlgebra a) => BooleanAlgebra (Lazy a)

instance functorLazy :: Functor Lazy where
  map f l = defer \_ -> f (force l)

instance applyLazy :: Apply Lazy where
  apply f x = defer \_ -> force f (force x)

instance applicativeLazy :: Applicative Lazy where
  pure a = defer \_ -> a

instance bindLazy :: Bind Lazy where
  bind l f = defer \_ -> force $ f (force l)

instance monadLazy :: Monad Lazy

instance extendLazy :: Extend Lazy where
  extend f x = defer \_ -> f x

instance comonadLazy :: Comonad Lazy where
  extract = force

instance showLazy :: (Show a) => Show (Lazy a) where
  show x = "(defer \\_ -> " <> show (force x) <> ")"

instance lazyLazy :: CL.Lazy (Lazy a) where
  defer f = defer \_ -> force (f unit)

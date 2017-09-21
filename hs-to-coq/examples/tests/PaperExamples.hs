module PaperExamples where

-- Inline data structures, so that this test case
-- works independent of inter-module data flow
data List a = Nil | Cons a (List a)

uncurry :: (a -> b -> c) -> (a,b) -> c
uncurry f (x,y) = f x y

takeMapMaybe :: (a -> Maybe b) -> Int -> List a -> List b
takeMapMaybe f n xs | n <= 0 =  Nil
takeMapMaybe f n (Cons x xs)
  | Just y <- f x = Cons y ys
  where ys = takeMapMaybe f (n-1) xs
takeMapMaybe _ _ Nil = Nil

class Pointed a where point :: a

class Pointed a => PointedMagma a where
    op :: a -> a -> a
    op _ _ = point

instance Pointed Bool where point = True
instance Pointed () where point = ()

instance PointedMagma Bool where op = (&&)
instance PointedMagma ()

module Opacity exposing
    ( Opacity
    , transparent, opaque, custom
    , toString, toFloat
    )

{-|

@docs Opacity

@docs transparent, opaque, custom

@docs toString, toFloat

-}


{-| -}
type Opacity
    = Opacity Float


{-| -}
transparent : Opacity
transparent =
    Opacity 0


{-| -}
opaque : Opacity
opaque =
    Opacity 1.0


{-| Pass in a value in [0, 1.0]. The value passed in will be clamped within these bounds.
-}
custom : Float -> Opacity
custom =
    Opacity << clamp 0 1.0


{-| -}
toFloat : Opacity -> Float
toFloat (Opacity v) =
    v


{-| -}
toString : Opacity -> String
toString =
    String.fromFloat << toFloat

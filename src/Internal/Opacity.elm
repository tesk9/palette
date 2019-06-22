module Internal.Opacity exposing
    ( Opacity
    , transparent, opaque, custom
    , map
    , toString, toFloat
    )

{-|

@docs Opacity

@docs transparent, opaque, custom

@docs map

@docs toString, toFloat

-}


{-| -}
type Opacity
    = Opacity Float


{-| Provided for convenience. Equivalent to doing:

    Opacity.custom 0

-}
transparent : Opacity
transparent =
    custom 0


{-| Provided for convenience. Equivalent to doing:

    Opacity.custom 1.0

-}
opaque : Opacity
opaque =
    custom 1.0


{-| Pass in a value in [0, 1.0]. The value passed in will be clamped within these bounds.
-}
custom : Float -> Opacity
custom =
    Opacity << clamp 0 1.0


{-| Note: results from the function you pass in will be clamped in [0, 1.0].
-}
map : (Float -> Float) -> Opacity -> Opacity
map f =
    toFloat >> f >> custom


{-| -}
toFloat : Opacity -> Float
toFloat (Opacity v) =
    v


{-| -}
toString : Opacity -> String
toString =
    String.fromFloat << toFloat

module Color exposing (Color, fromRGB, toRGB)


type
    Color
    -- TODO: HSL color modeling! other models! conversions! as necessary.
    = RGB Float Float Float


{-| Build a new color based on RGB values. Clamps arguments between 0 and 255, inclusive.
-}
fromRGB : ( Float, Float, Float ) -> Color
fromRGB ( r, g, b ) =
    RGB (clamp 0 255 r) (clamp 0 255 g) (clamp 0 255 b)


{-| Extract the red, green, blue values from an existing Color.
-}
toRGB : Color -> ( Float, Float, Float )
toRGB color =
    case color of
        RGB r g b ->
            ( r, g, b )

module Color exposing (Color, fromRGB, luminance, toRGB)


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


{-| Luminance calculation adopted from <https://www.w3.org/TR/WCAG20-TECHS/G17.html>
-}
luminance : Color -> Float
luminance color =
    let
        ( rRaw, gRaw, bRaw ) =
            toRGB color

        fromRGBValue raw =
            if (raw / 255) <= 0.03928 then
                (raw / 255) / 12.92

            else
                (((raw / 255) + 0.055) / 1.055) ^ 2.4
    in
    0.2126 * fromRGBValue rRaw + 0.7152 * fromRGBValue gRaw + 0.0722 * fromRGBValue bRaw

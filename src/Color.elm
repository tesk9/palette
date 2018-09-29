module Color exposing
    ( Color
    , fromRGB, toRGB, toRGBString
    , luminance
    )

{-|

@docs Color

@docs fromRGB, toRGB, toRGBString
@docs luminance

-}


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


{-| Get the RGB representation of a color as a `String`.
-}
toRGBString : Color -> String
toRGBString color =
    let
        ( r, g, b ) =
            toRGB color
    in
    "rgb(" ++ String.fromFloat r ++ "," ++ String.fromFloat g ++ "," ++ String.fromFloat b ++ ")"


{-| Luminance calculation adopted from <https://www.w3.org/TR/WCAG20-TECHS/G17.html>
-}
luminance : Color -> Float
luminance color =
    let
        ( rRaw, gRaw, bRaw ) =
            toRGB color

        red =
            rRaw
                |> toSRBG
                |> fromSRGB

        green =
            gRaw
                |> toSRBG
                |> fromSRGB

        blue =
            bRaw
                |> toSRBG
                |> fromSRGB

        toSRBG rgb8bit =
            rgb8bit / 255

        fromSRGB srgb =
            if srgb <= 0.03928 then
                srgb / 12.92

            else
                ((srgb + 0.055) / 1.055) ^ 2.4
    in
    (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)

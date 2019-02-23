module Internal.Color exposing
    ( Color
    , fromHSL, toHSL
    , fromRGB, toRGB
    )

{-|

@docs Color
@docs fromHSL, toHSL
@docs fromRGB, toRGB

-}

import Dict


type Color
    = HSL HSLValue
    | RGB RGBValue


type HSLValue
    = HSLValue Float Float Float


type RGBValue
    = RGBValue Float Float Float


fromHSL : ( Float, Float, Float ) -> Color
fromHSL ( hue, s, l ) =
    let
        hueInt =
            floor hue

        floatingHueValues =
            hue - toFloat hueInt

        hue360 =
            toFloat (modBy 360 hueInt)
    in
    HSL (HSLValue (hue360 + floatingHueValues) (clamp 0 100 s) (clamp 0 100 l))


toHSL : Color -> ( Float, Float, Float )
toHSL color =
    case color of
        HSL (HSLValue h s l) ->
            ( h, s, l )

        RGB rgbValues ->
            convertRGBToHSL rgbValues
                |> toHSL


fromRGB : ( Float, Float, Float ) -> Color
fromRGB ( r, g, b ) =
    RGB (RGBValue (clamp 0 255 r) (clamp 0 255 g) (clamp 0 255 b))


toRGB : Color -> ( Float, Float, Float )
toRGB color =
    case color of
        RGB (RGBValue r g b) ->
            ( r, g, b )

        HSL hslValues ->
            convertHSLToRGB hslValues
                |> toRGB



-- CONVERSIONS


{-| -}
convertRGBToHSL : RGBValue -> Color
convertRGBToHSL (RGBValue r255 g255 b255) =
    let
        ( r, g, b ) =
            ( r255 / 255, g255 / 255, b255 / 255 )

        maximum =
            max (max r g) b

        minimum =
            min (min r g) b

        chroma =
            maximum - minimum

        hue =
            if chroma == 0 then
                --Actually undefined, but this is a typical representation
                0

            else if maximum == r then
                60 * (g - b) / chroma

            else if maximum == g then
                60 * ((b - r) / chroma + 2)

            else
                60 * ((r - g) / chroma + 4)

        lightness =
            (minimum + maximum) / 2

        saturation =
            if lightness == 1 || lightness == 0 then
                0

            else
                chroma / (1 - abs (2 * lightness - 1))
    in
    fromHSL
        ( hue
        , saturation * 100
        , lightness * 100
        )


convertHSLToRGB : HSLValue -> Color
convertHSLToRGB (HSLValue hue360 saturationPercent lightnessPercent) =
    let
        saturation =
            saturationPercent / 100

        lightness =
            lightnessPercent / 100

        chroma =
            (1 - abs (2 * lightness - 1)) * saturation

        hueIsBetween lowerBound upperBound =
            lowerBound <= hue360 && hue360 <= upperBound

        zigUp xIntercept =
            chroma * (hue360 - xIntercept) / 60

        zigDown xIntercept =
            -1 * zigUp xIntercept

        ( r, g, b ) =
            if hueIsBetween 0 60 then
                ( chroma, zigUp 0, 0 )

            else if hueIsBetween 60 120 then
                ( zigDown 120, chroma, 0 )

            else if hueIsBetween 120 180 then
                ( 0, chroma, zigUp 120 )

            else if hueIsBetween 180 240 then
                ( 0, zigDown 240, chroma )

            else if hueIsBetween 240 300 then
                ( zigUp 240, 0, chroma )

            else
                ( chroma, 0, zigDown 360 )

        lightnessModifier =
            lightness - chroma / 2
    in
    fromRGB
        ( (r + lightnessModifier) * 255
        , (g + lightnessModifier) * 255
        , (b + lightnessModifier) * 255
        )

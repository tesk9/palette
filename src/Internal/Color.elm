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
import Internal.RGB as RGB


type Color
    = HSL HSLValue
    | RGB RGB.Color


type alias HSLValue =
    { hue : Float, saturation : Float, lightness : Float }


fromHSL : HSLValue -> Color
fromHSL { hue, saturation, lightness } =
    let
        hueInt =
            floor hue

        floatingHueValues =
            hue - toFloat hueInt

        hue360 =
            toFloat (modBy 360 hueInt)
    in
    HSL
        { hue = hue360 + floatingHueValues
        , saturation = clamp 0 100 saturation
        , lightness = clamp 0 100 lightness
        }


toHSL : Color -> ( Float, Float, Float )
toHSL color =
    case color of
        HSL { hue, saturation, lightness } ->
            ( hue, saturation, lightness )

        RGB rgbValues ->
            convertRGBToHSL rgbValues
                |> toHSL


fromRGB : RGB.Channels -> Color
fromRGB values =
    RGB (RGB.fromChannels values)


toRGB : Color -> RGB.Channels
toRGB color =
    case color of
        RGB values ->
            RGB.toChannels values

        HSL hslValues ->
            toRGB (convertHSLToRGB hslValues)



-- CONVERSIONS


{-| -}
convertRGBToHSL : RGB.Color -> Color
convertRGBToHSL value =
    let
        { red, green, blue } =
            RGB.toChannels value

        ( r, g, b ) =
            ( red / 255, green / 255, blue / 255 )

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
        { hue = hue
        , saturation = saturation * 100
        , lightness = lightness * 100
        }


convertHSLToRGB : HSLValue -> Color
convertHSLToRGB value =
    RGB (RGB.fromHSL value)

module Internal.HSLA exposing
    ( Color
    , Channels
    , fromChannels, toChannels
    , fromRGBA
    , toStringWithoutOpacity, toStringWithOpacity
    )

{-|

@docs Color
@docs Channels
@docs fromChannels, toChannels
@docs fromRGBA
@docs toStringWithoutOpacity, toStringWithOpacity

-}

import Internal.Opacity as Opacity exposing (Opacity)


type Color
    = Color Channels


type alias Channels =
    { hue : Float
    , saturation : Float
    , lightness : Float
    , alpha : Opacity
    }


fromChannels : Channels -> Color
fromChannels { hue, saturation, lightness, alpha } =
    let
        hueInt =
            floor hue

        floatingHueValues =
            hue - toFloat hueInt

        hue360 =
            toFloat (modBy 360 hueInt)
    in
    Color
        { hue = hue360 + floatingHueValues
        , saturation = clamp 0 100 saturation
        , lightness = clamp 0 100 lightness
        , alpha = alpha
        }


toChannels : Color -> Channels
toChannels (Color values) =
    values


toStringWithoutOpacity : Color -> String
toStringWithoutOpacity (Color { hue, saturation, lightness }) =
    "hsl("
        ++ String.fromFloat hue
        ++ ","
        ++ String.fromFloat saturation
        ++ "%,"
        ++ String.fromFloat lightness
        ++ "%)"


toStringWithOpacity : Color -> String
toStringWithOpacity (Color { hue, saturation, lightness, alpha }) =
    "hsla("
        ++ String.fromFloat hue
        ++ ","
        ++ String.fromFloat saturation
        ++ "%,"
        ++ String.fromFloat lightness
        ++ "%,"
        ++ Opacity.toString alpha
        ++ ")"


fromRGBA : { red : Float, green : Float, blue : Float, alpha : Opacity } -> Color
fromRGBA { red, green, blue, alpha } =
    let
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
    fromChannels
        { hue = hue
        , saturation = saturation * 100
        , lightness = lightness * 100
        , alpha = alpha
        }

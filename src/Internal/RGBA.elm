module Internal.RGBA exposing
    ( Color
    , Channels
    , fromChannels, toChannels
    , fromHSLA
    , toStringWithoutOpacity, toStringWithOpacity
    , getOpacity, setOpacity
    )

{-|

@docs Color
@docs Channels
@docs fromChannels, toChannels
@docs fromHSLA
@docs toStringWithoutOpacity, toStringWithOpacity
@docs getOpacity, setOpacity

-}

import Opacity exposing (Opacity)


type Color
    = Color Channels


type alias Channels =
    { red : Float
    , green : Float
    , blue : Float
    , alpha : Opacity
    }


fromChannels : Channels -> Color
fromChannels { red, green, blue, alpha } =
    Color
        { red = clamp 0 255 red
        , green = clamp 0 255 green
        , blue = clamp 0 255 blue
        , alpha = alpha
        }


toChannels : Color -> Channels
toChannels (Color values) =
    values


getOpacity : Color -> Opacity
getOpacity (Color { alpha }) =
    alpha


setOpacity : Opacity -> Color -> Color
setOpacity alpha (Color channels) =
    Color { channels | alpha = alpha }


toStringWithoutOpacity : Color -> String
toStringWithoutOpacity (Color { red, green, blue }) =
    "rgb("
        ++ String.fromFloat red
        ++ ","
        ++ String.fromFloat green
        ++ ","
        ++ String.fromFloat blue
        ++ ")"


toStringWithOpacity : Color -> String
toStringWithOpacity (Color { red, green, blue, alpha }) =
    "rgba("
        ++ String.fromFloat red
        ++ ","
        ++ String.fromFloat green
        ++ ","
        ++ String.fromFloat blue
        ++ ","
        ++ Opacity.toString alpha
        ++ ")"


fromHSLA : { hue : Float, saturation : Float, lightness : Float, alpha : Opacity } -> Color
fromHSLA ({ hue, alpha } as hsl) =
    let
        saturation =
            hsl.saturation / 100

        lightness =
            hsl.lightness / 100

        chroma =
            (1 - abs (2 * lightness - 1)) * saturation

        hueIsBetween lowerBound upperBound =
            lowerBound <= hue && hue <= upperBound

        zigUp xIntercept =
            chroma * (hue - xIntercept) / 60

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
    fromChannels
        { red = (r + lightnessModifier) * 255
        , green = (g + lightnessModifier) * 255
        , blue = (b + lightnessModifier) * 255
        , alpha = alpha
        }

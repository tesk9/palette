module Internal.Color exposing
    ( Color
    , fromHSLA, fromRGBA
    , asHSLA
    , getOpacity
    , rotateHue, addSaturation, addLightness, invert
    , asHex, asRGBA
    )

{-|

@docs Color
@docs fromHSLA, fromRGBA
@docs asHSLA, asRGBA asHex
@docs getOpacity
@docs rotateHue, addSaturation, addLightness, invert

-}

import Dict
import Internal.HSLA as HSLA
import Internal.Hex as Hex
import Internal.Opacity as Opacity
import Internal.RGBA as RGBA


{-| -}
type Color
    = HSLA HSLA.Color
    | RGBA RGBA.Color


{-| -}
fromHSLA : HSLA.Channels -> Color
fromHSLA values =
    HSLA (HSLA.fromChannels values)


{-| -}
asHSLA : Color -> HSLA.Color
asHSLA color =
    case color of
        HSLA values ->
            values

        RGBA rgbValues ->
            asHSLA (convertRGBAToHSL rgbValues)


{-| -}
fromRGBA : RGBA.Channels -> Color
fromRGBA values =
    RGBA (RGBA.fromChannels values)


{-| -}
asRGBA : Color -> RGBA.Color
asRGBA color =
    case color of
        RGBA values ->
            values

        HSLA hslValues ->
            asRGBA (convertHSLToRGBA hslValues)


{-| -}
asHex : Color -> Hex.Color
asHex color =
    case color of
        RGBA values ->
            RGBA.toChannels values

        HSLA hslValues ->
            asHex (convertHSLToRGBA hslValues)


{-| -}
fromHex : String -> Maybe Color
fromHex str =
    Maybe.map (RGBA.fromChannels >> RGBA) (Hex.fromString str)


{-| -}
getOpacity : Color -> Opacity.Opacity
getOpacity color =
    case color of
        RGBA values ->
            RGBA.getOpacity values

        HSLA values ->
            HSLA.getOpacity values



-- CONVERSIONS


{-| -}
convertRGBAToHSL : RGBA.Color -> Color
convertRGBAToHSL color =
    RGBA.toChannels color
        |> HSLA.fromRGBA
        |> HSLA


convertHSLToRGBA : HSLA.Color -> Color
convertHSLToRGBA color =
    HSLA.toChannels color
        |> RGBA.fromHSLA
        |> RGBA



-- MODIFICATIONS


{-| -}
rotateHue : Float -> Color -> Color
rotateHue degrees color =
    let
        ({ hue } as hsla) =
            HSLA.toChannels (asHSLA color)
    in
    fromHSLA { hsla | hue = hue + degrees }


{-| -}
addSaturation : Float -> Color -> Color
addSaturation percentage color =
    let
        ({ saturation } as hsla) =
            HSLA.toChannels (asHSLA color)
    in
    fromHSLA { hsla | saturation = saturation + percentage }


{-| -}
addLightness : Float -> Color -> Color
addLightness percentage color =
    let
        ({ lightness } as hsla) =
            HSLA.toChannels (asHSLA color)
    in
    fromHSLA { hsla | lightness = lightness + percentage }


{-| -}
invert : Color -> Color
invert color =
    let
        { red, green, blue, alpha } =
            RGBA.toChannels (asRGBA color)
    in
    fromRGBA
        { red = 255 - red
        , green = 255 - green
        , blue = 255 - blue
        , alpha = alpha
        }

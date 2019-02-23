module Internal.Color exposing
    ( Color
    , fromHSLA, toHSL
    , fromRGBA, toRGBA
    , opacity
    )

{-|

@docs Color
@docs fromHSLA, toHSL
@docs fromRGBA, toRGBA
@docs opacity

-}

import Dict
import Internal.HSLA as HSLA
import Internal.Hex as Hex
import Internal.RGBA as RGBA
import Opacity exposing (Opacity)


type Color
    = HSLA HSLA.Color
    | RGBA RGBA.Color


fromHSLA : HSLA.Channels -> Color
fromHSLA values =
    HSLA (HSLA.fromChannels values)


toHSL : Color -> HSLA.Channels
toHSL color =
    case color of
        HSLA values ->
            HSLA.toChannels values

        RGBA rgbValues ->
            toHSL (convertRGBAToHSL rgbValues)


fromRGBA : RGBA.Channels -> Color
fromRGBA values =
    RGBA (RGBA.fromChannels values)


toRGBA : Color -> RGBA.Channels
toRGBA color =
    case color of
        RGBA values ->
            RGBA.toChannels values

        HSLA hslValues ->
            toRGBA (convertHSLToRGBA hslValues)


fromHexString : String -> Maybe Color
fromHexString str =
    Maybe.map (RGBA.fromChannels >> RGBA) (Hex.fromString str)


opacity : Color -> Opacity
opacity color =
    case color of
        HSLA values ->
            .alpha (HSLA.toChannels values)

        RGBA values ->
            .alpha (RGBA.toChannels values)



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

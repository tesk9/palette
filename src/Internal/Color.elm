module Internal.Color exposing
    ( Color
    , fromHSLA, asHSLA
    , fromRGBA, toRGBA
    )

{-|

@docs Color
@docs fromHSLA, asHSLA
@docs fromRGBA, toRGBA

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


asHSLA : Color -> HSLA.Color
asHSLA color =
    case color of
        HSLA values ->
            values

        RGBA rgbValues ->
            asHSLA (convertRGBAToHSL rgbValues)


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

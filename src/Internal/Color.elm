module Internal.Color exposing
    ( Color
    , fromHSLA, toHSL
    , fromRGB, toRGB
    )

{-|

@docs Color
@docs fromHSLA, toHSL
@docs fromRGB, toRGB

-}

import Dict
import Internal.HSLA as HSLA
import Internal.Hex as Hex
import Internal.RGB as RGB


type Color
    = HSLA HSLA.Color
    | RGB RGB.Color


fromHSLA : HSLA.Channels -> Color
fromHSLA values =
    HSLA (HSLA.fromChannels values)


toHSL : Color -> HSLA.Channels
toHSL color =
    case color of
        HSLA values ->
            HSLA.toChannels values

        RGB rgbValues ->
            toHSL (convertRGBToHSL rgbValues)


fromRGB : RGB.Channels -> Color
fromRGB values =
    RGB (RGB.fromChannels values)


toRGB : Color -> RGB.Channels
toRGB color =
    case color of
        RGB values ->
            RGB.toChannels values

        HSLA hslValues ->
            toRGB (convertHSLToRGB hslValues)



-- CONVERSIONS


{-| -}
convertRGBToHSL : RGB.Color -> Color
convertRGBToHSL color =
    RGB.toChannels color
        |> HSLA.fromRGB
        |> HSLA


convertHSLToRGB : HSLA.Color -> Color
convertHSLToRGB color =
    HSLA.toChannels color
        |> RGB.fromHSLA
        |> RGB

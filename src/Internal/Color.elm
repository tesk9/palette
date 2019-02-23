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
import Internal.HSL as HSL
import Internal.Hex as Hex
import Internal.RGB as RGB


type Color
    = HSL HSL.Color
    | RGB RGB.Color


fromHSL : HSL.Channels -> Color
fromHSL values =
    HSL (HSL.fromChannels values)


toHSL : Color -> HSL.Channels
toHSL color =
    case color of
        HSL values ->
            HSL.toChannels values

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

        HSL hslValues ->
            toRGB (convertHSLToRGB hslValues)



-- CONVERSIONS


{-| -}
convertRGBToHSL : RGB.Color -> Color
convertRGBToHSL color =
    RGB.toChannels color
        |> HSL.fromRGB
        |> HSL


convertHSLToRGB : HSL.Color -> Color
convertHSLToRGB color =
    HSL.toChannels color
        |> RGB.fromHSL
        |> RGB

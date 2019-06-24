module Internal.Colour exposing
    ( Colour
    , fromHSLA, fromRGBA
    , asHSLA
    , rotateHue, addSaturation, addLightness, invert
    , asHex, asRGBA
    )

{-|

@docs Colour
@docs fromHSLA, fromRGBA
@docs asHSLA, asRGBA asHex
@docs rotateHue, addSaturation, addLightness, invert

-}

import Dict
import Internal.HSLA as HSLA
import Internal.Hex as Hex
import Internal.Opacity as Opacity
import Internal.RGBA as RGBA


{-| -}
type Colour
    = HSLA HSLA.Colour
    | RGBA RGBA.Colour


{-| -}
fromHSLA : HSLA.Channels -> Colour
fromHSLA values =
    HSLA (HSLA.fromChannels values)


{-| -}
asHSLA : Colour -> HSLA.Colour
asHSLA color =
    case color of
        HSLA values ->
            values

        RGBA rgbValues ->
            asHSLA (convertRGBAToHSL rgbValues)


{-| -}
fromRGBA : RGBA.Channels -> Colour
fromRGBA values =
    RGBA (RGBA.fromChannels values)


{-| -}
asRGBA : Colour -> RGBA.Colour
asRGBA color =
    case color of
        RGBA values ->
            values

        HSLA hslValues ->
            asRGBA (convertHSLToRGBA hslValues)


{-| -}
asHex : Colour -> Hex.Colour
asHex color =
    case color of
        RGBA values ->
            RGBA.toChannels values

        HSLA hslValues ->
            asHex (convertHSLToRGBA hslValues)


{-| -}
fromHex : String -> Maybe Colour
fromHex str =
    Maybe.map (RGBA.fromChannels >> RGBA) (Hex.fromString str)



-- CONVERSIONS


{-| -}
convertRGBAToHSL : RGBA.Colour -> Colour
convertRGBAToHSL color =
    RGBA.toChannels color
        |> HSLA.fromRGBA
        |> HSLA


convertHSLToRGBA : HSLA.Colour -> Colour
convertHSLToRGBA color =
    HSLA.toChannels color
        |> RGBA.fromHSLA
        |> RGBA



-- MODIFICATIONS


{-| -}
rotateHue : Float -> Colour -> Colour
rotateHue degrees color =
    let
        ({ hue } as hsla) =
            HSLA.toChannels (asHSLA color)
    in
    fromHSLA { hsla | hue = hue + degrees }


{-| -}
addSaturation : Float -> Colour -> Colour
addSaturation percentage color =
    let
        ({ saturation } as hsla) =
            HSLA.toChannels (asHSLA color)
    in
    fromHSLA { hsla | saturation = saturation + percentage }


{-| -}
addLightness : Float -> Colour -> Colour
addLightness percentage color =
    let
        ({ lightness } as hsla) =
            HSLA.toChannels (asHSLA color)
    in
    fromHSLA { hsla | lightness = lightness + percentage }


{-| -}
invert : Colour -> Colour
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

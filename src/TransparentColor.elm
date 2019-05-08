module TransparentColor exposing
    ( TransparentColor
    , fromColor, toColor
    , getOpacity
    , mapColor, mapOpacity, map
    , equals
    , fromHSLA, toHSLA, toHSLAString
    , fromRGBA, toRGBA, toRGBAString
    , fromHexAString, toHexAString
    )

{-| This module provides helpers for working with colors that are not fully opaque.

Why is `TransparentColor` separate from `Color`? Why isn't `Color` simply modeled
as an RGBA color value?

Transparency fundamentally involves stacking contexts on render; transparency
is really a shortcut for saying "blend my color with whatever is behind it."

As soon as we know that our color may be transparent, we can no longer make
claims about contrast or luminance. Black text on a white background provides
high contrast, but transparent black text on a white background may not be high
contrast.

`TransparentColor` exists in order to try to keep functions like `Color.luminance`
and `Color.Contrast.sufficientContrast` safe and reliable, while also providing
full-featured support for working with alpha channel values.

These docs assume that you're familiar with the color space you're looking at.
If not, read more about each color space in `Color`.

@docs TransparentColor

@docs fromColor, toColor
@docs getOpacity
@docs mapColor, mapOpacity, map
@docs equals


## HSL values

@docs fromHSLA, toHSLA, toHSLAString


## RGB values

@docs fromRGBA, toRGBA, toRGBAString


## Hex values

@docs fromHexAString, toHexAString

-}

import Color
import Dict
import Internal.Color
import Internal.HSLA
import Internal.Hex
import Internal.RGBA
import Opacity exposing (Opacity)


{-| -}
type TransparentColor
    = TransparentColor Internal.Color.Color


{-| -}
fromHSLA : Internal.HSLA.Channels -> TransparentColor
fromHSLA =
    Internal.Color.fromHSLA >> TransparentColor


{-| Extract the hue, saturation, lightness, and alpha values from an existing Color.
-}
toHSLA : TransparentColor -> Internal.HSLA.Channels
toHSLA (TransparentColor color) =
    Internal.HSLA.toChannels (Internal.Color.asHSLA color)


{-| -}
toHSLAString : TransparentColor -> String
toHSLAString (TransparentColor color) =
    Internal.HSLA.toStringWithOpacity (Internal.Color.asHSLA color)


{-| -}
fromRGBA : Internal.RGBA.Channels -> TransparentColor
fromRGBA =
    Internal.Color.fromRGBA >> TransparentColor


{-| Extract the red, green, blue, and alpha values from an existing Color.
-}
toRGBA : TransparentColor -> { red : Float, green : Float, blue : Float, alpha : Opacity }
toRGBA (TransparentColor color) =
    Internal.RGBA.toChannels (Internal.Color.asRGBA color)


{-| -}
toRGBAString : TransparentColor -> String
toRGBAString (TransparentColor color) =
    Internal.RGBA.toStringWithOpacity (Internal.Color.asRGBA color)


{-| Build a new color from a hex string that might include transparencies.
Supports lowercase and uppercase strings.

    (Color.fromHexAString "#FFDD00" == Color.fromHexAString "#FD0")
        && (Color.fromHexAString "#FFDD00" == Color.fromHexAString "#ffdd00")
        && (Color.fromHexAString "##ffdd00" == Color.fromHexAString "#ffdd00ff")

-}
fromHexAString : String -> Result String TransparentColor
fromHexAString colorString =
    case Internal.Hex.fromString colorString of
        Just rgbChannelValues ->
            Ok (fromRGBA rgbChannelValues)

        Nothing ->
            Err ("fromHexString could not convert " ++ colorString ++ " to a TransparentColor.")


{-| -}
toHexAString : TransparentColor -> String
toHexAString (TransparentColor color) =
    Internal.Hex.toString (Internal.Color.asHex color)


{-| Check two colors for equality.
-}
equals : TransparentColor -> TransparentColor -> Bool
equals a b =
    toRGBA a == toRGBA b


{-| Specify the opacity for a color without opacity.

    import Color exposing (Color)
    import Opacity
    import TransparentColor exposing (TransparentColor)

    myRed : Color
    myRed =
        Color.fromRGB ( 255, 0, 0 )

    myTransparentRed : TransparentColor
    myTransparentRed =
        TransparentColor.fromColor (Opacity.custom 0.5) myRed

-}
fromColor : Opacity -> Color.Color -> TransparentColor
fromColor opacity color =
    let
        ( r, g, b ) =
            Color.toRGB color
    in
    fromRGBA
        { red = r
        , green = g
        , blue = b
        , alpha = opacity
        }


{-| If you decide you don't care about the transparency anymore, you can
drop this information and work with just the color values.
-}
toColor : TransparentColor -> Color.Color
toColor color =
    let
        { red, green, blue } =
            toRGBA color
    in
    Color.fromRGB ( red, green, blue )


{-| Extract just the opacity from the color.
-}
getOpacity : TransparentColor -> Opacity
getOpacity (TransparentColor c) =
    Internal.Color.getOpacity c


{-|

    import Color.Generator exposing (rotate)
    import TransparentColor exposing (TransparentColor)

    nextColor : TransparentColor -> TransparentColor
    nextColor color =
        TransparentColor.mapColor (rotate 10) color

-}
mapColor : (Color.Color -> Color.Color) -> TransparentColor -> TransparentColor
mapColor f =
    map identity f


{-|

    import Opacity exposing (Opacity)
    import SomeCustomStylesheet exposing (red)
    import TransparentColor exposing (TransparentColor)

    myTransparentRed : TransparentColor
    myTransparentRed =
        TransparentColor.mapOpacity halveOpacity red

    halveOpacity : Opacity -> Opacity
    halveOpacity =
        Opacity.map (\current -> current / 2)

-}
mapOpacity : (Opacity -> Opacity) -> TransparentColor -> TransparentColor
mapOpacity f =
    map f identity


{-|

    import Color.Generator exposing (rotate)
    import Opacity
    import TransparentColor exposing (TransparentColor)

    rotateAndMakeMoreTransparent : TransparentColor -> TransparentColor
    rotateAndMakeMoreTransparent =
        TransparentColor.map
            (Opacity.map (\num -> num - 0.1))
            (rotate 10)

-}
map : (Opacity -> Opacity) -> (Color.Color -> Color.Color) -> TransparentColor -> TransparentColor
map fo fc color =
    fromColor (fo (getOpacity color)) (fc (toColor color))

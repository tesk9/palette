module TransparentColor exposing
    ( TransparentColor
    , Opacity
    , transparent, opaque, customOpacity
    , opacityToString, opacityToFloat
    , fromColor, toColor
    , fromRGBA, toRGBA, toRGBAString
    , fromHSLA, toHSLA, toHSLAString
    , fromHexA, toHexA
    , invert
    , blacken, whiten, grayen
    , rotateHue, addSaturation, addLightness
    )

{-| This module provides helpers for working with colors that are not fully opaque.

Why is `TransparentColor` separate from `SolidColor`? Why isn't `SolidColor` simply modeled
as an RGBA color value?

Transparency fundamentally involves stacking contexts on render; transparency
is really a shortcut for saying "blend my color with whatever is behind it."

As soon as we know that our color may be transparent, we can no longer make
claims about contrast or luminance. Black text on a white background provides
high contrast, but transparent black text on a white background may not be high
contrast.

`TransparentColor` exists in order to try to keep functions like `SolidColor.luminance`
and `SolidColor.Accessibility.sufficientContrast` safe and reliable, while also providing
full-featured support for working with alpha channel values.

These docs assume that you're familiar with the color space you're looking at.
If not, read more about each color space in `SolidColor`.

@docs TransparentColor


## Opacity

@docs Opacity
@docs transparent, opaque, customOpacity
@docs opacityToString, opacityToFloat


## Conversions

@docs fromColor, toColor
@docs fromRGBA, toRGBA, toRGBAString
@docs fromHSLA, toHSLA, toHSLAString
@docs fromHexA, toHexA


## Customize Colors

@docs invert
@docs blacken, whiten, grayen
@docs rotateHue, addSaturation, addLightness

-}

import Dict
import Internal.Color
import Internal.HSLA
import Internal.Hex
import Internal.Opacity
import Internal.RGBA
import SolidColor exposing (SolidColor)


{-| -}
type TransparentColor
    = Color Internal.Color.Color


{-| -}
fromHSLA :
    { hue : Float
    , saturation : Float
    , lightness : Float
    , alpha : Opacity
    }
    -> TransparentColor
fromHSLA =
    Internal.Color.fromHSLA >> Color


{-| Extract the hue, saturation, lightness, and alpha values from an existing Color.
-}
toHSLA :
    TransparentColor
    ->
        { hue : Float
        , saturation : Float
        , lightness : Float
        , alpha : Opacity
        }
toHSLA (Color color) =
    Internal.HSLA.toChannels (Internal.Color.asHSLA color)


{-| -}
toHSLAString : TransparentColor -> String
toHSLAString (Color color) =
    Internal.HSLA.toStringWithOpacity (Internal.Color.asHSLA color)


{-| -}
fromRGBA :
    { red : Float
    , green : Float
    , blue : Float
    , alpha : Opacity
    }
    -> TransparentColor
fromRGBA =
    Internal.Color.fromRGBA >> Color


{-| Extract the red, green, blue, and alpha values from an existing Color.
-}
toRGBA :
    TransparentColor
    ->
        { red : Float
        , green : Float
        , blue : Float
        , alpha : Opacity
        }
toRGBA (Color color) =
    Internal.RGBA.toChannels (Internal.Color.asRGBA color)


{-| -}
toRGBAString : TransparentColor -> String
toRGBAString (Color color) =
    Internal.RGBA.toStringWithOpacity (Internal.Color.asRGBA color)


{-| Build a new color from a hex string that might include transparencies.
Supports lowercase and uppercase strings.
-}
fromHexA : String -> Result String TransparentColor
fromHexA colorString =
    case Internal.Hex.fromString colorString of
        Just rgbChannelValues ->
            Ok (fromRGBA rgbChannelValues)

        Nothing ->
            Err ("fromHex could not convert " ++ colorString ++ " to a Color.")


{-| -}
toHexA : TransparentColor -> String
toHexA (Color color) =
    Internal.Hex.toString (Internal.Color.asHex color)


{-| Specify the opacity for a color without opacity.

    import SolidColor exposing (SolidColor)
    import TransparentColor exposing (TransparentColor, customOpacity)

    myRed : SolidColor
    myRed =
        SolidColor.fromRGB ( 255, 0, 0 )

    myTransparentRed : TransparentColor
    myTransparentRed =
        TransparentColor.fromColor (customOpacity 0.5) myRed

-}
fromColor : Opacity -> SolidColor -> TransparentColor
fromColor opacity color =
    let
        ( r, g, b ) =
            SolidColor.toRGB color
    in
    fromRGBA
        { red = r
        , green = g
        , blue = b
        , alpha = opacity
        }


{-| If you decide you don't care about the opacity anymore, you can
drop this information.
-}
toColor : TransparentColor -> SolidColor
toColor color =
    let
        { red, green, blue } =
            toRGBA color
    in
    SolidColor.fromRGB ( red, green, blue )



-- OPACITY


{-| -}
type alias Opacity =
    Internal.Opacity.Opacity


{-| Provided for convenience. Equivalent to doing:

    Opacity.customOpacity 0

-}
transparent : Opacity
transparent =
    Internal.Opacity.transparent


{-| Provided for convenience. Equivalent to doing:

    Opacity.customOpacity 1.0

-}
opaque : Opacity
opaque =
    Internal.Opacity.opaque


{-| Pass in a value in [0, 1.0]. The value passed in will be clamped within these bounds.
-}
customOpacity : Float -> Opacity
customOpacity =
    Internal.Opacity.custom


{-| -}
opacityToFloat : Opacity -> Float
opacityToFloat =
    Internal.Opacity.toFloat


{-| -}
opacityToString : Opacity -> String
opacityToString =
    String.fromFloat << opacityToFloat


{-| -}
rotateHue : Float -> TransparentColor -> TransparentColor
rotateHue degrees (Color color) =
    Color (Internal.Color.rotateHue degrees color)


{-| -}
blacken : Float -> TransparentColor -> TransparentColor
blacken percentage color =
    addLightness (0 - abs percentage) color


{-| -}
whiten : Float -> TransparentColor -> TransparentColor
whiten percentage color =
    addLightness (abs percentage) color


{-| -}
grayen : Float -> TransparentColor -> TransparentColor
grayen percentage color =
    addSaturation (0 - abs percentage) color


{-| -}
addSaturation : Float -> TransparentColor -> TransparentColor
addSaturation percentage (Color color) =
    Color (Internal.Color.addSaturation percentage color)


{-| -}
addLightness : Float -> TransparentColor -> TransparentColor
addLightness percentage (Color color) =
    Color (Internal.Color.addLightness percentage color)


{-| -}
invert : TransparentColor -> TransparentColor
invert (Color color) =
    Color (Internal.Color.invert color)

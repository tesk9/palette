module Colour.Transparent exposing
    ( Opacity
    , transparent, opaque, customOpacity
    , opacityToString, opacityToFloat
    , Colour
    , fromColor
    , fromRGBA, fromHSLA, fromHexA
    , toColor
    , toRGBAString, toHSLAString
    , invert
    , blacken, whiten, greyen
    , rotateHue, addSaturation, addLightness
    , toRGBA, toHSLA, toHexA
    )

{-| This module provides helpers for working with colors that are not fully opaque.

Why is `Colour.Transparent` separate from `Color`? Why isn't `Color` simply modeled
as an RGBA color value?

Transparency fundamentally involves stacking contexts on render; transparency
is really a shortcut for saying "blend my color with whatever is behind it."

As soon as we know that our color may be transparent, we can no longer make
claims about contrast or luminance. Black text on a white background provides
high contrast, but transparent black text on a white background may not be high
contrast.

`Colour.Transparent` exists in order to try to keep functions like `Color.luminance`
and `Color.Contrast.sufficientContrast` safe and reliable, while also providing
full-featured support for working with alpha channel values.

These docs assume that you're familiar with the color space you're looking at.
If not, read more about each color space in `Color`.


## Opacity

@docs Opacity
@docs transparent, opaque, customOpacity
@docs opacityToString, opacityToFloat


## Colour

@docs Colour
@docs fromColor
@docs fromRGBA, fromHSLA, fromHexA


## Use Colours

@docs toColor
@docs toRGBAString, toHSLAString


## Customize Colours

@docs invert
@docs blacken, whiten, greyen
@docs rotateHue, addSaturation, addLightness


## Helpers

@docs toRGBA, toHSLA, toHexA

-}

import Colour
import Dict
import Internal.Color
import Internal.HSLA
import Internal.Hex
import Internal.Opacity
import Internal.RGBA


{-| -}
type Colour
    = Colour Internal.Color.Color


{-| -}
fromHSLA :
    { hue : Float
    , saturation : Float
    , lightness : Float
    , alpha : Opacity
    }
    -> Colour
fromHSLA =
    Internal.Color.fromHSLA >> Colour


{-| Extract the hue, saturation, lightness, and alpha values from an existing Color.
-}
toHSLA :
    Colour
    ->
        { hue : Float
        , saturation : Float
        , lightness : Float
        , alpha : Opacity
        }
toHSLA (Colour color) =
    Internal.HSLA.toChannels (Internal.Color.asHSLA color)


{-| -}
toHSLAString : Colour -> String
toHSLAString (Colour color) =
    Internal.HSLA.toStringWithOpacity (Internal.Color.asHSLA color)


{-| -}
fromRGBA :
    { red : Float
    , green : Float
    , blue : Float
    , alpha : Opacity
    }
    -> Colour
fromRGBA =
    Internal.Color.fromRGBA >> Colour


{-| Extract the red, green, blue, and alpha values from an existing Color.
-}
toRGBA :
    Colour
    ->
        { red : Float
        , green : Float
        , blue : Float
        , alpha : Opacity
        }
toRGBA (Colour color) =
    Internal.RGBA.toChannels (Internal.Color.asRGBA color)


{-| -}
toRGBAString : Colour -> String
toRGBAString (Colour color) =
    Internal.RGBA.toStringWithOpacity (Internal.Color.asRGBA color)


{-| Build a new color from a hex string that might include transparencies.
Supports lowercase and uppercase strings.
-}
fromHexA : String -> Result String Colour
fromHexA colorString =
    case Internal.Hex.fromString colorString of
        Just rgbChannelValues ->
            Ok (fromRGBA rgbChannelValues)

        Nothing ->
            Err ("fromHex could not convert " ++ colorString ++ " to a Colour.")


{-| -}
toHexA : Colour -> String
toHexA (Colour color) =
    Internal.Hex.toString (Internal.Color.asHex color)


{-| Specify the opacity for a color without opacity.

    import Colour
    import Colour.Transparent

    myRed : Colour.Colour
    myRed =
        Colour.fromRGB ( 255, 0, 0 )

    myTransparentRed : Colour.Transparent.Colour
    myTransparentRed =
        Colour.fromColor (Colour.Transparent.Colour.customOpacity 0.5) myRed

-}
fromColor : Opacity -> Colour.Colour -> Colour
fromColor opacity color =
    let
        ( r, g, b ) =
            Colour.toRGB color
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
toColor : Colour -> Colour.Colour
toColor color =
    let
        { red, green, blue } =
            toRGBA color
    in
    Colour.fromRGB ( red, green, blue )



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


{-| Rotate a color by degrees [0, 360).

Picture the color wheel. Suppose you want to find 8 evenly-spaced colors from a starting color.
You might do something like this:

    import Transparent.Colour exposing (Colour)

    eightEvenColors : Colour -> List Colour
    eightEvenColors color =
        List.range 0 7
            |> List.map (\i -> Colour.rotateHue (toFloat i * 360 / 8) color)

-}
rotateHue : Float -> Colour -> Colour
rotateHue degrees (Colour color) =
    Colour (Internal.Color.rotateHue degrees color)


{-| -}
blacken : Float -> Colour -> Colour
blacken percentage color =
    addLightness (0 - abs percentage) color


{-| -}
whiten : Float -> Colour -> Colour
whiten percentage color =
    addLightness (abs percentage) color


{-| -}
greyen : Float -> Colour -> Colour
greyen percentage color =
    addSaturation (0 - abs percentage) color


{-| Modify the saturation of a color (see notes on HSL color space).
-}
addSaturation : Float -> Colour -> Colour
addSaturation percentage (Colour color) =
    Colour (Internal.Color.addSaturation percentage color)


{-| Modify the lightness of a color (see notes on HSL color space).
-}
addLightness : Float -> Colour -> Colour
addLightness percentage (Colour color) =
    Colour (Internal.Color.addLightness percentage color)


{-| Use this function to invert a color. E.g., black inverted is white, white inverted is black....
-}
invert : Colour -> Colour
invert (Colour color) =
    Colour (Internal.Color.invert color)

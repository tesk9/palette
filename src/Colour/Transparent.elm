module Colour.Transparent exposing
    ( Opacity
    , transparent, opaque, customOpacity
    , opacityToString, opacityToFloat
    , Colour
    , fromColour
    , fromRGBA, fromHSLA, fromHexA
    , toColour
    , toRGBAString, toHSLAString
    , invert
    , blacken, whiten, grayen
    , rotateHue, addSaturation, addLightness
    , toRGBA, toHSLA, toHexA
    )

{-| This module provides helpers for working with colors that are not fully opaque.

Why is `Colour.Transparent` separate from `Colour`? Why isn't `Colour` simply modeled
as an RGBA color value?

Transparency fundamentally involves stacking contexts on render; transparency
is really a shortcut for saying "blend my colour with whatever is behind it."

As soon as we know that our colour may be transparent, we can no longer make
claims about contrast or luminance. Black text on a white background provides
high contrast, but transparent black text on a white background may not be high
contrast.

`Colour.Transparent` exists in order to try to keep functions like `Colour.luminance`
and `Colour.Accessibility.sufficientContrast` safe and reliable, while also providing
full-featured support for working with alpha channel values.

These docs assume that you're familiar with the colour space you're looking at.
If not, read more about each colour space in `Colour`.


## Opacity

@docs Opacity
@docs transparent, opaque, customOpacity
@docs opacityToString, opacityToFloat


## Colour

@docs Colour
@docs fromColour
@docs fromRGBA, fromHSLA, fromHexA


## Use Colours

@docs toColour
@docs toRGBAString, toHSLAString


## Customize Colours

@docs invert
@docs blacken, whiten, grayen
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

    myOpacity : Colour.Transparent.Opacity
    myOpacity =
        Colour.Transparent.Colour.customOpacity 0.5

    myTransparentRed : Colour.Transparent.Colour
    myTransparentRed =
        Colour.fromColour myOpacity myRed

-}
fromColour : Opacity -> Colour.Colour -> Colour
fromColour opacity color =
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


{-| If you decide you don't care about the opacity anymore, you can
drop this information.
-}
toColour : Colour -> Colour.Colour
toColour color =
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


{-| -}
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
grayen : Float -> Colour -> Colour
grayen percentage color =
    addSaturation (0 - abs percentage) color


{-| -}
addSaturation : Float -> Colour -> Colour
addSaturation percentage (Colour color) =
    Colour (Internal.Color.addSaturation percentage color)


{-| -}
addLightness : Float -> Colour -> Colour
addLightness percentage (Colour color) =
    Colour (Internal.Color.addLightness percentage color)


{-| -}
invert : Colour -> Colour
invert (Colour color) =
    Colour (Internal.Color.invert color)

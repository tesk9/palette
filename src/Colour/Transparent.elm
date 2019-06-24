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

{-| This module provides helpers for working with colours that are not fully opaque.

Why is `Colour.Transparent` separate from `Colour`? Why isn't `Colour` simply modeled
as an RGBA colour value?

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
import Internal.Colour
import Internal.HSLA
import Internal.Hex
import Internal.Opacity
import Internal.RGBA


{-| -}
type Colour
    = Colour Internal.Colour.Colour


{-| -}
fromHSLA :
    { hue : Float
    , saturation : Float
    , lightness : Float
    , alpha : Opacity
    }
    -> Colour
fromHSLA =
    Internal.Colour.fromHSLA >> Colour


{-| Extract the hue, saturation, lightness, and alpha values from an existing Colour.
-}
toHSLA :
    Colour
    ->
        { hue : Float
        , saturation : Float
        , lightness : Float
        , alpha : Opacity
        }
toHSLA (Colour colour) =
    Internal.HSLA.toChannels (Internal.Colour.asHSLA colour)


{-| -}
toHSLAString : Colour -> String
toHSLAString (Colour colour) =
    Internal.HSLA.toStringWithOpacity (Internal.Colour.asHSLA colour)


{-| -}
fromRGBA :
    { red : Float
    , green : Float
    , blue : Float
    , alpha : Opacity
    }
    -> Colour
fromRGBA =
    Internal.Colour.fromRGBA >> Colour


{-| Extract the red, green, blue, and alpha values from an existing Colour.
-}
toRGBA :
    Colour
    ->
        { red : Float
        , green : Float
        , blue : Float
        , alpha : Opacity
        }
toRGBA (Colour colour) =
    Internal.RGBA.toChannels (Internal.Colour.asRGBA colour)


{-| -}
toRGBAString : Colour -> String
toRGBAString (Colour colour) =
    Internal.RGBA.toStringWithOpacity (Internal.Colour.asRGBA colour)


{-| Build a new colour from a hex string that might include transparencies.
Supports lowercase and uppercase strings.
-}
fromHexA : String -> Result String Colour
fromHexA colourString =
    case Internal.Hex.fromString colourString of
        Just rgbChannelValues ->
            Ok (fromRGBA rgbChannelValues)

        Nothing ->
            Err ("fromHex could not convert " ++ colourString ++ " to a Colour.")


{-| -}
toHexA : Colour -> String
toHexA (Colour colour) =
    Internal.Hex.toString (Internal.Colour.asHex colour)


{-| Specify the opacity for a colour without opacity.

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
fromColour opacity colour =
    let
        ( r, g, b ) =
            Colour.toRGB colour
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
toColour colour =
    let
        { red, green, blue } =
            toRGBA colour
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
rotateHue degrees (Colour colour) =
    Colour (Internal.Colour.rotateHue degrees colour)


{-| -}
blacken : Float -> Colour -> Colour
blacken percentage colour =
    addLightness (0 - abs percentage) colour


{-| -}
whiten : Float -> Colour -> Colour
whiten percentage colour =
    addLightness (abs percentage) colour


{-| -}
grayen : Float -> Colour -> Colour
grayen percentage colour =
    addSaturation (0 - abs percentage) colour


{-| -}
addSaturation : Float -> Colour -> Colour
addSaturation percentage (Colour colour) =
    Colour (Internal.Colour.addSaturation percentage colour)


{-| -}
addLightness : Float -> Colour -> Colour
addLightness percentage (Colour colour) =
    Colour (Internal.Colour.addLightness percentage colour)


{-| -}
invert : Colour -> Colour
invert (Colour colour) =
    Colour (Internal.Colour.invert colour)

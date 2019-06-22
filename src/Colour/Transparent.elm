module Colour.Transparent exposing
    ( Colour
    , fromColor
    , fromRGBA, fromHSLA, fromHexAString
    , toColor
    , toRGBAString, toHSLAString, toHexAString
    , toRGBA, toHSLA
    , equals, getOpacity, map, mapColor, mapOpacity
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


## Colour.Transparent

@docs Colour
@docs fromColor
@docs fromRGBA, fromHSLA, fromHexAString


## Use Colour.Transparents

@docs toColor
@docs toRGBAString, toHSLAString, toHexAString


## Helpers

@docs toRGBA, toHSLA

-}

import Colour
import Dict
import Internal.Color
import Internal.HSLA
import Internal.Hex
import Internal.RGBA
import Opacity exposing (Opacity)


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
fromHexAString : String -> Result String Colour
fromHexAString colorString =
    case Internal.Hex.fromString colorString of
        Just rgbChannelValues ->
            Ok (fromRGBA rgbChannelValues)

        Nothing ->
            Err ("fromHexString could not convert " ++ colorString ++ " to a Colour.")


{-| -}
toHexAString : Colour -> String
toHexAString (Colour color) =
    Internal.Hex.toString (Internal.Color.asHex color)


{-| Check two colors for equality.
-}
equals : Colour -> Colour -> Bool
equals a b =
    toRGBA a == toRGBA b


{-| Specify the opacity for a color without opacity.

    import Colour exposing (Colour)
    import Opacity

    myRed : Colour
    myRed =
        Colour.fromRGB ( 255, 0, 0 )

    myTransparentRed : Colour
    myTransparentRed =
        Colour.fromColor (Opacity.custom 0.5) myRed

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


{-| Extract just the opacity from the color.
-}
getOpacity : Colour -> Opacity
getOpacity (Colour c) =
    Internal.Color.getOpacity c


{-|

    import Colour exposing (Colour)
    import Palette.Generative exposing (rotateHue)

    nextColor : Colour -> Colour
    nextColor color =
        Colour.mapColor (rotateHue 10) color

-}
mapColor :
    (Colour.Colour -> Colour.Colour)
    -> Colour
    -> Colour
mapColor f =
    map identity f


{-|

    import Colour exposing (Colour)
    import Opacity exposing (Opacity)
    import SomeCustomStylesheet exposing (red)

    myTransparentRed : Colour
    myTransparentRed =
        Colour.mapOpacity halveOpacity red

    halveOpacity : Opacity -> Opacity
    halveOpacity =
        Opacity.map (\current -> current / 2)

-}
mapOpacity :
    (Opacity -> Opacity)
    -> Colour
    -> Colour
mapOpacity f =
    map f identity


{-|

    import Colour.Transparent exposing (Colour)
    import Opacity
    import Palette.Generative exposing (rotateHue)

    rotateAndMakeMoreTransparent : Colour -> Colour
    rotateAndMakeMoreTransparent =
        Colour.map
            (Opacity.map (\num -> num - 0.1))
            (rotateHue 10)

-}
map :
    (Opacity -> Opacity)
    -> (Colour.Colour -> Colour.Colour)
    -> Colour
    -> Colour
map fo fc color =
    fromColor (fo (getOpacity color)) (fc (toColor color))

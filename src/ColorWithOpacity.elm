module ColorWithOpacity exposing
    ( ColorWithOpacity
    , fromColor, toColor
    , getOpacity
    , mapColor, mapOpacity, map
    , equals
    , fromHSLA, toHSLA, toHSLAString
    , fromRGBA, toRGBA, toRGBAString
    , fromHexAString, toHexAString
    )

{-| This module provides helpers for working with colors that are not fully opaque.

These docs assume that you're familiar with the color space you're looking at.
If not, read more about each color space in `Color`.

@docs ColorWithOpacity

@docs fromColor, toColor
@docs getOpacity
@docs mapColor, mapOpacity, map
@docs equals


## HSL values

@docs fromHSLA, toHSLA, toHSLAString


### RGB values

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
type ColorWithOpacity
    = ColorWithOpacity Internal.Color.Color


{-| -}
fromHSLA : Internal.HSLA.Channels -> ColorWithOpacity
fromHSLA =
    Internal.Color.fromHSLA >> ColorWithOpacity


{-| Extract the hue, saturation, lightness, and alpha values from an existing Color.
-}
toHSLA : ColorWithOpacity -> Internal.HSLA.Channels
toHSLA (ColorWithOpacity color) =
    Internal.HSLA.toChannels (Internal.Color.asHSLA color)


{-| -}
toHSLAString : ColorWithOpacity -> String
toHSLAString (ColorWithOpacity color) =
    Internal.HSLA.toStringWithOpacity (Internal.Color.asHSLA color)


{-| -}
fromRGBA : Internal.RGBA.Channels -> ColorWithOpacity
fromRGBA =
    Internal.Color.fromRGBA >> ColorWithOpacity


{-| Extract the red, green, blue, and alpha values from an existing Color.
-}
toRGBA : ColorWithOpacity -> { red : Float, green : Float, blue : Float, alpha : Opacity }
toRGBA (ColorWithOpacity color) =
    Internal.RGBA.toChannels (Internal.Color.asRGBA color)


{-| -}
toRGBAString : ColorWithOpacity -> String
toRGBAString (ColorWithOpacity color) =
    Internal.RGBA.toStringWithOpacity (Internal.Color.asRGBA color)


{-| Build a new color from a hex string that might include transparencies.
Supports lowercase and uppercase strings.

    (Color.fromHexAString "#FFDD00" == Color.fromHexAString "#FD0")
        && (Color.fromHexAString "#FFDD00" == Color.fromHexAString "#ffdd00")
        && (Color.fromHexAString "##ffdd00" == Color.fromHexAString "#ffdd00ff")

-}
fromHexAString : String -> Result String ColorWithOpacity
fromHexAString colorString =
    case Internal.Hex.fromString colorString of
        Just rgbChannelValues ->
            Ok (fromRGBA rgbChannelValues)

        Nothing ->
            Err ("fromHexString could not convert " ++ colorString ++ " to a ColorWithOpacity.")


{-| Get the Hex representation of a color as a `String`.

    import Color exposing (toHexString)
    import Html exposing (p, text)
    import Html.Attributes exposing (type_, value)
    import Palette.X11 exposing (red)

    view =
        Html.input
            [ type_ "color"
            , value (toHexAString red)
            ]
            []

Note: this function will always return a string in either the form "#RRGGBB"
or the form "#RRGGBBAA".
It will not return shortened values (i.e., "#RGB" and "#RGBA").

If you want or need this functionality, please make an issue for it on the
github repo for this library.

-}
toHexAString : ColorWithOpacity -> String
toHexAString color =
    Internal.Hex.toString (toRGBA color)


{-| Check two colors for equality.
-}
equals : ColorWithOpacity -> ColorWithOpacity -> Bool
equals a b =
    toRGBA a == toRGBA b


{-| Specify the opacity for a color without opacity.

    import Color exposing (Color)
    import ColorWithOpacity exposing (ColorWithOpacity)
    import Opacity

    myRed : Color
    myRed =
        Color.fromRGB ( 255, 0, 0 )

    myTransparentRed : ColorWithOpacity
    myTransparentRed =
        ColorWithOpacity.fromColor (Opacity.custom 0.5) myRed

-}
fromColor : Opacity -> Color.Color -> ColorWithOpacity
fromColor opacity color =
    ColorWithOpacity (Internal.Color.setOpacity color opacity)


{-| If you decide you don't care about the transparency anymore, you can
drop this information and work with just the color values.
-}
toColor : ColorWithOpacity -> Color.Color
toColor (ColorWithOpacity color) =
    Internal.Color.setOpacity color Opacity.opaque


{-| Extract just the opacity from the color.
-}
getOpacity : ColorWithOpacity -> Opacity
getOpacity (ColorWithOpacity c) =
    Internal.Color.getOpacity c


{-|

    import Color.Generator exposing (rotate)
    import ColorWithOpacity exposing (ColorWithOpacity)

    nextColor : ColorWithOpacity -> ColorWithOpacity
    nextColor color =
        ColorWithOpacity.mapColor (rotate 10) color

-}
mapColor : (Color.Color -> Color.Color) -> ColorWithOpacity -> ColorWithOpacity
mapColor f =
    map identity f


{-|

    import ColorWithOpacity exposing (ColorWithOpacity)
    import Opacity exposing (Opacity)
    import SomeCustomStylesheet exposing (red)

    myTransparentRed : ColorWithOpacity
    myTransparentRed =
        ColorWithOpacity.mapOpacity halveOpacity red

    halveOpacity : Opacity -> Opacity
    halveOpacity =
        Opacity.map (\current -> current / 2)

-}
mapOpacity : (Opacity -> Opacity) -> ColorWithOpacity -> ColorWithOpacity
mapOpacity f =
    map f identity


{-|

    import Color.Generator exposing (rotate)
    import ColorWithOpacity exposing (ColorWithOpacity)
    import Opacity

    rotateAndMakeMoreTransparent : ColorWithOpacity -> ColorWithOpacity
    rotateAndMakeMoreTransparent =
        ColorWithOpacity.map
            (Opacity.map (\num -> num - 0.1))
            (rotate 10)

-}
map : (Opacity -> Opacity) -> (Color.Color -> Color.Color) -> ColorWithOpacity -> ColorWithOpacity
map fo fc (ColorWithOpacity color) =
    fo (Internal.Color.getOpacity color)
        |> Internal.Color.setOpacity (fc color)
        |> ColorWithOpacity

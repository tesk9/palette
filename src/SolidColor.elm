module SolidColor exposing
    ( SolidColor
    , fromRGB, toRGB, toRGBString
    , fromHSL, toHSL, toHSLString
    , fromHex, toHex
    , grayscale, invert, highContrast
    , blacken, whiten, grayen
    , rotateHue, addSaturation, addLightness
    , add, subtract, multiply, divide
    , luminance
    )

{-|

@docs SolidColor


## RGB

@docs fromRGB, toRGB, toRGBString


## HSL

@docs fromHSL, toHSL, toHSLString


## Hexadecimal

@docs fromHex, toHex


## Customize Colors

@docs grayscale, invert, highContrast
@docs blacken, whiten, grayen
@docs rotateHue, addSaturation, addLightness
@docs add, subtract, multiply, divide


## Helpers

@docs luminance

-}

import Dict
import Internal.Color
import Internal.HSLA
import Internal.Hex
import Internal.Opacity
import Internal.RGBA


{-| -}
type SolidColor
    = Color Internal.Color.Color


{-| Build a new color based on HSL (Hue, Saturation, and Lightness) values.

    import SolidColor exposing (SolidColor, fromHSL)

    red : SolidColor
    red =
        fromHSL ( 0, 100, 50 )

The hue is specified in degrees on the color wheel. If you pass in a hue of
`0`, `360`, or `-360`, you'll be specifying a red hue.

Saturation is a percentage value that describes "how much" of the hue is present.
Saturation clamped between 0 and 100 (inclusive). If the saturation is 0%, you'll
see gray.

Lightness is a percentage value that describes how bright the color is.
Lightness is clamped between 0 and 100 (inclusive). If the lightness is 0%, you'll
see black. If the saturation is 100%, you'll see white.

Geometrically, you can think of HSL colors as modeled on a cylinder:

![Representation of HSL values on a cylinder](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/HSL_color_solid_cylinder_saturation_gray.png/320px-HSL_color_solid_cylinder_saturation_gray.png)
[Image from the HSL and HSV article on Wikipedia](https://en.wikipedia.org/wiki/HSL_and_HSV)

-}
fromHSL : ( Float, Float, Float ) -> SolidColor
fromHSL ( hue, saturation, lightness ) =
    Color
        (Internal.Color.fromHSLA
            { hue = hue
            , saturation = saturation
            , lightness = lightness
            , alpha = Internal.Opacity.opaque
            }
        )


{-| Extract the hue, saturation, and lightness values from an existing Color.
-}
toHSL : SolidColor -> ( Float, Float, Float )
toHSL (Color color) =
    let
        { hue, saturation, lightness } =
            Internal.HSLA.toChannels (Internal.Color.asHSLA color)
    in
    ( hue, saturation, lightness )


{-| Get the HSL representation of a color as a `String`.

    import Html exposing (p, text)
    import Html.Attributes exposing (style)
    import Palette.X11 exposing (red)
    import SolidColor exposing (toHSLString)

    view =
        p [ style "color" (toHSLString red) ]
            [ text "Wow! This sure looks red!" ]

-}
toHSLString : SolidColor -> String
toHSLString (Color color) =
    Internal.HSLA.toStringWithoutOpacity
        (Internal.Color.asHSLA color)


{-| Build a new color based on RGB (red, green, blue) values.

    import SolidColor exposing (SolidColor, fromRGB)

    red : SolidColor
    red =
        fromRGB ( 255, 0, 0 )

    green : SolidColor
    green =
        fromRGB ( 0, 255, 0 )

    blue : SolidColor
    blue =
        fromRGB ( 0, 0, 255 )

This function clamps each RGB value between 0 and 255 (inclusive).

-}
fromRGB : ( Float, Float, Float ) -> SolidColor
fromRGB ( red, green, blue ) =
    Color
        (Internal.Color.fromRGBA
            { red = red
            , green = green
            , blue = blue
            , alpha = Internal.Opacity.opaque
            }
        )


{-| Extract the red, green, blue values from an existing Color.
-}
toRGB : SolidColor -> ( Float, Float, Float )
toRGB (Color color) =
    let
        { red, green, blue } =
            Internal.RGBA.toChannels (Internal.Color.asRGBA color)
    in
    ( red, green, blue )


{-| Get the RGB representation of a color as a `String`.

    import Html exposing (p, text)
    import Html.Attributes exposing (style)
    import Palette.X11 exposing (red)
    import SolidColor exposing (toRGBString)

    view =
        p [ style "color" (toRGBString red) ]
            [ text "Wow! This sure looks red!" ]

-}
toRGBString : SolidColor -> String
toRGBString (Color color) =
    Internal.RGBA.toStringWithoutOpacity (Internal.Color.asRGBA color)


{-| Build a new color from a hex string.
Supports lowercase and uppercase strings.

    (SolidColor.fromHex "#FFDD00" == SolidColor.fromHex "#FD0")
        && (SolidColor.fromHex "#FFDD00" == SolidColor.fromHex "#ffdd00")

Note: this helper will ignore transparency values.

Hexadecimal colors use the same color space as RGB colors. The difference
between the two systems is in the base: RGB colors are base 10 and hex colors are base 16.

You will need to use hex colors if you're working with an
[HTML input of type color](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color).

[Ellie colorpicker example](https://ellie-app.com/9jMtLKZztsma1)

-}
fromHex : String -> Result String SolidColor
fromHex colorString =
    case Internal.Hex.fromString colorString of
        Just { red, green, blue } ->
            Ok (fromRGB ( red, green, blue ))

        Nothing ->
            Err ("fromHex could not convert " ++ colorString ++ " to a Color.")


{-| Get the Hex representation of a color as a `String`.

    import Color exposing (toHex)
    import Html exposing (p, text)
    import Html.Attributes exposing (type_, value)
    import Palette.X11 exposing (red)

    view =
        Html.input
            [ type_ "color"
            , value (toHex red)
            ]
            []

Note: this function will always return a string in the form "#RRGGBB".
It will not return shortened values (i.e., "#RGB").

-}
toHex : SolidColor -> String
toHex color =
    let
        ( red, green, blue ) =
            toRGB color
    in
    Internal.Hex.toString
        { red = red
        , green = green
        , blue = blue
        , alpha = Internal.Opacity.opaque
        }


{-| Blends two colors together by adding the values in each RGB channel.

That is, `rgb(10, 20, 30) + rgb(10, 10, 10) = rgb(20, 30, 40)`.

As you work with RGB colors, it may also be helpful to know that this color space is **additive**.

This means that if you add red, green, and blue together, you'll end up with white. The more
colors you add, the brighter/whiter the result.

-}
add : SolidColor -> SolidColor -> SolidColor
add a c =
    let
        ( r1, g1, b1 ) =
            toRGB a

        ( r2, g2, b2 ) =
            toRGB c
    in
    fromRGB
        ( r1 + r2
        , g1 + g2
        , b1 + b2
        )


{-| Blends two colors together by subtracting the second color's channel values from
the first color's channel values.

That is, `rgb(10, 20, 30) - rgb(10, 10, 10) = rgb(0, 10, 20)`.

-}
subtract : SolidColor -> SolidColor -> SolidColor
subtract a c =
    let
        ( r1, g1, b1 ) =
            toRGB a

        ( r2, g2, b2 ) =
            toRGB c
    in
    fromRGB
        ( r1 - r2
        , g1 - g2
        , b1 - b2
        )


{-| Blend two colors together.

Any color multiplied by black will result in black.
Any color multiplied by white will result in the color.
`rgb(255, 0, 0)` will keep reds and remove any greens and blues.

-}
multiply : SolidColor -> SolidColor -> SolidColor
multiply a c =
    let
        ( r1, g1, b1 ) =
            toRGB a

        ( r2, g2, b2 ) =
            toRGB c
    in
    fromRGB
        ( r1 * r2 / 255
        , g1 * g2 / 255
        , b1 * b2 / 255
        )


{-| Blend two colors together.
-}
divide : SolidColor -> SolidColor -> SolidColor
divide a c =
    let
        ( r1, g1, b1 ) =
            toRGB a

        ( r2, g2, b2 ) =
            toRGB c

        safeDivide num denom =
            if denom == 0 then
                255

            else
                255 * (num / denom)
    in
    fromRGB
        ( safeDivide r1 r2
        , safeDivide g1 g2
        , safeDivide b1 b2
        )


{-| Luminance calculation adopted from <https://www.w3.org/TR/WCAG20-TECHS/G17.html>

Luminance describes the perceived brightness of a color. You're unlikely to need
to use this function directly.

-}
luminance : SolidColor -> Float
luminance color =
    let
        ( rRaw, gRaw, bRaw ) =
            toRGB color

        red =
            rRaw
                |> toSRBG
                |> fromSRGB

        green =
            gRaw
                |> toSRBG
                |> fromSRGB

        blue =
            bRaw
                |> toSRBG
                |> fromSRGB

        toSRBG rgb8bit =
            rgb8bit / 255

        fromSRGB srgb =
            if srgb <= 0.03928 then
                srgb / 12.92

            else
                ((srgb + 0.055) / 1.055) ^ 2.4
    in
    (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)


{-| Rotate a color's by degrees [0, 360) in the HSL color space.

Picture the color wheel. Suppose you want to find 8 evenly-spaced colors from a starting color.
You might do something like this:

    import SolidColor exposing (SolidColor)

    eightEvenColors : SolidColor -> List SolidColor
    eightEvenColors color =
        List.range 0 7
            |> List.map (\i -> SolidColor.rotateHue (toFloat i * 360 / 8) color)

[Ellie hue rotation example](https://ellie-app.com/9jMXL2Stb7Ra1)

-}
rotateHue : Float -> SolidColor -> SolidColor
rotateHue degrees (Color color) =
    Color (Internal.Color.rotateHue degrees color)


{-| Use this function to produce a new "shade" of a SolidColor. Pass in the
percentage value by which you want to darken the color.

`blacken` decreases the "lightness" of the color in the HSL color space.

    blacken : Float -> SolidColor -> SolidColor
    blacken percentage color =
        addLightness (0 - abs percentage) color

[Ellie example](https://ellie-app.com/9jN6SbV5KCqa1)

-}
blacken : Float -> SolidColor -> SolidColor
blacken percentage color =
    addLightness (0 - abs percentage) color


{-| Use this function to produce a new "tint" of a SolidColor. Pass in the
percentage value by which you want to lighten the color.

`whiten` increases the "lightness" of the color in the HSL color space.

    whiten : Float -> SolidColor -> SolidColor
    whiten percentage color =
        addLightness (abs percentage) color

[Ellie example](https://ellie-app.com/9jN6SbV5KCqa1)

-}
whiten : Float -> SolidColor -> SolidColor
whiten percentage color =
    addLightness (abs percentage) color


{-| Use this function to produce a new "tone" of a SolidColor.

`grayen` decreases the "saturation" of the color in the HSL color space.

    grayen : Float -> SolidColor -> SolidColor
    grayen percentage color =
        addSaturation (0 - abs percentage) color

[Ellie example](https://ellie-app.com/9jN6SbV5KCqa1)

-}
grayen : Float -> SolidColor -> SolidColor
grayen percentage color =
    addSaturation (0 - abs percentage) color


{-| Modify the saturation of a color in the HSL color space.

[Ellie example](https://ellie-app.com/9jN6SbV5KCqa1)

-}
addSaturation : Float -> SolidColor -> SolidColor
addSaturation percentage (Color color) =
    Color (Internal.Color.addSaturation percentage color)


{-| Modify the lightness of a color in the HSL color space.
-}
addLightness : Float -> SolidColor -> SolidColor
addLightness percentage (Color color) =
    Color (Internal.Color.addLightness percentage color)


{-| Find a high contrast color to use in concert with the passed-in color.
This function will return either black or white, whichever will be higher contrast
given the starting color.

This is often useful when working with styleguide colors.

[Ellie example](https://ellie-app.com/9jNdS7F6wrHa1)

-}
highContrast : SolidColor -> SolidColor
highContrast starting =
    if luminance starting < 0.1791 then
        addLightness 100 starting

    else
        addLightness (0 - 100) starting


{-| Use this function to invert a color. E.g., black inverted is white, white inverted is black....

[Ellie color-inversion example](https://ellie-app.com/9jNxKgPPVmga1)

-}
invert : SolidColor -> SolidColor
invert (Color color) =
    Color (Internal.Color.invert color)


{-| Convert the color you pass in to a grayscale version. This function uses the
luminance of the color you pass in to make a corresponding white <-> black value.

[Ellie grayscale example](https://ellie-app.com/9jNx7gYxQTQa1)

-}
grayscale : SolidColor -> SolidColor
grayscale color =
    let
        fromLuminance =
            luminance color * 255
    in
    ( fromLuminance, fromLuminance, fromLuminance )
        |> fromRGB

module Colour exposing
    ( Colour
    , fromRGB, fromHSL, fromHex
    , toRGBString, toHSLString
    , grayscale, invert, highContrast
    , blacken, whiten, grayen
    , rotateHue, addSaturation, addLightness
    , add, subtract, multiply, divide
    , toRGB, toHSL, toHex
    , luminance
    )

{-|


## Colours

@docs Colour
@docs fromRGB, fromHSL, fromHex


## Use Colours

@docs toRGBString, toHSLString


## Customize Colours

@docs grayscale, invert, highContrast
@docs blacken, whiten, grayen
@docs rotateHue, addSaturation, addLightness
@docs add, subtract, multiply, divide


## Helpers

@docs toRGB, toHSL, toHex

@docs luminance


## Hex values

Hexadecimal colors actually use the same color space as RGB colors. The difference
between the two systems is in the base: RGB colors are base 10 and hex colors are base 16.

You will need to use hex colors if you're working with an
[HTML input of type color](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color).

-}

import Dict
import Internal.Color
import Internal.HSLA
import Internal.Hex
import Internal.Opacity
import Internal.RGBA


{-| -}
type Colour
    = Colour Internal.Color.Color


{-| Build a new color based on HSL (Hue, Saturation, and Lightness) values.

    import Colour exposing (Colour)

    red : Colour
    red =
        Colour.fromHSL ( 0, 100, 50 )

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
(Image can be seen in context on the [HSL and HSV arcticle on Wikipedia](https://en.wikipedia.org/wiki/HSL_and_HSV). By HSL\_color\_solid\_cylinder.png: SharkDderivative work: SharkD  Talk - HSL\_color\_solid\_cylinder.png, CC BY-SA 3.0, <https://commons.wikimedia.org/w/index.php?curid=9801661>)

-}
fromHSL : ( Float, Float, Float ) -> Colour
fromHSL ( hue, saturation, lightness ) =
    Colour
        (Internal.Color.fromHSLA
            { hue = hue
            , saturation = saturation
            , lightness = lightness
            , alpha = Internal.Opacity.opaque
            }
        )


{-| Extract the hue, saturation, and lightness values from an existing Colour.
-}
toHSL : Colour -> ( Float, Float, Float )
toHSL (Colour color) =
    let
        { hue, saturation, lightness } =
            Internal.HSLA.toChannels (Internal.Color.asHSLA color)
    in
    ( hue, saturation, lightness )


{-| Get the HSL representation of a color as a `String`.

    import Colour exposing (toHSLString)
    import Html exposing (p, text)
    import Html.Attributes exposing (style)
    import Palette.X11 exposing (red)

    view =
        p [ style "color" (toHSLString red) ]
            [ text "Wow! This sure looks red!" ]

-}
toHSLString : Colour -> String
toHSLString (Colour color) =
    Internal.HSLA.toStringWithoutOpacity
        (Internal.Color.asHSLA color)


{-| Build a new color based on RGB (red, green, blue) values.

    import Colour exposing (Colour)

    red : Colour
    red =
        Colour.fromRGB ( 255, 0, 0 )

    green : Colour
    green =
        Colour.fromRGB ( 0, 255, 0 )

    blue : Colour
    blue =
        Colour.fromRGB ( 0, 0, 255 )

This function clamps each RGB value between 0 and 255 (inclusive).

-}
fromRGB : ( Float, Float, Float ) -> Colour
fromRGB ( red, green, blue ) =
    Colour
        (Internal.Color.fromRGBA
            { red = red
            , green = green
            , blue = blue
            , alpha = Internal.Opacity.opaque
            }
        )


{-| Extract the red, green, blue values from an existing Colour.
-}
toRGB : Colour -> ( Float, Float, Float )
toRGB (Colour color) =
    let
        { red, green, blue } =
            Internal.RGBA.toChannels (Internal.Color.asRGBA color)
    in
    ( red, green, blue )


{-| Get the RGB representation of a color as a `String`.

    import Colour exposing (toRGBString)
    import Html exposing (p, text)
    import Html.Attributes exposing (style)
    import Palette.X11 exposing (red)

    view =
        p [ style "color" (toRGBString red) ]
            [ text "Wow! This sure looks red!" ]

-}
toRGBString : Colour -> String
toRGBString (Colour color) =
    Internal.RGBA.toStringWithoutOpacity (Internal.Color.asRGBA color)


{-| Build a new color from a hex string.
Supports lowercase and uppercase strings.

    (Colour.fromHex "#FFDD00" == Colour.fromHex "#FD0")
        && (Colour.fromHex "#FFDD00" == Colour.fromHex "#ffdd00")

Note: this helper will ignore transparency values.

-}
fromHex : String -> Result String Colour
fromHex colorString =
    case Internal.Hex.fromString colorString of
        Just { red, green, blue } ->
            Ok (fromRGB ( red, green, blue ))

        Nothing ->
            Err ("fromHex could not convert " ++ colorString ++ " to a Colour.")


{-| Get the Hex representation of a color as a `String`.

    import Colour exposing (toHex)
    import Html exposing (p, text)
    import Html.Attributes exposing (type_, value)
    import Palette.X11 exposing (red)

    view =
        Html.input
            [ type_ "color"
            , value (toHex red)
            ]
            []

Note: this function will always return a string in either the form "#RRGGBB".
It will not return shortened values (i.e., "#RGB").

If you want or need this functionality, please make an issue for it on the
github repo for this library.

-}
toHex : Colour -> String
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
add : Colour -> Colour -> Colour
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
subtract : Colour -> Colour -> Colour
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
multiply : Colour -> Colour -> Colour
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

Use this function to strip out tones & change them to white.

-}
divide : Colour -> Colour -> Colour
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
to use this function directly

-}
luminance : Colour -> Float
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


{-| Rotate a color by degrees [0, 360).

Picture the color wheel. Suppose you want to find 8 evenly-spaced colors from a starting color.
You might do something like this:

    import Colour

    eightEvenColors : Colour -> List Colour
    eightEvenColors color =
        List.range 0 7
            |> List.map (\i -> Colour.rotateHue (toFloat i * 360 / 8) color)

-}
rotateHue : Float -> Colour -> Colour
rotateHue degrees (Colour color) =
    Colour (Internal.Color.rotateHue degrees color)


{-| Use this function to produce a new "shade" of the Colour. Pass in the
percentage value by which you want to darken the color.

Essentially, `blacken` works by decreasing the "lightness" of the color in the
HSL color space.

    blacken : Float -> Colour -> Colour
    blacken percentage color =
        addLightness (0 - abs percentage) color

-}
blacken : Float -> Colour -> Colour
blacken percentage color =
    addLightness (0 - abs percentage) color


{-| Use this function to produce a new "tint" of the Colour. Pass in the
percentage value by which you want to lighten the color.

Essentially, `whiten` works by increasing the "lightness" of the color in the
HSL color space.

    whiten : Float -> Colour -> Colour
    whiten percentage color =
        addLightness (abs percentage) color

-}
whiten : Float -> Colour -> Colour
whiten percentage color =
    addLightness (abs percentage) color


{-| Use this function to produce a new "tone" of the Colour.

Essentially, this means decreasing the "saturation" of the color in the HSL
color space.

    grayen : Float -> Colour -> Colour
    grayen percentage color =
        addSaturation (0 - abs percentage) color

-}
grayen : Float -> Colour -> Colour
grayen percentage color =
    addSaturation (0 - abs percentage) color


{-| Modify the saturation of a color in the HSL color space.
-}
addSaturation : Float -> Colour -> Colour
addSaturation percentage (Colour color) =
    Colour (Internal.Color.addSaturation percentage color)


{-| Modify the lightness of a color in the HSL color space.
-}
addLightness : Float -> Colour -> Colour
addLightness percentage (Colour color) =
    Colour (Internal.Color.addLightness percentage color)


{-| Find a high contrast color to use in concert with the passed-in color.
This function will return either black or white, whichever will be higher contrast
given the starting color.

This is often useful when working with styleguide colors.

-}
highContrast : Colour -> Colour
highContrast starting =
    if luminance starting < 0.1791 then
        addLightness 100 starting

    else
        addLightness (0 - 100) starting


{-| Use this function to invert a color. E.g., black inverted is white, white inverted is black....
-}
invert : Colour -> Colour
invert (Colour color) =
    Colour (Internal.Color.invert color)


{-| Convert the color you pass in to a grayscale version. Essentially this uses the
luminance of the color you pass in to make a corresponding white <-> black value.
-}
grayscale : Colour -> Colour
grayscale color =
    let
        fromLuminance =
            luminance color * 255
    in
    ( fromLuminance, fromLuminance, fromLuminance )
        |> fromRGB

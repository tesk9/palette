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

-}

import Dict
import Internal.Colour
import Internal.HSLA
import Internal.Hex
import Internal.Opacity
import Internal.RGBA


{-| -}
type Colour
    = Colour Internal.Colour.Colour


{-| Build a new colour based on HSL (Hue, Saturation, and Lightness) values.

    import Colour exposing (Colour)

    red : Colour
    red =
        Colour.fromHSL ( 0, 100, 50 )

The hue is specified in degrees on the colour wheel. If you pass in a hue of
`0`, `360`, or `-360`, you'll be specifying a red hue.

Saturation is a percentage value that describes "how much" of the hue is present.
Saturation clamped between 0 and 100 (inclusive). If the saturation is 0%, you'll
see gray.

Lightness is a percentage value that describes how bright the colour is.
Lightness is clamped between 0 and 100 (inclusive). If the lightness is 0%, you'll
see black. If the saturation is 100%, you'll see white.

Geometrically, you can think of HSL colours as modeled on a cylinder:

![Representation of HSL values on a cylinder](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/HSL_colour_solid_cylinder_saturation_gray.png/320px-HSL_colour_solid_cylinder_saturation_gray.png)
[Image from the HSL and HSV article on Wikipedia](https://en.wikipedia.org/wiki/HSL_and_HSV)

-}
fromHSL : ( Float, Float, Float ) -> Colour
fromHSL ( hue, saturation, lightness ) =
    Colour
        (Internal.Colour.fromHSLA
            { hue = hue
            , saturation = saturation
            , lightness = lightness
            , alpha = Internal.Opacity.opaque
            }
        )


{-| Extract the hue, saturation, and lightness values from an existing Colour.
-}
toHSL : Colour -> ( Float, Float, Float )
toHSL (Colour colour) =
    let
        { hue, saturation, lightness } =
            Internal.HSLA.toChannels (Internal.Colour.asHSLA colour)
    in
    ( hue, saturation, lightness )


{-| Get the HSL representation of a colour as a `String`.

    import Colour exposing (toHSLString)
    import Html exposing (p, text)
    import Html.Attributes exposing (style)
    import Palette.X11 exposing (red)

    view =
        p [ style "color" (toHSLString red) ]
            [ text "Wow! This sure looks red!" ]

-}
toHSLString : Colour -> String
toHSLString (Colour colour) =
    Internal.HSLA.toStringWithoutOpacity
        (Internal.Colour.asHSLA colour)


{-| Build a new colour based on RGB (red, green, blue) values.

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
        (Internal.Colour.fromRGBA
            { red = red
            , green = green
            , blue = blue
            , alpha = Internal.Opacity.opaque
            }
        )


{-| Extract the red, green, blue values from an existing Colour.
-}
toRGB : Colour -> ( Float, Float, Float )
toRGB (Colour colour) =
    let
        { red, green, blue } =
            Internal.RGBA.toChannels (Internal.Colour.asRGBA colour)
    in
    ( red, green, blue )


{-| Get the RGB representation of a colour as a `String`.

    import Colour exposing (toRGBString)
    import Html exposing (p, text)
    import Html.Attributes exposing (style)
    import Palette.X11 exposing (red)

    view =
        p [ style "color" (toRGBString red) ]
            [ text "Wow! This sure looks red!" ]

-}
toRGBString : Colour -> String
toRGBString (Colour colour) =
    Internal.RGBA.toStringWithoutOpacity (Internal.Colour.asRGBA colour)


{-| Build a new colour from a hex string.
Supports lowercase and uppercase strings.

    (Colour.fromHex "#FFDD00" == Colour.fromHex "#FD0")
        && (Colour.fromHex "#FFDD00" == Colour.fromHex "#ffdd00")

Note: this helper will ignore transparency values.

Hexadecimal colours use the same colour space as RGB colours. The difference
between the two systems is in the base: RGB colours are base 10 and hex colours are base 16.

You will need to use hex colours if you're working with an
[HTML input of type colour](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/colour).

-}
fromHex : String -> Result String Colour
fromHex colourString =
    case Internal.Hex.fromString colourString of
        Just { red, green, blue } ->
            Ok (fromRGB ( red, green, blue ))

        Nothing ->
            Err ("fromHex could not convert " ++ colourString ++ " to a Colour.")


{-| Get the Hex representation of a colour as a `String`.

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

Note: this function will always return a string in the form "#RRGGBB".
It will not return shortened values (i.e., "#RGB").

-}
toHex : Colour -> String
toHex colour =
    let
        ( red, green, blue ) =
            toRGB colour
    in
    Internal.Hex.toString
        { red = red
        , green = green
        , blue = blue
        , alpha = Internal.Opacity.opaque
        }


{-| Blends two colours together by adding the values in each RGB channel.

That is, `rgb(10, 20, 30) + rgb(10, 10, 10) = rgb(20, 30, 40)`.

As you work with RGB colours, it may also be helpful to know that this colour space is **additive**.

This means that if you add red, green, and blue together, you'll end up with white. The more
colours you add, the brighter/whiter the result.

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


{-| Blends two colours together by subtracting the second colour's channel values from
the first colour's channel values.

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


{-| Blend two colours together.

Any colour multiplied by black will result in black.
Any colour multiplied by white will result in the colour.
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


{-| Blend two colours together.
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

Luminance describes the perceived brightness of a colour. You're unlikely to need
to use this function directly.

-}
luminance : Colour -> Float
luminance colour =
    let
        ( rRaw, gRaw, bRaw ) =
            toRGB colour

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


{-| Rotate a colour's by degrees [0, 360) in the HSL colour space.

Picture the colour wheel. Suppose you want to find 8 evenly-spaced colours from a starting colour.
You might do something like this:

    import Colour

    eightEvenColours : Colour -> List Colour
    eightEvenColours colour =
        List.range 0 7
            |> List.map (\i -> Colour.rotateHue (toFloat i * 360 / 8) colour)

-}
rotateHue : Float -> Colour -> Colour
rotateHue degrees (Colour colour) =
    Colour (Internal.Colour.rotateHue degrees colour)


{-| Use this function to produce a new "shade" of the Colour. Pass in the
percentage value by which you want to darken the colour.

`blacken` increases the "lightness" of the colour in the HSL colour space.

    blacken : Float -> Colour -> Colour
    blacken percentage colour =
        addLightness (0 - abs percentage) colour

-}
blacken : Float -> Colour -> Colour
blacken percentage colour =
    addLightness (0 - abs percentage) colour


{-| Use this function to produce a new "tint" of the Colour. Pass in the
percentage value by which you want to lighten the colour.

`whiten` increases the "lightness" of the colour in the HSL colour space.

    whiten : Float -> Colour -> Colour
    whiten percentage colour =
        addLightness (abs percentage) colour

-}
whiten : Float -> Colour -> Colour
whiten percentage colour =
    addLightness (abs percentage) colour


{-| Use this function to produce a new "tone" of the Colour.

`grayen` decreases the "saturation" of the colour in the HSL colour space.

    grayen : Float -> Colour -> Colour
    grayen percentage colour =
        addSaturation (0 - abs percentage) colour

-}
grayen : Float -> Colour -> Colour
grayen percentage colour =
    addSaturation (0 - abs percentage) colour


{-| Modify the saturation of a colour in the HSL colour space.
-}
addSaturation : Float -> Colour -> Colour
addSaturation percentage (Colour colour) =
    Colour (Internal.Colour.addSaturation percentage colour)


{-| Modify the lightness of a colour in the HSL colour space.
-}
addLightness : Float -> Colour -> Colour
addLightness percentage (Colour colour) =
    Colour (Internal.Colour.addLightness percentage colour)


{-| Find a high contrast colour to use in concert with the passed-in colour.
This function will return either black or white, whichever will be higher contrast
given the starting colour.

This is often useful when working with styleguide colours.

-}
highContrast : Colour -> Colour
highContrast starting =
    if luminance starting < 0.1791 then
        addLightness 100 starting

    else
        addLightness (0 - 100) starting


{-| Use this function to invert a colour. E.g., black inverted is white, white inverted is black....
-}
invert : Colour -> Colour
invert (Colour colour) =
    Colour (Internal.Colour.invert colour)


{-| Convert the colour you pass in to a grayscale version. This function uses the
luminance of the colour you pass in to make a corresponding white <-> black value.
-}
grayscale : Colour -> Colour
grayscale colour =
    let
        fromLuminance =
            luminance colour * 255
    in
    ( fromLuminance, fromLuminance, fromLuminance )
        |> fromRGB

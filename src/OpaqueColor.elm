module OpaqueColor exposing
    ( OpaqueColor
    , fromHSL, toHSL, toHSLString, toHSLAString
    , fromRGB, toRGB, toRGBString, toRGBAString
    , fromHexString, toHexString, toHexAString
    , add, subtract, multiply, divide
    , equals
    , WCAGLevel(..), sufficientContrast, contrast
    , luminance
    , rotate
    , highContrast
    , shade, tint, tone
    , grayscale, invert
    , adjustSaturation, adjustLightness
    )

{-|

@docs OpaqueColor


## HSL values

HSL is short for hue, saturation, and lightness (or luminosity, or random other
L words depending on who you ask. Think "brightness", and you'll be on the right track).

You may be intuitively familiar with HSL color modeling if you've worked with a
color wheel before. It also may be a great place to start working with color if
you enjoyed playing with unit circles and polar coordinates in trigonometry.

![Representation of HSL values on a cylinder](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/HSL_color_solid_cylinder_saturation_gray.png/320px-HSL_color_solid_cylinder_saturation_gray.png)
(Image can be seen in context on the [HSL and HSV arcticle on Wikipedia](https://en.wikipedia.org/wiki/HSL_and_HSV). By HSL\_color\_solid\_cylinder.png: SharkDderivative work: SharkD  Talk - HSL\_color\_solid\_cylinder.png, CC BY-SA 3.0, <https://commons.wikimedia.org/w/index.php?curid=9801661>)

HSL models **hue** as a value on a circle. We can pick a hue by providing a degree.
We start at red -- meaning that we can get to red by saying that our hue is 0 degrees or
by saying that our hue is at 360 degrees. Green is at 90, teal is at 180, and
there's a lovely purple at 270.

**Saturation** is how much of the hue is present. When you see a hue of 0 degrees,
a saturation of 100%, and lightness of 50%, your reaction is going to be "Schnickeys! that's red!"
If you change the saturation to 0%, you'll see gray.

**Lightness** is brightness -- 100% is white and 0% is black.

@docs fromHSL, toHSL, toHSLString, toHSLAString


## RGB values

RGB is short for red-green-blue. This representation of color specifies how much
red, green, and blue are in the color.

I found [this chart](https://en.wikipedia.org/wiki/HSL_and_HSV#/media/File:HSV-RGB-comparison.svg) really
helpful when thinking about how RGB colors work -- it shows red, green, and blue values as piecewise functions
against Hue values. The chart is actually aimed at describing the HSV color space, which is a little
different than the HSL color space, but it may be helpful for your brain too.

As you work with RGB colors, it may also be helpful to know that this color space is **additive**.

This means that if you add red, green, and blue together, you'll end up with white. The more
colors you add, the brighter the result.

This is different than what you may remember from painting in elementary school.
Paint, where you're mixing pigments together, is a **subtractive**
color space. Printing (CMYK color space) is also subtractive.

@docs fromRGB, toRGB, toRGBString, toRGBAString


## Hex values

Hexadecimal colors actually use the same color space as RGB colors. The difference
between the two systems is in the base: RGB colors are base 10 and hex colors are base 16.

You will need to use hex colors if you're working with an
[HTML input of type color](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color).

@docs fromHexString, toHexString, toHexAString


## OpaqueColor blending

@docs add, subtract, multiply, divide


## Equality

@docs equals


## Contrast, Luminance, and Accessibility

@docs WCAGLevel, sufficientContrast, contrast
@docs luminance


## Modify an OpaqueColor

@docs rotate
@docs highContrast
@docs shade, tint, tone
@docs grayscale, invert
@docs adjustSaturation, adjustLightness

-}

import Dict
import Internal.Color
import Internal.HSLA
import Internal.Hex
import Internal.RGBA
import Opacity exposing (Opacity)


{-| -}
type OpaqueColor
    = OpaqueColor Internal.Color.Color


{-| Build a new color based on HSL values.

    import OpaqueColor exposing (OpaqueColor)

    red : OpaqueColor
    red =
        OpaqueColor.fromHSL ( 0, 100, 50 )

The hue is specified in degrees, and uses modular arithmetic such that whether you
pass in `0`, `360`, or `-360`, you'll still end up with a red hue.

Saturation is a percentage value. It's clamped between 0 and 100 (inclusive).
Lightness is a percentage value. It's clamped between 0 and 100 (inclusive).

-}
fromHSL : ( Float, Float, Float ) -> OpaqueColor
fromHSL ( hue, saturation, lightness ) =
    OpaqueColor
        (Internal.Color.fromHSLA
            { hue = hue
            , saturation = saturation
            , lightness = lightness
            , alpha = Opacity.opaque
            }
        )


{-| Extract the hue, saturation, and lightness values from an existing OpaqueColor.
-}
toHSL : OpaqueColor -> ( Float, Float, Float )
toHSL (OpaqueColor color) =
    let
        { hue, saturation, lightness } =
            Internal.HSLA.toChannels (Internal.Color.asHSLA color)
    in
    ( hue, saturation, lightness )


{-| Get the HSL representation of a color as a `String`.

    import Html exposing (p, text)
    import Html.Attributes exposing (style)
    import OpaqueColor exposing (toHSLString)
    import Palette.X11 exposing (red)

    view =
        p [ style "color" (toHSLString red) ]
            [ text "Wow! This sure looks red!" ]

-}
toHSLString : OpaqueColor -> String
toHSLString (OpaqueColor color) =
    Internal.HSLA.toStringWithoutOpacity
        (Internal.Color.asHSLA color)


{-| -}
toHSLAString : OpaqueColor -> String
toHSLAString (OpaqueColor color) =
    Internal.HSLA.toStringWithOpacity (Internal.Color.asHSLA color)


{-| Build a new color based on RGB values.

    import OpaqueColor exposing (OpaqueColor)

    red : OpaqueColor
    red =
        OpaqueColor.fromRGB ( 255, 0, 0 )

    green : OpaqueColor
    green =
        OpaqueColor.fromRGB ( 0, 255, 0 )

    blue : OpaqueColor
    blue =
        OpaqueColor.fromRGB ( 0, 0, 255 )

This function clamps each rgb value between 0 and 255 (inclusive).

-}
fromRGB : ( Float, Float, Float ) -> OpaqueColor
fromRGB ( red, green, blue ) =
    OpaqueColor
        (Internal.Color.fromRGBA
            { red = red
            , green = green
            , blue = blue
            , alpha = Opacity.opaque
            }
        )


{-| Extract the red, green, blue values from an existing OpaqueColor.
-}
toRGB : OpaqueColor -> ( Float, Float, Float )
toRGB (OpaqueColor color) =
    let
        { red, green, blue } =
            Internal.RGBA.toChannels (Internal.Color.asRGBA color)
    in
    ( red, green, blue )


{-| Get the RGB representation of a color as a `String`.

    import Html exposing (p, text)
    import Html.Attributes exposing (style)
    import OpaqueColor exposing (toRGBString)
    import Palette.X11 exposing (red)

    view =
        p [ style "color" (toRGBString red) ]
            [ text "Wow! This sure looks red!" ]

-}
toRGBString : OpaqueColor -> String
toRGBString (OpaqueColor color) =
    Internal.RGBA.toStringWithoutOpacity (Internal.Color.asRGBA color)


{-| -}
toRGBAString : OpaqueColor -> String
toRGBAString (OpaqueColor color) =
    Internal.RGBA.toStringWithOpacity (Internal.Color.asRGBA color)


{-| Build a new color from a hex string.
Supports lowercase and uppercase strings.

    (OpaqueColor.fromHexString "#FFDD00" == OpaqueColor.fromHexString "#FD0")
        && (OpaqueColor.fromHexString "#FFDD00" == OpaqueColor.fromHexString "#ffdd00")

Note: this helper will ignore transparency values.

-}
fromHexString : String -> Result String OpaqueColor
fromHexString colorString =
    case Internal.Hex.fromString colorString of
        Just { red, green, blue } ->
            Ok (fromRGB ( red, green, blue ))

        Nothing ->
            Err ("fromHexString could not convert " ++ colorString ++ " to a OpaqueColor.")


{-| Get the Hex representation of a color as a `String`.

    import Html exposing (p, text)
    import Html.Attributes exposing (type_, value)
    import OpaqueColor exposing (toHexString)
    import Palette.X11 exposing (red)

    view =
        Html.input
            [ type_ "color"
            , value (toHexString red)
            ]
            []

Note: this function will always return a string in either the form "#RRGGBB".
It will not return shortened values (i.e., "#RGB").

If you want or need this functionality, please make an issue for it on the
github repo for this library.

-}
toHexString : OpaqueColor -> String
toHexString color =
    let
        ( red, green, blue ) =
            toRGB color
    in
    Internal.Hex.toString
        { red = red
        , green = green
        , blue = blue
        , alpha = Opacity.opaque
        }


{-| Get the Hex representation of a color as a `String`.

    import Html exposing (p, text)
    import Html.Attributes exposing (type_, value)
    import OpaqueColor exposing (toHexString)
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
toHexAString : OpaqueColor -> String
toHexAString (OpaqueColor color) =
    Internal.Hex.toString (Internal.Color.asHex color)


{-| Check two colors for equality.
-}
equals : OpaqueColor -> OpaqueColor -> Bool
equals a b =
    toRGB a == toRGB b


{-| Blends two colors together by adding the values in each channel.

That is, `rgb(10, 20, 30) + rgb(10, 10, 10) = rgb(20, 30, 40)`.

Play with an example in Ellie here: <https://ellie-app.com/3yLdpDs9NBya1>.

-}
add : OpaqueColor -> OpaqueColor -> OpaqueColor
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

Play with an example in Ellie here: <https://ellie-app.com/3yLftQKkL6Ga1>.

-}
subtract : OpaqueColor -> OpaqueColor -> OpaqueColor
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

Play with an example in Ellie here: <https://ellie-app.com/3yLgG6JQCgHa1>.

-}
multiply : OpaqueColor -> OpaqueColor -> OpaqueColor
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

Play with an example in Ellie here: <https://ellie-app.com/3yLhRLkJPwTa1>

-}
divide : OpaqueColor -> OpaqueColor -> OpaqueColor
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


{-| Read more about levels of conformance at [WCAG](https://www.w3.org/TR/UNDERSTANDING-WCAG20/conformance.html#uc-levels-head).
-}
type WCAGLevel
    = AA
    | AAA


{-| For a given WCAG level, calculate whether two colors have enough contrast
with each other to be used together (e.g., as a background and text color combination).

To meet AA level sufficiently, [follow these standards](https://www.w3.org/WAI/WCAG21/quickref/?versions=2.0&showtechniques=143%2C146#contrast-minimum).
To meet AAA level sufficiently, [follow these standards](https://www.w3.org/WAI/WCAG21/quickref/?versions=2.0&showtechniques=143%2C146#contrast-enhanced).

TODO (consider this a headsup on likely API changes!):

  - Use named fontweights rather than numbers
  - Wrap fontsize with some constructors
  - Cassowary constraint solving..?

See an example here: <https://ellie-app.com/3CgJZNMyxw3a1>.

-}
sufficientContrast : WCAGLevel -> { fontSize : Float, fontWeight : Int } -> OpaqueColor -> OpaqueColor -> Bool
sufficientContrast wcagLevel { fontSize, fontWeight } color1 color2 =
    let
        colorContrast =
            contrast color1 color2
    in
    case wcagLevel of
        AA ->
            if (fontSize > 14 && fontWeight >= 700) || fontSize > 18 then
                colorContrast >= 3

            else
                colorContrast >= 4.5

        AAA ->
            if (fontSize > 14 && fontWeight >= 700) || fontSize > 18 then
                colorContrast >= 4.5

            else
                colorContrast >= 7


{-| Calculate the contrast between two colors.

See an example here: <https://ellie-app.com/3CgJZNMyxw3a1>.

-}
contrast : OpaqueColor -> OpaqueColor -> Float
contrast color1 color2 =
    let
        luminance1 =
            luminance color1

        luminance2 =
            luminance color2
    in
    if luminance1 > luminance2 then
        (luminance1 + 0.05) / (luminance2 + 0.05)

    else
        (luminance2 + 0.05) / (luminance1 + 0.05)


{-| Luminance calculation adopted from <https://www.w3.org/TR/WCAG20-TECHS/G17.html>

Luminance describes the perceived brightness of a color. You're unlikely to need
to use this function directly

-}
luminance : OpaqueColor -> Float
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

    import OpaqueColor

    eightEvenColors : OpaqueColor -> List OpaqueColor
    eightEvenColors color =
        List.range 0 7
            |> List.map (\i -> OpaqueColor.rotate (toFloat i * 360 / 8) color)

Check out this code on Ellie here: <https://ellie-app.com/3CRfDs2HLvGa1>.

-}
rotate : Float -> OpaqueColor -> OpaqueColor
rotate degrees color =
    toHSL color
        |> (\( h, s, l ) -> ( h + degrees, s, l ))
        |> fromHSL


{-| Use this function to produce a new shade of the OpaqueColor.
Note: shades will be darker than the starting color. If you want a lighter color,
please see `tint`.

Pass in the percentage value by which you want to darken the color.

-}
shade : Float -> OpaqueColor -> OpaqueColor
shade percentage color =
    adjustLightness (0 - abs percentage) color


{-| Use this function to produce a new tint of the OpaqueColor.
Note: tints will be lighter than the starting color. If you want a darker color,
please see `shade`.

Pass in the percentage value by which you want to lighten the color.

-}
tint : Float -> OpaqueColor -> OpaqueColor
tint percentage color =
    adjustLightness (abs percentage) color


{-| Use this function to produce a new tone of the OpaqueColor.

Essentially this means adding grays to the color you pass in. It's implemented,
though, by adjusting the saturation of the color. You can pass in a positive or
negative percentage value.

-}
tone : Float -> OpaqueColor -> OpaqueColor
tone percentage color =
    adjustSaturation percentage color


{-| Modify the saturation of a color (see notes on HSL color space).
-}
adjustSaturation : Float -> OpaqueColor -> OpaqueColor
adjustSaturation percentage color =
    toHSL color
        |> (\( h, s, l ) -> ( h, s + percentage, l ))
        |> fromHSL


{-| Modify the lightness of a color (see notes on HSL color space).
-}
adjustLightness : Float -> OpaqueColor -> OpaqueColor
adjustLightness percentage color =
    toHSL color
        |> (\( h, s, l ) -> ( h, s, l + percentage ))
        |> fromHSL


{-| Find a high contrast color to use in concert with the passed-in color.
This funciton will return either black or white, whichever will be higher contrast
given the starter color.

This is most useful when working with styleguide colors. It will not produce
particularly visually pleasing results, but they will be consistent and readable.

-}
highContrast : OpaqueColor -> OpaqueColor
highContrast starting =
    if luminance starting < 0.1791 then
        adjustLightness 100 starting

    else
        adjustLightness (0 - 100) starting


{-| Use this function to invert a color. E.g., black inverted is white, white inverted is black....
-}
invert : OpaqueColor -> OpaqueColor
invert color =
    let
        ( r, g, b ) =
            toRGB color
    in
    fromRGB ( 255 - r, 255 - g, 255 - b )


{-| Convert the color you pass in to a grayscale version. Essentially this uses the
luminance of the color you pass in to make a corresponding white <-> black value.
-}
grayscale : OpaqueColor -> OpaqueColor
grayscale color =
    let
        fromLuminance =
            luminance color * 255
    in
    ( fromLuminance, fromLuminance, fromLuminance )
        |> fromRGB

module OpaqueColor.Generator exposing
    ( complementary, triadic, splitComplementary, square, tetratic
    , monochromatic
    , highContrast
    , shade, tint, tone
    , grayscale, invert
    , rotate, adjustSaturation, adjustLightness
    )

{-|


## Palette

Generate a palette based on a starting color.


### By Hue

@docs complementary, triadic, splitComplementary, square, tetratic


### By Lightness

@docs monochromatic


### By contrast

@docs highContrast


## Modify a OpaqueColor

@docs shade, tint, tone
@docs grayscale, invert
@docs rotate, adjustSaturation, adjustLightness

-}

import Opacity exposing (Opacity)
import OpaqueColor exposing (OpaqueColor)


{-| Rotate a color by degrees [0, 360).

Picture the color wheel. Suppose you want to find 8 evenly-spaced colors from a starting color.
You might do something like this:

    import OpaqueColor
    import OpaqueColor.Generator

    eightEvenColors : OpaqueColor -> List OpaqueColor
    eightEvenColors color =
        List.range 0 7
            |> List.map (\i -> OpaqueColor.Generator.rotate (toFloat i * 360 / 8) color)

Check out this code on Ellie here: <https://ellie-app.com/3CRfDs2HLvGa1>.

-}
rotate : Float -> OpaqueColor -> OpaqueColor
rotate degrees color =
    OpaqueColor.toHSL color
        |> (\( h, s, l ) -> ( h + degrees, s, l ))
        |> OpaqueColor.fromHSL


{-| Find the color opposite the color you pass in on the color wheel.

E.g., if you pass in a reddish color, you should expect to get back a tealish color.

-}
complementary : OpaqueColor -> OpaqueColor
complementary color =
    rotate 180 color


{-| Find the other two colors in the triadic scheme defined by the color passed in.

Triadic color schemes are evenly-spaced, so each of the three colors is 120 degrees
from the others.

The internet says this scheme will be vibrant, and that you should
mostly use one of the three colors and only use the other two for accents.

-}
triadic : OpaqueColor -> ( OpaqueColor, OpaqueColor )
triadic color =
    splitComplementary 120 color


{-| Build a three-color scheme by rotating the same amount from the initial color
in both directions.

`triadic`, the evenly-spaced 3-color scheme, can be defined in terms of this function:

    triadic color =
        splitComplementary 120 color

Initial rotation is clamped between 0 and 180.

-}
splitComplementary : Float -> OpaqueColor -> ( OpaqueColor, OpaqueColor )
splitComplementary r color =
    let
        rotation =
            clamp 0 180 r
    in
    ( rotate rotation color, rotate (0 - rotation) color )


{-| Find four equally-spaced colors along the color wheel starting from the passed-in color.
-}
square : OpaqueColor -> ( OpaqueColor, OpaqueColor, OpaqueColor )
square color =
    tetratic 60 color


{-| Find four colors along the color wheel starting from the passed-in color.

This differs from the `square` helper in that our values aren't equally spaced --
we are selecting colors on the color wheel with a rectangle. We can actually define
`square` in terms of this function as follows:

    square color =
        tetratic 60 color

We'll rotate the number of degrees passed in along the color wheel to find our first
color. Then we'll rotate the "length" of the rectangle -- as much as we need to in order
to make it all the way around.

Initial rotation is clamped between 0 and 180.

-}
tetratic : Float -> OpaqueColor -> ( OpaqueColor, OpaqueColor, OpaqueColor )
tetratic w color =
    let
        width =
            clamp 0 180 w

        length =
            (360 - 2 * width) / 2
    in
    ( rotate width color, rotate (width + length) color, rotate (2 * width + length) color )


{-| Create a monochromatic palette. The `Float` argument is size of the Lightness
steps that you'd like in the palette.

If you wanted a grayscale palette, and you wanted it to have five colors, you could do
something like this:

    grayscalePalette =
        monochromatic 20 black

Colors will be arranged from darkest to lightest.

-}
monochromatic : Float -> OpaqueColor -> List OpaqueColor
monochromatic stepSize color =
    let
        getNextStep adjustment lastColor colors =
            let
                nextLightness =
                    OpaqueColor.toHSL lastColor
                        |> (\( _, _, lightness ) -> lightness + adjustment)
            in
            if nextLightness <= 0 || nextLightness >= 100 then
                lastColor :: colors

            else
                getNextStep adjustment (adjustLightness adjustment lastColor) (lastColor :: colors)
    in
    case List.reverse (getNextStep stepSize color []) of
        startingColor :: tints ->
            getNextStep (0 - stepSize) color [] ++ tints

        [] ->
            []


{-| Use this function to invert a color. E.g., black inverted is white, white inverted is black....
-}
invert : OpaqueColor -> OpaqueColor
invert color =
    let
        ( r, g, b ) =
            OpaqueColor.toRGB color
    in
    OpaqueColor.fromRGB ( 255 - r, 255 - g, 255 - b )


{-| Convert the color you pass in to a grayscale version. Essentially this uses the
luminance of the color you pass in to make a corresponding white <-> black value.
-}
grayscale : OpaqueColor -> OpaqueColor
grayscale color =
    let
        fromLuminance =
            OpaqueColor.luminance color * 255
    in
    ( fromLuminance, fromLuminance, fromLuminance )
        |> OpaqueColor.fromRGB


{-| Find a high contrast color to use in concert with the passed-in color.
This funciton will return either black or white, whichever will be higher contrast
given the starter color.

This is most useful when working with styleguide colors. It will not produce
particularly visually pleasing results, but they will be consistent and readable.

-}
highContrast : OpaqueColor -> OpaqueColor
highContrast starting =
    if OpaqueColor.luminance starting < 0.1791 then
        adjustLightness 100 starting

    else
        adjustLightness (0 - 100) starting


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
    OpaqueColor.toHSL color
        |> (\( h, s, l ) -> ( h, s + percentage, l ))
        |> OpaqueColor.fromHSL


{-| Modify the lightness of a color (see notes on HSL color space).
-}
adjustLightness : Float -> OpaqueColor -> OpaqueColor
adjustLightness percentage color =
    OpaqueColor.toHSL color
        |> (\( h, s, l ) -> ( h, s, l + percentage ))
        |> OpaqueColor.fromHSL

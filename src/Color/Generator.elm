module Color.Generator exposing
    ( complementary, triadic, splitComplementary, square, tetratic, monochromatic
    , shade, tint, tone
    , grayscale
    , rotate, adjustLightness
    , add, subtract, multiply, divide
    )

{-|


## Palette

Generate a palette based on a starting color.

@docs complementary, triadic, splitComplementary, square, tetratic, monochromatic


## Modify a Color

@docs shade, tint, tone
@docs grayscale
@docs rotate, adjustLightness


### Blend

@docs add, subtract, multiply, divide

-}

import Color exposing (Color)


{-| Rotate a color by degrees [0, 360).
-}
rotate : Float -> Color -> Color
rotate degrees color =
    Color.toHSL color
        |> (\( h, s, l ) -> ( h + degrees, s, l ))
        |> Color.fromHSL


{-| Find the color opposite the color you pass in on the color wheel.

E.g., if you pass in a reddish color, you should expect to get back a tealish color.

-}
complementary : Color -> Color
complementary color =
    rotate 180 color


{-| Find the other two colors in the triadic scheme defined by the color passed in.

Triadic color schemes are evenly-spaced, so each of the three colors is 120 degrees
from the others.

The internet says this scheme will be vibrant, and that you should
mostly use one of the three colors and only use the other two for accents.

-}
triadic : Color -> ( Color, Color )
triadic color =
    splitComplementary 120 color


{-| Build a three-color scheme by rotating the same amount from the initial color
in both directions.

`triadic`, the evenly-spaced 3-color scheme, can be defined in terms of this function:

    triadic color =
        splitComplementary 120 color

Initial rotation is clamped between 0 and 180.

-}
splitComplementary : Float -> Color -> ( Color, Color )
splitComplementary r color =
    let
        rotation =
            clamp 0 180 r
    in
    ( rotate rotation color, rotate (0 - rotation) color )


{-| Find four equally-spaced colors along the color wheel starting from the passed-in color.
-}
square : Color -> ( Color, Color, Color )
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
tetratic : Float -> Color -> ( Color, Color, Color )
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
monochromatic : Float -> Color -> List Color
monochromatic stepSize color =
    let
        getNextStep adjustment lastColor colors =
            let
                nextLightness =
                    Color.toHSL lastColor
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


{-| Convert the color you pass in to a grayscale version. Essentially this uses the
luminance of the color you pass in to make a corresponding white <-> black value.
-}
grayscale : Color -> Color
grayscale color =
    let
        fromLuminance =
            Color.luminance color * 255
    in
    ( fromLuminance, fromLuminance, fromLuminance )
        |> Color.fromRGB


{-| Modify the lightness of a color (see notes on HSL color space).
-}
adjustLightness : Float -> Color -> Color
adjustLightness percentage color =
    Color.toHSL color
        |> (\( h, s, l ) -> ( h, s, l + percentage ))
        |> Color.fromHSL


{-| Blends two colors together by adding the values in each channel.

That is, rgb(10, 20, 30) + rgb(10, 10, 10) = rgb(20, 30, 40).

-}
add : Color -> Color -> Color
add a c =
    let
        ( r1, g1, b1 ) =
            Color.toRGB a

        ( r2, g2, b2 ) =
            Color.toRGB c
    in
    Color.fromRGB
        ( r1 + r2
        , g1 + g2
        , b1 + b2
        )


{-| Blends two colors together by subtracting the second color's channel values from
the first color's channel values.

That is, rgb(10, 20, 30) - rgb(10, 10, 10) = rgb(0, 10, 20).

-}
subtract : Color -> Color -> Color
subtract a c =
    let
        ( r1, g1, b1 ) =
            Color.toRGB a

        ( r2, g2, b2 ) =
            Color.toRGB c
    in
    Color.fromRGB
        ( r1 - r2
        , g1 - g2
        , b1 - b2
        )


{-| Blend two colors together.

Any color multiplied by black will result in black.
Any color multiplied by white will result in the color.
rgb(255, 0, 0) will keep reds and remove any greens and blues.

-}
multiply : Color -> Color -> Color
multiply a c =
    let
        ( r1, g1, b1 ) =
            Color.toRGB a

        ( r2, g2, b2 ) =
            Color.toRGB c
    in
    Color.fromRGB
        ( r1 * r2 / 255
        , g1 * g2 / 255
        , b1 * b2 / 255
        )


{-| Blend two colors together.

Use this function to strip out tones & change them to white.

-}
divide : Color -> Color -> Color
divide a c =
    let
        ( r1, g1, b1 ) =
            Color.toRGB a

        ( r2, g2, b2 ) =
            Color.toRGB c

        safeDivide num denom =
            if denom == 0 then
                255

            else
                255 * (num / denom)
    in
    Color.fromRGB
        ( safeDivide r1 r2
        , safeDivide g1 g2
        , safeDivide b1 b2
        )


{-| Use this function to produce a new shade of the Color.
Note: shades will be darker than the starting color. If you want a lighter color,
please see `tint`.

Pass in the percentage value by which you want to darken the color.

-}
shade : Float -> Color -> Color
shade percentage color =
    adjustLightness (0 - abs percentage) color


{-| Use this function to produce a new tint of the Color.
Note: tints will be lighter than the starting color. If you want a darker color,
please see `shade`.

Pass in the percentage value by which you want to lighten the color.

-}
tint : Float -> Color -> Color
tint percentage color =
    adjustLightness (abs percentage) color


{-| TODO! Tones!
-}
tone : Color -> Color
tone color =
    color

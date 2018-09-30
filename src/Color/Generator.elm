module Color.Generator exposing
    ( complementary, triadic, splitComplementary, square, tetratic
    , grayscale
    , rotate
    )

{-|

@docs complementary, triadic, splitComplementary, square, tetratic

@docs grayscale
@docs rotate

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

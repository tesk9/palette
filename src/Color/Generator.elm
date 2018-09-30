module Color.Generator exposing
    ( complementary, grayscale
    , rotate
    , triadic
    )

{-|

@docs complementary, grayscale

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
    ( rotate 120 color, rotate 240 color )


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

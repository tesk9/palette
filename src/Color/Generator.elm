module Color.Generator exposing (complementary, grayscale)

{-|

@docs complementary, grayscale

-}

import Color exposing (Color)


{-| Find the color opposite the color you pass in on the color wheel.

E.g., if you pass in a reddish color, you should expect to get back a greenish color.

-}
complementary : Color -> Color
complementary color =
    --TODO: implement!
    color


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

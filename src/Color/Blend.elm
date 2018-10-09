module Color.Blend exposing (add, subtract, multiply, divide)

{-| Operations that combine colors.

@docs add, subtract, multiply, divide

-}

import Color exposing (Color)


{-| Blends two colors together by adding the values in each channel.

That is, `rgb(10, 20, 30) + rgb(10, 10, 10) = rgb(20, 30, 40)`.

Play with an example in Ellie here: <https://ellie-app.com/3yLdpDs9NBya1>.

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

That is, `rgb(10, 20, 30) - rgb(10, 10, 10) = rgb(0, 10, 20)`.

Play with an example in Ellie here: <https://ellie-app.com/3yLftQKkL6Ga1>.

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
`rgb(255, 0, 0)` will keep reds and remove any greens and blues.

Play with an example in Ellie here: <https://ellie-app.com/3yLgG6JQCgHa1>.

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

Play with an example in Ellie here: <https://ellie-app.com/3yLhRLkJPwTa1>

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

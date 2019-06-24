module Palette.Generative exposing
    ( complementary, triadic, splitComplementary, square, tetratic
    , monochromatic
    )

{-|


### Generate a palette by hue

@docs complementary, triadic, splitComplementary, square, tetratic


### Generate a palette by lightness

@docs monochromatic

-}

import Colour exposing (Colour)


{-| Find the colour opposite the colour you pass in on the colour wheel.

E.g., if you pass in a reddish colour, you should expect to get back a tealish colour.

-}
complementary : Colour -> Colour
complementary colour =
    Colour.rotateHue 180 colour


{-| Find the other two colours in the triadic scheme defined by the colour passed in.

Triadic colour schemes are evenly-spaced, so each of the three colours is 120 degrees
from the others.

The internet says this scheme will be vibrant, and that you should
mostly use one of the three colours and only use the other two for accents.

-}
triadic : Colour -> ( Colour, Colour )
triadic colour =
    splitComplementary 120 colour


{-| Build a three-colour scheme by rotating the same amount from the initial colour
in both directions.

`triadic`, the evenly-spaced 3-colour scheme, can be defined in terms of this function:

    triadic colour =
        splitComplementary 120 colour

Initial rotation is clamped between 0 and 180.

-}
splitComplementary : Float -> Colour -> ( Colour, Colour )
splitComplementary r colour =
    let
        rotation =
            clamp 0 180 r
    in
    ( Colour.rotateHue rotation colour, Colour.rotateHue (0 - rotation) colour )


{-| Find four equally-spaced colours along the colour wheel starting from the passed-in colour.
-}
square : Colour -> ( Colour, Colour, Colour )
square colour =
    tetratic 60 colour


{-| Find four colours along the colour wheel starting from the passed-in colour.

This differs from the `square` helper in that our values aren't equally spaced --
we are selecting colours on the colour wheel with a rectangle. We can actually define
`square` in terms of this function as follows:

    square colour =
        tetratic 60 colour

We'll rotate the number of degrees passed in along the colour wheel to find our first
colour. Then we'll rotate the "length" of the rectangle -- as much as we need to in order
to make it all the way around.

Initial rotation is clamped between 0 and 180.

-}
tetratic : Float -> Colour -> ( Colour, Colour, Colour )
tetratic w colour =
    let
        width =
            clamp 0 180 w

        length =
            (360 - 2 * width) / 2
    in
    ( Colour.rotateHue width colour
    , Colour.rotateHue (width + length) colour
    , Colour.rotateHue (2 * width + length) colour
    )


{-| Create a monochromatic palette. The `Float` argument is size of the Lightness
steps that you'd like in the palette.

If you wanted a grayscale palette, and you wanted it to have five colours, you could do
something like this:

    grayscalePalette =
        monochromatic 20 black

Colours will be arranged from darkest to lightest.

-}
monochromatic : Float -> Colour -> List Colour
monochromatic stepSize colour =
    let
        getNextStep adjustment lastColour colours =
            let
                nextLightness =
                    Colour.toHSL lastColour
                        |> (\( _, _, lightness ) -> lightness + adjustment)
            in
            if nextLightness <= 0 || nextLightness >= 100 then
                lastColour :: colours

            else
                getNextStep adjustment (Colour.addLightness adjustment lastColour) (lastColour :: colours)
    in
    case List.reverse (getNextStep stepSize colour []) of
        start :: tints ->
            getNextStep (0 - stepSize) colour [] ++ tints

        [] ->
            []

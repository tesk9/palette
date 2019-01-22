module Palette.Cubehelix exposing
    ( defaultConfig
    , generate
    , AdvancedConfig
    , RotationDirection(..)
    )

{-| Are you looking to generate a color scheme in which none of the colors "pop"? Then this may be the tool for you!

@docs defaultConfig
@docs generate
@docs AdvancedConfig
@docs RotationDirection

Professor Dave Green (whose name, given the context, makes me very happy! Please also see [these testimonials](http://davegreenfacts.soc.srcf.net/).)
developed this method of generating even-intensity color schemes for use in astronomy. He called this method
"cubehelix" based on its relationship to the RGB color solid (a cube!). If you're curious (what cube?? what about the
helix?!) please read more about it [here](https://www.mrao.cam.ac.uk/~dag/CUBEHELIX/), or see the paper:

> Green, D. A., 2011, \`A colour scheme for the display of astronomical intensity images', Bulletin of the Astronomical Society of India, 39, 289.
> (2011BASI...39..289G at ADS.)

-}

import Color exposing (Color)


{-| -}
type alias AdvancedConfig =
    { startingColor : Color
    , rotationDirection : RotationDirection
    , rotations : Float
    , -- Gamma factor emphasizes low or high intensity values
      gamma : Float
    , numLevels : Int
    }


{-| The helix can rotate in the red, green, blue direction, or in the blue, green, red direction.
Try both and see which one you like better!
-}
type RotationDirection
    = RGB
    | BGR


{-| These are the defaults in Green's paper.
I don't think they're necessary what web developers
would want, but they do clearly demonstrate the
power of this color scheme approach in terms of keeping
even intensity.
-}
defaultConfig : AdvancedConfig
defaultConfig =
    { startingColor = Color.fromHSL ( 60, 100, 0 )
    , rotationDirection = BGR
    , rotations = 1.5
    , gamma = 1.0
    , numLevels = 256
    }


{-| -}
generate : AdvancedConfig -> List Color
generate ({ numLevels } as config) =
    let
        internalConfig =
            toInternalConfig config

        generate_ : List Color -> List Color
        generate_ colors =
            if List.length colors >= numLevels then
                colors

            else
                generate_ (colorAtStep (List.length colors) internalConfig :: colors)
    in
    List.reverse (generate_ [])


toInternalConfig : AdvancedConfig -> InternalConfig
toInternalConfig { startingColor, rotationDirection, rotations, gamma, numLevels } =
    let
        ( hue, sat, _ ) =
            Color.toHSL startingColor

        positiveClampedRotations =
            clamp 0 1.5 (abs rotations)
    in
    { start = hue * 3 / 360 + 1
    , saturation = sat / 100
    , rotations =
        case rotationDirection of
            RGB ->
                positiveClampedRotations

            BGR ->
                -positiveClampedRotations
    , gamma = gamma
    , fract =
        \i ->
            toFloat i / (toFloat numLevels - 1)
    }


type alias InternalConfig =
    { -- "direction" of color deviation from black at the start.
      -- R = 1, G = 2, B = 3.
      -- I wonder if this would be easier to think about in terms of HSL starting arguments?
      start : Float
    , -- Saturation should be in [0, 1].
      -- Think of this value as the distance from gray.
      -- If this is zero, the expected behavior is that the
      -- resulting color scheme is grayscale & increasing in brightness
      saturation : Float
    , -- how many rotations between the start (black) and end (white)
      -- generally should be [-1.5, 1.5]
      rotations : Float
    , gamma : Float
    , fract : Int -> Float
    }


colorAtStep : Int -> InternalConfig -> Color
colorAtStep i { rotations, start, fract, gamma, saturation } =
    let
        angle =
            2 * pi * (start / 3.0 + 1.0 + rotations * fract i)

        fract_ =
            fract i * gamma

        amp =
            saturation * fract_ * (1 - fract_) / 2.0

        red =
            fract_ + amp * (-0.14861 * cos angle + 1.78277 * sin angle)

        green =
            fract_ + amp * (-0.29227 * cos angle - 0.90649 * sin angle)

        blue =
            fract_ + amp * (1.97294 * cos angle)
    in
    Color.fromRGB ( red * 255, green * 255, blue * 255 )

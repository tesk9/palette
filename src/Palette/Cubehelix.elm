module Palette.Cubehelix exposing
    ( generate
    , generateAdvanced, defaultConfig
    , AdvancedConfig, RotationDirection(..)
    )

{-| Cubehelix color palette.
![](https://user-images.githubusercontent.com/8811312/52818779-82238080-305c-11e9-8084-9c0048f549a2.png)
Play with an example [here](https://ellie-app.com/4K5qvPZNws5a1).

Use this palette generator when you want a color scheme in which none of the colors "pop."

Professor Dave Green (whose name, given the context, makes me very happy! Please also see [these testimonials](http://davegreenfacts.soc.srcf.net/).)
developed this method of generating even-intensity color schemes for use in astronomy. He called this method
"cubehelix" based on its relationship to the RGB color solid (a cube!). If you're curious (what cube?? what about the
helix?!) please read more about it [here](https://www.mrao.cam.ac.uk/~dag/CUBEHELIX/), or see the paper:

> Green, D. A., 2011, ["A colour scheme for the display of astronomical intensity images"](http://astron-soc.in/bulletin/11June/289392011.pdf), Bulletin of the Astronomical Society of India, 39, 289.
> ([2011BASI...39..289G](https://ui.adsabs.harvard.edu/#abs/2011BASI...39..289G) at [ADS](https://ui.adsabs.harvard.edu/).)


## Generate a palette

    import Palette.Cubehelix as Cubehelix

    myPalette : List Color
    myPalette =
        -- This will generate 10 even-intensity colors
        Cubehelix.generate 10

![](https://user-images.githubusercontent.com/8811312/52819054-37563880-305d-11e9-9cf3-a553c54f2c11.png)
See this example on [Ellie](https://ellie-app.com/4K5FZFNYhmwa1).

@docs generate


## Customize your palette

    import Color exposing (Color)
    import Palette.Cubehelix as Cubehelix exposing (defaultConfig)

    myPalette : List Color
    myPalette =
        Cubehelix.generateAdvanced 10 defaultConfig

@docs generateAdvanced, defaultConfig
@docs AdvancedConfig, RotationDirection

-}

import Color exposing (Color)


{-| `startingColor` is used to derive what hue you want to start from (see HSL color space)
as well as how saturated (how far from grey) you want the colors produced to be.
The lightness of the color that you pass in is not used.

`rotationDirection` describes whether the helix moves towards red then green then blue, or
blue then green then red. This is easiest to visualize if you think of a cube defined by three
vectors, one each for red, green, and blue values. If that's not doing the trick,
take a look at [this image](https://www.mrao.cam.ac.uk/~dag/CUBEHELIX/3d-default.png).

`rotations` describes the number of rotations the helix should make as it moves from black (`Color.fromRGB (0, 0 0)`)
to white `Color.fromRGB (255, 255, 255)`. `rotations` should be in [0, 1.5]. If it's not, it will be absolute-value-ified & clamped.

The `gamma` value can be used to emphasize low- or high-intensity colors. `gamma` will be clamped with `clamp 0 2`.

  - Provide a 0 < gamma < 1 to emphasize low-intensity values
  - Provide a 1 < gamma < 2 to emphasize high-intensity values

-}
type alias AdvancedConfig =
    { startingColor : Color
    , rotationDirection : RotationDirection
    , rotations : Float
    , gamma : Float
    }


{-| The helix can rotate in the red, green, blue direction, or in the blue, green, red direction.
Try both and see which one you like better!
-}
type RotationDirection
    = RGB
    | BGR


{-| `defaultConfig` is pre-populated with the values analagous to those that Professor Green uses.
This is a great place to start to learn what different settings can get you. Try playing with one
value at a time to see how it changes the result!

    { startingColor = Color.fromHSL ( -60, 100, 0 )
    , rotationDirection = BGR
    , rotations = 1.5
    , gamma = 1.0
    }

-}
defaultConfig : AdvancedConfig
defaultConfig =
    { startingColor = Color.fromHSL ( -60, 100, 0 )
    , rotationDirection = BGR
    , rotations = 1.5
    , gamma = 1.0
    }


{-| The parameter (clamped between 0 and 256) corresponds to the number of colors you want to generate.
-}
generate : Int -> List Color
generate numLevels =
    generateAdvanced numLevels defaultConfig


{-| The first parameter (clamped between 0 and 256) corresponds to the number of colors you want to generate.
-}
generateAdvanced : Int -> AdvancedConfig -> List Color
generateAdvanced numLevels config =
    let
        clampedNumLevels =
            clamp 0 256 numLevels

        internalConfig =
            toInternalConfig config clampedNumLevels

        generate_ : List Color -> List Color
        generate_ colors =
            if List.length colors >= clampedNumLevels then
                colors

            else
                generate_ (colorAtStep (List.length colors) internalConfig :: colors)
    in
    List.reverse (generate_ [])


toInternalConfig : AdvancedConfig -> Int -> InternalConfig
toInternalConfig { startingColor, rotationDirection, rotations, gamma } numLevels =
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
    , gamma = clamp 0 2 gamma
    , fract =
        \i ->
            toFloat i / (toFloat numLevels - 1)
    }


type alias InternalConfig =
    { -- "direction" of color deviation from black at the start.
      -- R = 1, G = 2, B = 3.
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


{-| Hello, friend! Are you looking at the source code? How fun!
Please look at <http://astron-soc.in/bulletin/11June/289392011.pdf> too.

The major differences between this implementation and that one are:

  - On the web, generally we want RGB values in [0,255] rather than [0,1], so the return values are scaled
  - Color.fromRGB clamps the values between 0 and 255 for us, so we don't need to double check anything

-}
colorAtStep : Int -> InternalConfig -> Color
colorAtStep i { rotations, start, fract, gamma, saturation } =
    let
        angle =
            2 * pi * (start / 3.0 + 1.0 + rotations * fract i)

        fract_ =
            fract i ^ gamma

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

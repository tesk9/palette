module Palette.Cubehelix exposing
    ( generate
    , generateAdvanced
    , defaultConfig, AdvancedConfig, RotationDirection(..)
    )

{-| Are you looking to generate a color scheme in which none of the colors "pop"? Then this may be the tool for you!


## Generate a palette

@docs generate


## Customize your palette

@docs generateAdvanced
@docs defaultConfig, AdvancedConfig, RotationDirection

Professor Dave Green (whose name, given the context, makes me very happy! Please also see [these testimonials](http://davegreenfacts.soc.srcf.net/).)
developed this method of generating even-intensity color schemes for use in astronomy. He called this method
"cubehelix" based on its relationship to the RGB color solid (a cube!). If you're curious (what cube?? what about the
helix?!) please read more about it [here](https://www.mrao.cam.ac.uk/~dag/CUBEHELIX/), or see the paper:

> Green, D. A., 2011, \`A colour scheme for the display of astronomical intensity images', Bulletin of the Astronomical Society of India, 39, 289.
> (2011BASI...39..289G at ADS.)

-}

import Color exposing (Color)


{-|

    import Color exposing (Color)
    import Palette.Cubehelix as Cubehelix

    myPalette : List Color
    myPalette =
        Cubehelix.generateAdvanced 10
            { -- the starting color is used to derive what hue you want to start from (see HSL color space)
              -- as well as how saturated (how far from grey) you want the colors produced to be.
              -- the lightness of the color that you pass in is not used.
              startingColor = Color
            , -- rotationDirection can be `RGB` or `BGR`
              rotationDirection = RotationDirection
            , -- this number should be in [0, 1.5]. If it's not, it will be absolute-value-ified & clamped.
              rotations = Float
            , -- Gamma factor emphasizes low or high intensity values
              -- provide a 0 < gamma < 1 to emphasize low-intensity values
              -- provide a 1 < gamma < 2  to emphasize high-intensity values
              -- gamma values will be clamped with `clamp 0 2`
              gamma = Float
            }

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

See `AdvancedConfig` for more documentation on what each value signifies.

    import Palette.Cubehelix as Cubehelix exposing (AdvancedConfig, defaultConfig)

    myCubehelixConfig : AdvancedConfig
    myCubehelixConfig =
        { defaultConfig | rotationDirection = Cubehelix.RGB, rotations = 1 }

-}
defaultConfig : AdvancedConfig
defaultConfig =
    { startingColor = Color.fromHSL ( -60, 100, 0 )
    , rotationDirection = BGR
    , rotations = 1.5
    , gamma = 1.0
    }


{-|

    import Palette.Cubehelix as Cubehelix

    myPalette : List Color
    myPalette =
        -- This will generate 10 even-intensity colors
        Cubehelix.generate 10

The first parameter, `numLevels`, corresponds to the number of colors you want to generate.
`numLevels` will be clamped between 0 and 256.

If you feel comfortable using `generate` & want to customize the palette you produce further,
please see `generateAdvanced`.

-}
generate : Int -> List Color
generate numLevels =
    generateAdvanced numLevels defaultConfig


{-|

    import Color exposing (Color)
    import Palette.Cubehelix as Cubehelix


    -- `myTheme` will be 256 items long
    myTheme : List Color
    myTheme =
        Cubehelix.generateAdvanced 256
            { startingColor = Color.fromRGB ( 240, 0, 230 )
            , rotationDirection = Cubehelix.BGR
            , rotations = 1.2
            , gamma = 1.5
            }

The first parameter, `numLevels`, corresponds to the number of colors you want to generate.
`numLevels` will be clamped between 0 and 256.

The second parameter, `config`, is a record with a bunch of special settings you can use to
adjust the generated palette. See the docs on `AdvancedConfig` to learn more.

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

module Palette.Cubehelix exposing
    ( AdvancedConfig
    , Config, generate
    )

{-| <https://www.mrao.cam.ac.uk/~dag/CUBEHELIX/>

Green, D. A., 2011, \`A colour scheme for the display of astronomical intensity images', Bulletin of the Astronomical Society of India, 39, 289.
(2011BASI...39..289G at ADS.)

@docs generate -- TODO: Config?
@docs AdvancedConfig

-}

import Color exposing (Color)


{-| Probably will want a learning path including a simpler config.
Given that right now I don't understand what the advanced config is
for, exactly! :P
-}
type alias Config =
    { hue : Float
    }


{-| -}
type alias AdvancedConfig =
    { -- "direction" of color deviation from black at the start.
      -- R = 1, G = 2, B = 3.
      -- I wonder if this would be easier to think about in terms of HSL starting arguments?
      start : Float
    , -- how many rotations between the start (black) and end (white)
      -- generally should be [-1.5, 1.5]
      rotations : Float
    , -- Hue should be in [0, 1].
      -- I think this field may be misnamed, actually. His Fortran code
      -- has the comment "for hue intensity scaling (in the range 0.0 (B+W) to 1.0"
      -- Okay, then another note in the paper:
      -- "A hue parameter (h), which controls how saturated the colours are.".
      -- So is this actually a saturation value?
      -- At any rate, if this is zero, the expected behavior is that the
      -- resulting color scheme is grayscale & increasing in brightness. So maybe
      -- that's a good palce to start.
      hue : Float
    , -- Gamma factor emphasizes low or high intensity values
      gamma : Float
    , numLevels : Int
    }


{-| These are the defaults in Green's paper.
I don't think they're necessary what web developers
would want, but they do clearly demonstrate the
power of this color scheme approach in terms of keeping
even intensity.
-}
defaultConfig : AdvancedConfig
defaultConfig =
    { -- This start color is purple, apparently.
      -- which is between R = 1 and B = 3 ≡ 0 when using modulo 3 arithmetic, with R = 1, G = 2, B = 3
      -- What, though, is the difference between this and `hue`?
      start = 0.5

    -- −1.5 rotations means → B → G → R → B
    -- So positive direction rotations are RGB, and negative are BGR
    , rotations = -1.5
    , hue = 1.0
    , gamma = 1.0
    , numLevels = 256
    }


{-| Seems like his code (not having any idea how to read Fortran) has a `NLEV` parameter
which I believe means number of levels to produce.
-}
generate : AdvancedConfig -> List Color
generate { start, rotations, hue, gamma, numLevels } =
    generate_ numLevels []


generate_ : Int -> List Color -> List Color
generate_ numLevels colors =
    if List.length colors >= numLevels then
        colors

    else
        generate_ numLevels (nextColor :: colors)


nextColor : Color
nextColor =
    Color.fromRGB ( 0, 0, 0 )

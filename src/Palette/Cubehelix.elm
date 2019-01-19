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
    ()


{-| -}
type alias AdvancedConfig =
    { -- "direction" of color deviation from black at the start.
      -- R = 1, G = 2, B = 3.
      -- I wonder if this would be easier to think about in terms of HSL starting arguments?
      start : Float
    , -- how many rotations between the start (black) and end (white)
      -- generally should be [-1.5, 1.5]
      rotations : Float
    , -- Saturation should be in [0, 1].
      -- Think of this value as the distance from gray.
      -- If this is zero, the expected behavior is that the
      -- resulting color scheme is grayscale & increasing in brightness
      saturation : Float
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
    , saturation = 1.0
    , gamma = 1.0
    , numLevels = 256
    }


{-| Seems like his code (not having any idea how to read Fortran) has a `NLEV` parameter
which I believe means number of levels to produce.
-}
generate : AdvancedConfig -> List Color
generate { start, rotations, saturation, gamma, numLevels } =
    let
        -- FRACT=FLOAT(I-1)/FLOAT(NLEV-1)
        -- ANGLE=2*PI*(START/3.0+1.0+ROTS*FRACT)
        -- FRACT=FRACT**GAMMA
        -- AMP=HUE*FRACT*(1-FRACT)/2.0
        -- RED(I)=FRACT+AMP*(-0.14861*COS(ANGLE)+1.78277*SIN(ANGLE))
        -- GRN(I)=FRACT+AMP*(-0.29227*COS(ANGLE)-0.90649*SIN(ANGLE))
        -- BLU(I)=FRACT+AMP*(+1.97294*COS(ANGLE))
        -- angle =
        --     2 * pi
        generate_ : List Color -> List Color
        generate_ colors =
            let
                stepSize =
                    2 * pi / toFloat numLevels

                theta =
                    (toFloat (List.length colors) + 1) * stepSize
            in
            if List.length colors >= numLevels then
                colors

            else
                generate_ (nextColor theta :: colors)

        nextColor : Float -> Color
        nextColor theta =
            let
                x =
                    saturation * cos theta

                y =
                    saturation * sin theta

                z =
                    theta * sqrt 2 / (2 * pi * rotations)
            in
            ( x, y, z )
                |> toUnitRGB
                |> adjustForIntensity
                |> Color.fromRGB
    in
    if numLevels > 0 then
        generate_ []

    else
        []


toUnitRGB : ( Float, Float, Float ) -> ( Float, Float, Float )
toUnitRGB ( x, y, z ) =
    -- TODO: actual conversion
    ( x, y, z )


adjustForIntensity : ( Float, Float, Float ) -> ( Float, Float, Float )
adjustForIntensity ( r, g, b ) =
    -- TODO: actual conversion
    ( r, g, b )

module Colour.TransparentFuzzer exposing
    ( colorWithOpacity
    , hslColor
    , rgbColor
    )

import Colour.Transparent exposing (Colour)
import ColourFuzzer
import Fuzz exposing (Fuzzer)
import Opacity exposing (Opacity)
import OpacityFuzzer exposing (opacityValue)


colorWithOpacity : Fuzzer Colour
colorWithOpacity =
    Fuzz.oneOf [ rgbColor, hslColor ]


rgbColor : Fuzzer Colour
rgbColor =
    Fuzz.map2 Colour.Transparent.fromColor
        opacityValue
        ColourFuzzer.rgbColor


hslColor : Fuzzer Colour
hslColor =
    Fuzz.map2 Colour.Transparent.fromColor
        opacityValue
        ColourFuzzer.hslColor

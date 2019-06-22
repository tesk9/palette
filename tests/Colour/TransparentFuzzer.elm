module Colour.TransparentFuzzer exposing
    ( colorWithOpacity
    , hslColor
    , opacityValue
    , rgbColor
    )

import Colour.Transparent exposing (Colour, Opacity)
import ColourFuzzer
import Fuzz exposing (Fuzzer)


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


opacityValue : Fuzzer Opacity
opacityValue =
    Fuzz.map Colour.Transparent.customOpacity (Fuzz.floatRange 0 1.0)

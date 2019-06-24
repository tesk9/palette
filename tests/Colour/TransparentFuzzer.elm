module Colour.TransparentFuzzer exposing
    ( colorWithOpacity
    , hslColour
    , opacityValue
    , rgbColour
    )

import Colour.Transparent exposing (Colour, Opacity)
import ColourFuzzer
import Fuzz exposing (Fuzzer)


colorWithOpacity : Fuzzer Colour
colorWithOpacity =
    Fuzz.oneOf [ rgbColour, hslColour ]


rgbColour : Fuzzer Colour
rgbColour =
    Fuzz.map2 Colour.Transparent.fromColour
        opacityValue
        ColourFuzzer.rgbColour


hslColour : Fuzzer Colour
hslColour =
    Fuzz.map2 Colour.Transparent.fromColour
        opacityValue
        ColourFuzzer.hslColour


opacityValue : Fuzzer Opacity
opacityValue =
    Fuzz.map Colour.Transparent.customOpacity (Fuzz.floatRange 0 1.0)

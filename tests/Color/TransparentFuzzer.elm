module Color.TransparentFuzzer exposing
    ( colorWithOpacity
    , hslColor
    , opacityValue
    , rgbColor
    )

import Color.Transparent exposing (Color, Opacity)
import ColorFuzzer
import Fuzz exposing (Fuzzer)


colorWithOpacity : Fuzzer Color
colorWithOpacity =
    Fuzz.oneOf [ rgbColor, hslColor ]


rgbColor : Fuzzer Color
rgbColor =
    Fuzz.map2 Color.Transparent.fromColor
        opacityValue
        ColorFuzzer.rgbColor


hslColor : Fuzzer Color
hslColor =
    Fuzz.map2 Color.Transparent.fromColor
        opacityValue
        ColorFuzzer.hslColor


opacityValue : Fuzzer Opacity
opacityValue =
    Fuzz.map Color.Transparent.customOpacity (Fuzz.floatRange 0 1.0)

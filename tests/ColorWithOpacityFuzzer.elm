module ColorWithOpacityFuzzer exposing
    ( colorWithOpacity
    , hslColor
    , rgbColor
    )

import ColorFuzzer
import ColorWithOpacity exposing (ColorWithOpacity)
import Fuzz exposing (Fuzzer)
import Opacity exposing (Opacity)
import OpacityFuzzer exposing (opacityValue)


colorWithOpacity : Fuzzer ColorWithOpacity
colorWithOpacity =
    Fuzz.oneOf [ rgbColor, hslColor ]


rgbColor : Fuzzer ColorWithOpacity
rgbColor =
    Fuzz.map2 ColorWithOpacity.fromColor
        opacityValue
        ColorFuzzer.rgbColor


hslColor : Fuzzer ColorWithOpacity
hslColor =
    Fuzz.map2 ColorWithOpacity.fromColor
        opacityValue
        ColorFuzzer.hslColor

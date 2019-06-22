module TransparentColorFuzzer exposing
    ( colorWithOpacity
    , hslColor
    , rgbColor
    )

import Fuzz exposing (Fuzzer)
import Opacity exposing (Opacity)
import OpacityFuzzer exposing (opacityValue)
import OpaqueColorFuzzer
import TransparentColor exposing (TransparentColor)


colorWithOpacity : Fuzzer TransparentColor
colorWithOpacity =
    Fuzz.oneOf [ rgbColor, hslColor ]


rgbColor : Fuzzer TransparentColor
rgbColor =
    Fuzz.map2 TransparentColor.fromColor
        opacityValue
        OpaqueColorFuzzer.rgbColor


hslColor : Fuzzer TransparentColor
hslColor =
    Fuzz.map2 TransparentColor.fromColor
        opacityValue
        OpaqueColorFuzzer.hslColor

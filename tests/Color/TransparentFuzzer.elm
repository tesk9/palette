module Color.TransparentFuzzer exposing
    ( colorWithOpacity
    , hslColor
    , opacityValue
    , rgbColor
    )

import ColorFuzzer
import Fuzz exposing (Fuzzer)
import TransparentColor exposing (Opacity, TransparentColor)


colorWithOpacity : Fuzzer TransparentColor
colorWithOpacity =
    Fuzz.oneOf [ rgbColor, hslColor ]


rgbColor : Fuzzer TransparentColor
rgbColor =
    Fuzz.map2 TransparentColor.fromColor
        opacityValue
        ColorFuzzer.rgbColor


hslColor : Fuzzer TransparentColor
hslColor =
    Fuzz.map2 TransparentColor.fromColor
        opacityValue
        ColorFuzzer.hslColor


opacityValue : Fuzzer Opacity
opacityValue =
    Fuzz.map TransparentColor.customOpacity (Fuzz.floatRange 0 1.0)

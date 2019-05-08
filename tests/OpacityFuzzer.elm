module OpacityFuzzer exposing (opacityValue)

import Fuzz exposing (Fuzzer)
import Opacity exposing (Opacity)


opacityValue : Fuzzer Opacity
opacityValue =
    Fuzz.map Opacity.custom (Fuzz.floatRange 0 1.0)

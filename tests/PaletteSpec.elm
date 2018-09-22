module PaletteSpec exposing (black, luminanceSuite, white)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Palette
import Test exposing (..)


white : Palette.RGB
white =
    Palette.RGB 255 255 255


black : Palette.RGB
black =
    Palette.RGB 0 0 0


luminanceSuite : Test
luminanceSuite =
    describe "luminance"
        [ test "white is very bright" <|
            \_ ->
                white
                    |> Palette.luminance
                    |> floatEqual 1
        , test "black is not very bright" <|
            \_ ->
                black
                    |> Palette.luminance
                    |> floatEqual 0
        ]


floatEqual : Float -> Float -> Expectation
floatEqual =
    Expect.within (Expect.Absolute 0.000000001)

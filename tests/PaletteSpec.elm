module PaletteSpec exposing
    ( contrastSuite
    , luminanceSuite
    )

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


contrastSuite : Test
contrastSuite =
    describe "contrast"
        [ describe "black and white"
            [ test "contrast black white == contrast white black" <|
                \_ ->
                    Expect.equal (Palette.contrast black white) (Palette.contrast white black)
            , test "contrast black white" <|
                \_ ->
                    Palette.contrast black white
                        |> floatEqual 21
            , test "contrast white white" <|
                \_ ->
                    Palette.contrast white white
                        |> floatEqual 1
            , test "contrast black black" <|
                \_ ->
                    Palette.contrast black black
                        |> floatEqual 1
            ]
        ]


floatEqual : Float -> Float -> Expectation
floatEqual =
    Expect.within (Expect.Absolute 0.000000001)

module Color.TransparentSpec exposing (colorWithOpacitySuite, opacitySuite)

import Color.Transparent
import Color.TransparentFuzzer
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Palette.Generative
import Test exposing (..)


colorWithOpacitySuite : Test
colorWithOpacitySuite =
    describe "colorWithOpacity"
        [ describe "to a String" <|
            let
                transparentPink =
                    Color.Transparent.fromRGBA
                        { red = 255
                        , green = 0
                        , blue = 255
                        , alpha = Color.Transparent.customOpacity 0.5
                        }
            in
            [ test "toRGBAString" <|
                \_ ->
                    transparentPink
                        |> Color.Transparent.toRGBAString
                        |> Expect.equal "rgba(255,0,255,0.5)"
            , test "toHSLAString" <|
                \_ ->
                    transparentPink
                        |> Color.Transparent.toHSLAString
                        |> Expect.equal "hsla(300,100%,50%,0.5)"
            , test "toHex with transparency" <|
                \_ ->
                    transparentPink
                        |> Color.Transparent.toHexA
                        |> Expect.equal "#FF00FF80"
            ]
        ]


opacitySuite : Test
opacitySuite =
    describe "Opacity"
        [ test "custom bottom bound" <|
            \_ ->
                Expect.equal
                    (Color.Transparent.customOpacity -0.2)
                    Color.Transparent.transparent
        , test "custom upper bound" <|
            \_ ->
                Expect.equal
                    (Color.Transparent.customOpacity 1.2)
                    Color.Transparent.opaque
        , test "toFloat and toString" <|
            \_ ->
                let
                    opacity =
                        Color.Transparent.customOpacity 0.392408
                in
                Expect.equal
                    (Color.Transparent.opacityToFloat opacity |> String.fromFloat)
                    (Color.Transparent.opacityToString opacity)
        ]

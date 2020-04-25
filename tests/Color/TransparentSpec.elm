module Color.TransparentSpec exposing (colorWithOpacitySuite, opacitySuite)

import Color.TransparentFuzzer
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Palette.Generative
import Test exposing (..)
import TransparentColor


colorWithOpacitySuite : Test
colorWithOpacitySuite =
    describe "colorWithOpacity"
        [ describe "to a String" <|
            let
                transparentPink =
                    TransparentColor.fromRGBA
                        { red = 255
                        , green = 0
                        , blue = 255
                        , alpha = TransparentColor.customOpacity 0.5
                        }
            in
            [ test "toRGBAString" <|
                \_ ->
                    transparentPink
                        |> TransparentColor.toRGBAString
                        |> Expect.equal "rgba(255,0,255,0.5)"
            , test "toHSLAString" <|
                \_ ->
                    transparentPink
                        |> TransparentColor.toHSLAString
                        |> Expect.equal "hsla(300,100%,50%,0.5)"
            , test "toHex with transparency" <|
                \_ ->
                    transparentPink
                        |> TransparentColor.toHexA
                        |> Expect.equal "#FF00FF80"
            ]
        ]


opacitySuite : Test
opacitySuite =
    describe "Opacity"
        [ test "custom bottom bound" <|
            \_ ->
                Expect.equal
                    (TransparentColor.customOpacity -0.2)
                    TransparentColor.transparent
        , test "custom upper bound" <|
            \_ ->
                Expect.equal
                    (TransparentColor.customOpacity 1.2)
                    TransparentColor.opaque
        , test "toFloat and toString" <|
            \_ ->
                let
                    opacity =
                        TransparentColor.customOpacity 0.392408
                in
                Expect.equal
                    (TransparentColor.opacityToFloat opacity |> String.fromFloat)
                    (TransparentColor.opacityToString opacity)
        ]

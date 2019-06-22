module Colour.TransparentSpec exposing (colorWithOpacitySuite, opacitySuite)

import Colour
import Colour.Transparent
import Colour.TransparentFuzzer
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
                    Colour.Transparent.fromRGBA
                        { red = 255
                        , green = 0
                        , blue = 255
                        , alpha = Colour.Transparent.customOpacity 0.5
                        }
            in
            [ test "toRGBAString" <|
                \_ ->
                    transparentPink
                        |> Colour.Transparent.toRGBAString
                        |> Expect.equal "rgba(255,0,255,0.5)"
            , test "toHSLAString" <|
                \_ ->
                    transparentPink
                        |> Colour.Transparent.toHSLAString
                        |> Expect.equal "hsla(300,100%,50%,0.5)"
            , test "toHexString with transparency" <|
                \_ ->
                    transparentPink
                        |> Colour.Transparent.toHexAString
                        |> Expect.equal "#FF00FF80"
            ]
        , test "when opacity differs, colors are not identical" <|
            \_ ->
                let
                    colora =
                        Colour.Transparent.fromRGBA
                            { red = 0
                            , green = 0
                            , blue = 0
                            , alpha = Colour.Transparent.transparent
                            }

                    colorb =
                        Colour.Transparent.fromRGBA
                            { red = 0
                            , green = 0
                            , blue = 0
                            , alpha = Colour.Transparent.opaque
                            }
                in
                colora
                    |> Colour.Transparent.equals colorb
                    |> Expect.false "Calling `equals` on different opacities failed"
        ]


opacitySuite : Test
opacitySuite =
    describe "Opacity"
        [ test "custom bottom bound" <|
            \_ ->
                Expect.equal
                    (Colour.Transparent.customOpacity -0.2)
                    Colour.Transparent.transparent
        , test "custom upper bound" <|
            \_ ->
                Expect.equal
                    (Colour.Transparent.customOpacity 1.2)
                    Colour.Transparent.opaque
        , test "toFloat and toString" <|
            \_ ->
                let
                    opacity =
                        Colour.Transparent.customOpacity 0.392408
                in
                Expect.equal
                    (Colour.Transparent.opacityToFloat opacity |> String.fromFloat)
                    (Colour.Transparent.opacityToString opacity)
        ]

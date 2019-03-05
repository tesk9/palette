module ColorWithOpacitySpec exposing (colorWithOpacitySuite)

import ColorWithOpacity
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Internal.ColorFuzzer as ColorFuzz exposing (hexStringOfLength)
import Opacity
import Palette.X11 exposing (..)
import Test exposing (..)


colorWithOpacitySuite : Test
colorWithOpacitySuite =
    describe "colorWithOpacity"
        [ describe "to a String" <|
            let
                transparentPink =
                    ColorWithOpacity.fromRGBA
                        { red = 255
                        , green = 0
                        , blue = 255
                        , alpha = Opacity.custom 0.5
                        }
            in
            [ test "toRGBAString" <|
                \_ ->
                    transparentPink
                        |> ColorWithOpacity.toRGBAString
                        |> Expect.equal "rgba(255,0,255,0.5)"
            , test "toHSLAString" <|
                \_ ->
                    transparentPink
                        |> ColorWithOpacity.toHSLAString
                        |> Expect.equal "hsla(300,100%,50%,0.5)"
            , test "toHexString with transparency" <|
                \_ ->
                    transparentPink
                        |> ColorWithOpacity.toHexAString
                        |> Expect.equal "#FF00FF80"
            ]
        , test "when opacity differs, colors are not identical" <|
            \_ ->
                let
                    startingColor =
                        ColorWithOpacity.fromRGBA { red = 0, green = 0, blue = 0, alpha = Opacity.transparent }
                in
                startingColor
                    |> ColorWithOpacity.mapOpacity (\_ -> Opacity.opaque)
                    |> ColorWithOpacity.equals startingColor
                    |> Expect.false "Calling `equals` on different opacities failed"
        ]

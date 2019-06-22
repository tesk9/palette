module Colour.TransparentSpec exposing (colorWithOpacitySuite)

import Colour
import Colour.Transparent
import Colour.TransparentFuzzer
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Opacity
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
                        , alpha = Opacity.custom 0.5
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
                    startingColor =
                        Colour.Transparent.fromRGBA { red = 0, green = 0, blue = 0, alpha = Opacity.transparent }
                in
                startingColor
                    |> Colour.Transparent.mapOpacity (\_ -> Opacity.opaque)
                    |> Colour.Transparent.equals startingColor
                    |> Expect.false "Calling `equals` on different opacities failed"
        , describe "Colour.Transparent mapping"
            [ fuzz
                (Fuzz.tuple ( Colour.TransparentFuzzer.colorWithOpacity, Fuzz.float ))
                "mapOpacity"
              <|
                \( colorWithOpacity, multiplier ) ->
                    let
                        expectedResult : Opacity.Opacity
                        expectedResult =
                            f (Colour.Transparent.getOpacity colorWithOpacity)

                        f =
                            Opacity.map ((*) multiplier)
                    in
                    colorWithOpacity
                        |> Colour.Transparent.mapOpacity f
                        |> Colour.Transparent.getOpacity
                        |> Expect.equal expectedResult
            , fuzz
                (Fuzz.tuple ( Colour.TransparentFuzzer.colorWithOpacity, Fuzz.float ))
                "mapColor"
              <|
                \( colorWithOpacity, percent ) ->
                    let
                        expectedResult : Colour.Colour
                        expectedResult =
                            f (Colour.Transparent.toColor colorWithOpacity)

                        f =
                            Colour.addSaturation percent
                    in
                    colorWithOpacity
                        |> Colour.Transparent.mapColor f
                        |> Colour.Transparent.toColor
                        |> Colour.equals expectedResult
                        |> Expect.true "`mapColor f >> toColor` should be equivalent to `toColor >> f`"
            , fuzz
                Colour.TransparentFuzzer.colorWithOpacity
                "map"
              <|
                \colorWithOpacity ->
                    let
                        { hue, saturation, lightness, alpha } =
                            Colour.Transparent.toHSLA colorWithOpacity

                        expectedResult : Colour.Transparent.Colour
                        expectedResult =
                            Colour.fromHSL ( hue, saturation, lightness )
                                |> fColor
                                |> Colour.Transparent.fromColor (fOpacity alpha)

                        fColor : Colour.Colour -> Colour.Colour
                        fColor =
                            Palette.Generative.complementary

                        fOpacity : Opacity.Opacity -> Opacity.Opacity
                        fOpacity =
                            Opacity.map ((-) 0.3)
                    in
                    colorWithOpacity
                        |> Colour.Transparent.map fOpacity fColor
                        |> Colour.Transparent.equals expectedResult
                        |> Expect.true "`map fo fc >> toColor` should match deconstructing and reconstructing result"
            ]
        ]

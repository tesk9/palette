module TransparentColorSpec exposing (colorWithOpacitySuite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Opacity
import OpaqueColor
import OpaqueColor.Generator
import Test exposing (..)
import TransparentColor
import TransparentColorFuzzer


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
                        , alpha = Opacity.custom 0.5
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
            , test "toHexString with transparency" <|
                \_ ->
                    transparentPink
                        |> TransparentColor.toHexAString
                        |> Expect.equal "#FF00FF80"
            ]
        , test "when opacity differs, colors are not identical" <|
            \_ ->
                let
                    startingColor =
                        TransparentColor.fromRGBA { red = 0, green = 0, blue = 0, alpha = Opacity.transparent }
                in
                startingColor
                    |> TransparentColor.mapOpacity (\_ -> Opacity.opaque)
                    |> TransparentColor.equals startingColor
                    |> Expect.false "Calling `equals` on different opacities failed"
        , describe "TransparentColor mapping"
            [ fuzz
                (Fuzz.tuple ( TransparentColorFuzzer.colorWithOpacity, Fuzz.float ))
                "mapOpacity"
              <|
                \( colorWithOpacity, multiplier ) ->
                    let
                        expectedResult : Opacity.Opacity
                        expectedResult =
                            f (TransparentColor.getOpacity colorWithOpacity)

                        f =
                            Opacity.map ((*) multiplier)
                    in
                    colorWithOpacity
                        |> TransparentColor.mapOpacity f
                        |> TransparentColor.getOpacity
                        |> Expect.equal expectedResult
            , fuzz
                (Fuzz.tuple ( TransparentColorFuzzer.colorWithOpacity, Fuzz.float ))
                "mapColor"
              <|
                \( colorWithOpacity, percent ) ->
                    let
                        expectedResult : OpaqueColor.OpaqueColor
                        expectedResult =
                            f (TransparentColor.toColor colorWithOpacity)

                        f =
                            OpaqueColor.adjustSaturation percent
                    in
                    colorWithOpacity
                        |> TransparentColor.mapColor f
                        |> TransparentColor.toColor
                        |> OpaqueColor.equals expectedResult
                        |> Expect.true "`mapColor f >> toColor` should be equivalent to `toColor >> f`"
            , fuzz
                TransparentColorFuzzer.colorWithOpacity
                "map"
              <|
                \colorWithOpacity ->
                    let
                        { hue, saturation, lightness, alpha } =
                            TransparentColor.toHSLA colorWithOpacity

                        expectedResult : TransparentColor.TransparentColor
                        expectedResult =
                            OpaqueColor.fromHSL ( hue, saturation, lightness )
                                |> fColor
                                |> TransparentColor.fromColor (fOpacity alpha)

                        fColor : OpaqueColor.OpaqueColor -> OpaqueColor.OpaqueColor
                        fColor =
                            OpaqueColor.Generator.complementary

                        fOpacity : Opacity.Opacity -> Opacity.Opacity
                        fOpacity =
                            Opacity.map ((-) 0.3)
                    in
                    colorWithOpacity
                        |> TransparentColor.map fOpacity fColor
                        |> TransparentColor.equals expectedResult
                        |> Expect.true "`map fo fc >> toColor` should match deconstructing and reconstructing result"
            ]
        ]

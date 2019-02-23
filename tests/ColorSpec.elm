module ColorSpec exposing (colorSpec, luminanceSuite)

import Color exposing (Color)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Internal.ColorFuzzer exposing (hexString, hexStringOfLength)
import Opacity
import Palette.X11 exposing (..)
import Test exposing (..)


colorSpec : Test
colorSpec =
    describe "Color"
        [ describe "to and from a Color"
            [ test "from RGB to RGB" <|
                \_ ->
                    Color.fromRGB ( -10, 123, 300 )
                        |> expectRGB ( 0, 123, 255 )
            , test "from HSL to HSL" <|
                \_ ->
                    Color.fromHSL ( -10, 123, -10 )
                        |> expectHSL ( 350, 100, 0 )
            , describe "Hex"
                [ test "from Hex with bad values" <|
                    \_ ->
                        Color.fromHexString "#FFDG00"
                            |> Expect.err
                , test "from lowercase Hex to Hex" <|
                    \_ ->
                        Color.fromHexString "#d3e700"
                            |> expectHex "#D3E700"
                , test "from Hex to Hex" <|
                    \_ ->
                        Color.fromHexString "#FFD700"
                            |> expectHex "#FFD700"
                , fuzz (hexStringOfLength 3) "Short hex and long hex match" <|
                    \hex ->
                        let
                            fullLengthHexString =
                                String.toList hex
                                    |> List.concatMap (\v -> [ v, v ])
                                    |> String.fromList
                                    |> String.dropLeft 1
                        in
                        Color.fromHexString hex
                            |> expectHex fullLengthHexString
                , fuzz (hexStringOfLength 6) "Long hex succeeds" <|
                    \hex ->
                        Color.fromHexString hex
                            |> expectHex hex
                ]
            ]
        , describe "to a String"
            [ test "toRGBString" <|
                \_ ->
                    Color.fromRGB ( -10, 123, 300 )
                        |> Color.toRGBString
                        |> Expect.equal "rgb(0,123,255)"
            , test "toHSLString" <|
                \_ ->
                    Color.fromHSL ( 15, -13, 300 )
                        |> Color.toHSLString
                        |> Expect.equal "hsl(15,0%,100%)"
            , test "toHexString" <|
                \_ ->
                    Color.fromRGB ( -10, 123, 300 )
                        |> Color.toHexString
                        |> Expect.equal "#007BFF"
            ]
        , describe "equality and equivalence"
            [ test "(==) does not properly compare color values" <|
                \_ ->
                    Color.fromRGB ( 255, 0, 0 )
                        == Color.fromHSL ( 0, 100, 50 )
                        |> Expect.false "(==) compared color values unexpectedly"
            , describe "equals"
                [ test "when colors are identical, return true" <|
                    \_ ->
                        Color.fromHSL ( 0, 100, 50 )
                            |> Color.equals (Color.fromRGB ( 255, 0, 0 ))
                            |> Expect.true "Calling `equals` on identical colors failed"
                , test "when colors are not identical, return false" <|
                    \_ ->
                        Color.fromHSL ( 0, 100, 51 )
                            |> Color.equals (Color.fromRGB ( 255, 0, 0 ))
                            |> Expect.false "Calling `equals` on disparate colors failed"
                , test "when opacity differs, colors are not identical" <|
                    \_ ->
                        let
                            values =
                                { red = 0, green = 0, blue = 0, alpha = Opacity.transparent }
                        in
                        Color.fromRGBA values
                            |> Color.equals (Color.fromRGBA { values | alpha = Opacity.opaque })
                            |> Expect.false "Calling `equals` on different opacities failed"
                ]
            ]
        ]


luminanceSuite : Test
luminanceSuite =
    describe "luminance"
        [ test "white is very bright" <|
            \_ ->
                white
                    |> Color.luminance
                    |> floatEqual 1
        , test "gray is middlingly bright" <|
            \_ ->
                gray
                    |> Color.luminance
                    |> floatEqual 0.215
        , test "black is not very bright" <|
            \_ ->
                black
                    |> Color.luminance
                    |> floatEqual 0
        ]


floatEqual : Float -> Float -> Expectation
floatEqual =
    Expect.within (Expect.Absolute 0.01)


{-| This exists mostly to make float equality checks nicer.
-}
expectRGB : ( Int, Int, Int ) -> Color -> Expectation
expectRGB expected color =
    let
        ( r, g, b ) =
            Color.toRGB color
    in
    Expect.equal ( round r, round g, round b ) expected


{-| This exists mostly to make float equality checks nicer.
-}
expectHSL : ( Int, Int, Int ) -> Color -> Expectation
expectHSL expected color =
    let
        ( r, g, b ) =
            Color.toHSL color
    in
    Expect.equal ( round r, round g, round b ) expected


expectHex : String -> Result String Color -> Expectation
expectHex expected colorResult =
    case colorResult of
        Ok got ->
            Expect.equal expected (Color.toHexString got)

        Err err ->
            Expect.fail ("Could not parse color string: \n" ++ err)

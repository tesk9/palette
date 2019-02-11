module ColorSpec exposing (colorSpec, luminanceSuite)

import Color exposing (Color)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
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
                , fuzz hexStringFuzzer "fuzz Hex to Hex" <|
                    \hex ->
                        if String.length hex == 7 then
                            Color.fromHexString hex
                                |> expectHex hex

                        else if String.length hex == 4 then
                            let
                                fullLengthHexString =
                                    String.toList hex
                                        |> List.concatMap (\v -> [ v, v ])
                                        |> String.fromList
                                        |> String.dropLeft 1
                            in
                            Color.fromHexString hex
                                |> expectHex fullLengthHexString

                        else
                            Color.fromHexString hex
                                |> Expect.err
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
        , describe "between color models"
            [ test "from rgb black to hsl black" <|
                \_ ->
                    expectHSL ( 0, 0, 0 ) black
            , test "from hsl black to rgb black" <|
                \_ ->
                    expectRGB ( 0, 0, 0 ) blackHSL
            , test "from rgb white to hsl white" <|
                \_ ->
                    expectHSL ( 0, 0, 100 ) white
            , test "from hsl white to rgb white" <|
                \_ ->
                    expectRGB ( 255, 255, 255 ) whiteHSL
            , test "from rgb red to hsl red" <|
                \_ ->
                    Color.fromRGB ( 255, 0, 0 )
                        |> expectHSL ( 0, 100, 50 )
            , test "from hsl red to rgb red" <|
                \_ ->
                    Color.fromHSL ( 0, 100, 50 )
                        |> expectRGB ( 255, 0, 0 )
            , test "from rgb green to hsl green" <|
                \_ ->
                    Color.fromRGB ( 0, 128, 0 )
                        |> expectHSL ( 120, 100, 25 )
            , test "from hsl green to rgb green" <|
                \_ ->
                    Color.fromHSL ( 120, 100, 25 )
                        |> expectRGB ( 0, 128, 0 )
            , describe "from RGB to HSL and back to RGB again"
                (List.indexedMap rgbToHSLToRGB
                    [ ( 255, 0, 0 )
                    , ( 255, 165, 0 )
                    , ( 255, 255, 0 )
                    , ( 0, 255, 0 )
                    , ( 0, 0, 255 )
                    , ( 128, 0, 128 )
                    ]
                )
            , describe "from HSL to RGB and back to HSL again"
                (List.indexedMap hslToRGBtoHSL
                    [ ( 0, 100, 50 )
                    , ( 39, 100, 50 )
                    , ( 50, 100, 50 )
                    , ( 110, 100, 50 )
                    , ( 170, 100, 50 )
                    , ( 230, 100, 50 )
                    , ( 260, 100, 50 )
                    , ( 280, 100, 50 )
                    ]
                )
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
                ]
            ]
        ]


rgbToHSLToRGB : Int -> ( Float, Float, Float ) -> Test
rgbToHSLToRGB index (( r, g, b ) as color) =
    test (String.fromInt index ++ ": " ++ Color.toRGBString (Color.fromRGB color)) <|
        \_ ->
            Color.fromRGB color
                |> Color.toHSL
                |> Color.fromHSL
                |> expectRGB ( round r, round g, round b )


hslToRGBtoHSL : Int -> ( Float, Float, Float ) -> Test
hslToRGBtoHSL index (( h, s, l ) as color) =
    test (String.fromInt index ++ ": " ++ Color.toHSLString (Color.fromHSL color)) <|
        \_ ->
            Color.fromHSL color
                |> Color.toRGB
                |> Color.fromRGB
                |> expectHSL ( round h, round s, round l )


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


whiteHSL : Color
whiteHSL =
    Color.fromHSL ( 0, 0, 100 )


blackHSL : Color
blackHSL =
    Color.fromHSL ( 0, 0, 0 )


hexStringFuzzer : Fuzzer String
hexStringFuzzer =
    Fuzz.list hexCharFuzzer
        |> Fuzz.map (\charList -> "#" ++ String.fromList charList)


hexCharFuzzer : Fuzzer Char
hexCharFuzzer =
    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' ]
        |> List.map Fuzz.constant
        |> Fuzz.oneOf

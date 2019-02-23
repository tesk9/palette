module Internal.ColorSpec exposing (internalColorSpec)

import Color
import Expect exposing (Expectation)
import Internal.Color exposing (Color)
import Internal.ColorFuzzer exposing (hexStringOfLength)
import Opacity
import Test exposing (..)


internalColorSpec : Test
internalColorSpec =
    describe "Conversions & channel values"
        [ describe "toHSL"
            [ describe "from RGB color"
                [ test "black" <|
                    \_ ->
                        Internal.Color.fromRGB ( 0, 0, 0 )
                            |> Internal.Color.toHSL
                            |> expectTripleEquals ( 0, 0, 0 )
                , test "white" <|
                    \_ ->
                        Internal.Color.fromRGB ( 255, 255, 255 )
                            |> Internal.Color.toHSL
                            |> expectTripleEquals ( 0, 0, 100 )
                , test "red" <|
                    \_ ->
                        Internal.Color.fromRGB ( 255, 0, 0 )
                            |> Internal.Color.toHSL
                            |> expectTripleEquals ( 0, 100, 50 )
                , test "green" <|
                    \_ ->
                        Internal.Color.fromRGB ( 0, 128, 0 )
                            |> Internal.Color.toHSL
                            |> expectTripleEquals ( 120, 100, 25 )
                ]
            , describe "from HSL color"
                [ test "black" <|
                    \_ ->
                        Internal.Color.fromHSL ( 0, 0, 0 )
                            |> Internal.Color.toHSL
                            |> expectTripleEquals ( 0, 0, 0 )
                ]
            ]
        , describe "toRGB"
            [ describe "from RGB color"
                [ test "black" <|
                    \_ ->
                        Internal.Color.fromRGB ( 0, 0, 0 )
                            |> Internal.Color.toRGB
                            |> expectTripleEquals ( 0, 0, 0 )
                ]
            , describe "from HSL color"
                [ test "black" <|
                    \_ ->
                        Internal.Color.fromHSL ( 0, 0, 0 )
                            |> Internal.Color.toRGB
                            |> expectTripleEquals ( 0, 0, 0 )
                , test "white" <|
                    \_ ->
                        Internal.Color.fromHSL ( 0, 0, 100 )
                            |> Internal.Color.toRGB
                            |> expectTripleEquals ( 255, 255, 255 )
                , test "red" <|
                    \_ ->
                        Internal.Color.fromHSL ( 0, 100, 50 )
                            |> Internal.Color.toRGB
                            |> expectTripleEquals ( 255, 0, 0 )
                , test "green" <|
                    \_ ->
                        Internal.Color.fromHSL ( 120, 100, 25 )
                            |> Internal.Color.toRGB
                            |> expectTripleEquals ( 0, 128, 0 )
                ]
            ]
        , describe "from RGB to HSL and back to RGB again"
            (List.indexedMap testRGBToHSLToRGB
                [ ( 255, 0, 0 )
                , ( 255, 165, 0 )
                , ( 255, 255, 0 )
                , ( 0, 255, 0 )
                , ( 0, 0, 255 )
                , ( 128, 0, 128 )
                ]
            )
        , describe "from HSL to RGB and back to HSL again"
            (List.indexedMap testHSLToRGBtoHSL
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
        , fuzz (hexStringOfLength 6) "from Hex to RGB and back to Hex again" <|
            \c ->
                case Internal.Color.fromHexString c of
                    Just color ->
                        color
                            |> Internal.Color.toRGB
                            |> Internal.Color.fromRGB
                            |> Internal.Color.toHex
                            |> (\( r, b, g ) -> "#" ++ r ++ b ++ g)
                            |> Expect.equal c

                    Nothing ->
                        Expect.fail ("Could not construct a color from " ++ c ++ ". Is something wrong in the fuzzer?")
        ]


testRGBToHSLToRGB : Int -> ( Float, Float, Float ) -> Test
testRGBToHSLToRGB index color =
    let
        operations =
            Internal.Color.fromRGB
                >> Internal.Color.toHSL
                >> Internal.Color.fromHSL
                >> Internal.Color.toRGB

        rgbName =
            Color.toRGBString (Color.fromRGB color)
    in
    testReversibleOperations (nameTest index rgbName) color operations


testHSLToRGBtoHSL : Int -> ( Float, Float, Float ) -> Test
testHSLToRGBtoHSL index color =
    let
        operations =
            Internal.Color.fromHSL
                >> Internal.Color.toRGB
                >> Internal.Color.fromRGB
                >> Internal.Color.toHSL

        hslName =
            Color.toHSLString (Color.fromHSL color)
    in
    testReversibleOperations (nameTest index hslName) color operations


testReversibleOperations : String -> ( Float, Float, Float ) -> (( Float, Float, Float ) -> ( Float, Float, Float )) -> Test
testReversibleOperations testName color operations =
    test testName <|
        \_ ->
            expectTripleEquals color (operations color)


nameTest : Int -> String -> String
nameTest index color =
    String.fromInt index ++ ": " ++ color


expectTripleEquals : ( Float, Float, Float ) -> ( Float, Float, Float ) -> Expectation
expectTripleEquals expected actual =
    Expect.equal (roundTriple actual) (roundTriple expected)


roundTriple : ( Float, Float, Float ) -> ( Int, Int, Int )
roundTriple ( a, b, c ) =
    ( round a, round b, round c )

module Internal.ColorSpec exposing (internalColorSpec)

import Color
import Expect exposing (Expectation)
import Internal.Color exposing (Color)
import Internal.ColorFuzzer as ColorFuzz
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
        , fuzz ColorFuzz.hslValues "from HSL to RGB and back to HSL again" <|
            \(( _, s, l ) as color) ->
                let
                    operations =
                        Internal.Color.fromHSL
                            >> Internal.Color.toRGB
                            >> Internal.Color.fromRGB
                            >> Internal.Color.toHSL

                    hslName =
                        Color.toHSLString (Color.fromHSL color)
                in
                if l == 0 then
                    -- This is black, which has more representations in HSL space
                    -- than in RGB space.
                    expectTripleEquals ( 0, 0, 0 ) (operations color)

                else if l == 100 then
                    -- This is white, which has more representations in HSL space
                    -- than in RGB space.
                    expectTripleEquals ( 0, 0, 100 ) (operations color)

                else if s == 0 then
                    -- This is a fully-desaturated gray. It also has more representations
                    -- in HSL space than in RGB space.
                    expectTripleEquals ( 0, 0, l ) (operations color)

                else
                    expectTripleEquals color (operations color)
        , fuzz (ColorFuzz.hexStringOfLength 6) "from Hex to RGB and back to Hex again" <|
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

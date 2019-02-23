module Internal.ColorSpec exposing (internalColorSpec)

import Color
import Expect exposing (Expectation)
import Internal.Color exposing (Color)
import Internal.ColorFuzzer as ColorFuzz
import Internal.Hex
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
                        Color.fromRGB ( 0, 0, 0 )
                            |> Color.toRGB
                            |> expectTripleEquals ( 0, 0, 0 )
                ]
            , describe "from HSL color"
                [ test "black" <|
                    \_ ->
                        Color.fromHSL ( 0, 0, 0 )
                            |> Color.toRGB
                            |> expectTripleEquals ( 0, 0, 0 )
                , test "white" <|
                    \_ ->
                        Color.fromHSL ( 0, 0, 100 )
                            |> Color.toRGB
                            |> expectTripleEquals ( 255, 255, 255 )
                , test "red" <|
                    \_ ->
                        Color.fromHSL ( 0, 100, 50 )
                            |> Color.toRGB
                            |> expectTripleEquals ( 255, 0, 0 )
                , test "green" <|
                    \_ ->
                        Color.fromHSL ( 120, 100, 25 )
                            |> Color.toRGB
                            |> expectTripleEquals ( 0, 128, 0 )
                ]
            ]
        , fuzz ColorFuzz.hexValues "from RGB to HSL and back to RGB again" <|
            \color ->
                let
                    operations =
                        Internal.Color.fromRGB
                            >> Internal.Color.toHSL
                            >> Internal.Color.fromHSL
                            >> Internal.Color.toRGB
                            >> (\{ red, green, blue } -> ( red, green, blue ))

                    rgbName =
                        Color.toRGBString (Color.fromRGB color)
                in
                expectTripleEquals color (operations color)
        , fuzz ColorFuzz.hslValues "from HSL to RGB and back to HSL again" <|
            \(( _, s, l ) as color) ->
                let
                    operations =
                        Internal.Color.fromHSL
                            >> Internal.Color.toRGB
                            >> (\{ red, green, blue } -> ( red, green, blue ))
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
                case Internal.Hex.fromString c of
                    Just { red, green, blue } ->
                        ( red, green, blue )
                            |> Color.fromRGB
                            |> Color.toHexString
                            |> Expect.equal c

                    Nothing ->
                        Expect.fail ("Could not construct a color from " ++ c ++ ". Is something wrong in the fuzzer?")
        ]


expectTripleEquals : ( Float, Float, Float ) -> ( Float, Float, Float ) -> Expectation
expectTripleEquals expected actual =
    Expect.equal (roundTriple actual) (roundTriple expected)


roundTriple : ( Float, Float, Float ) -> ( Int, Int, Int )
roundTriple ( a, b, c ) =
    ( round a, round b, round c )

module Internal.ColorSpec exposing (internalColorSpec)

import Color
import Expect exposing (Expectation)
import Internal.Color exposing (Color)
import Opacity
import Test exposing (..)


internalColorSpec : Test
internalColorSpec =
    describe "between color models"
        [ test "from rgb black to hsl black" <|
            \_ ->
                expectHSL ( 0, 0, 0 ) blackRGB
        , test "from hsl black to rgb black" <|
            \_ ->
                expectRGB ( 0, 0, 0 ) blackHSL
        , test "from rgb white to hsl white" <|
            \_ ->
                expectHSL ( 0, 0, 100 ) whiteRGB
        , test "from hsl white to rgb white" <|
            \_ ->
                expectRGB ( 255, 255, 255 ) whiteHSL
        , test "from rgb red to hsl red" <|
            \_ ->
                Internal.Color.fromRGB ( 255, 0, 0 )
                    |> expectHSL ( 0, 100, 50 )
        , test "from hsl red to rgb red" <|
            \_ ->
                Internal.Color.fromHSL ( 0, 100, 50 )
                    |> expectRGB ( 255, 0, 0 )
        , test "from rgb green to hsl green" <|
            \_ ->
                Internal.Color.fromRGB ( 0, 128, 0 )
                    |> expectHSL ( 120, 100, 25 )
        , test "from hsl green to rgb green" <|
            \_ ->
                Internal.Color.fromHSL ( 120, 100, 25 )
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


rgbToHSLToRGB : Int -> ( Float, Float, Float ) -> Test
rgbToHSLToRGB index color =
    test (String.fromInt index ++ ": " ++ printRGBName color) <|
        \_ ->
            Internal.Color.fromRGB color
                |> Internal.Color.toHSL
                |> Internal.Color.fromHSL
                |> expectRGB color


hslToRGBtoHSL : Int -> ( Float, Float, Float ) -> Test
hslToRGBtoHSL index (( h, s, l ) as color) =
    test (nameTest index (printHSLName color)) <|
        \_ ->
            Internal.Color.fromHSL color
                |> Internal.Color.toRGB
                |> Internal.Color.fromRGB
                |> expectHSL color


nameTest : Int -> String -> String
nameTest index color =
    String.fromInt index ++ ": " ++ color


printRGBName : ( Float, Float, Float ) -> String
printRGBName =
    Color.toRGBString << Color.fromRGB


printHSLName : ( Float, Float, Float ) -> String
printHSLName =
    Color.toHSLString << Color.fromHSL


{-| This exists mostly to make float equality checks nicer.
-}
expectRGB : ( Float, Float, Float ) -> Color -> Expectation
expectRGB expected color =
    expectTripleEquals (Internal.Color.toRGB color) expected


{-| This exists mostly to make float equality checks nicer.
-}
expectHSL : ( Float, Float, Float ) -> Color -> Expectation
expectHSL expected color =
    expectTripleEquals (Internal.Color.toHSL color) expected


expectTripleEquals : ( Float, Float, Float ) -> ( Float, Float, Float ) -> Expectation
expectTripleEquals actual expected =
    Expect.equal (roundTriple actual) (roundTriple expected)


roundTriple : ( Float, Float, Float ) -> ( Int, Int, Int )
roundTriple ( a, b, c ) =
    ( round a, round b, round c )


whiteRGB : Color
whiteRGB =
    Internal.Color.fromRGB ( 255, 255, 255 )


whiteHSL : Color
whiteHSL =
    Internal.Color.fromHSL ( 0, 0, 100 )


blackRGB : Color
blackRGB =
    Internal.Color.fromRGB ( 0, 0, 0 )


blackHSL : Color
blackHSL =
    Internal.Color.fromHSL ( 0, 0, 0 )

module Internal.ColorSpec exposing (internalColorSpec)

import Color exposing (Color)
import Expect exposing (Expectation)
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


whiteRGB : Color
whiteRGB =
    Color.fromRGB ( 255, 255, 255 )


whiteHSL : Color
whiteHSL =
    Color.fromHSL ( 0, 0, 100 )


blackRGB : Color
blackRGB =
    Color.fromRGB ( 0, 0, 0 )


blackHSL : Color
blackHSL =
    Color.fromHSL ( 0, 0, 0 )

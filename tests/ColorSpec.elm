module ColorSpec exposing (colorSpec, luminanceSuite)

import Color exposing (Color)
import Expect exposing (Expectation)
import Fixtures exposing (..)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


colorSpec : Test
colorSpec =
    describe "Color"
        [ describe "to and from a Color"
            [ test "from RGB to RGB" <|
                \_ ->
                    Color.fromRGB ( -10, 123, 300 )
                        |> expectRGBValues ( 0, 123, 255 )
            , test "from HSL to HSL" <|
                \_ ->
                    Color.fromHSL ( -10, 123, -10 )
                        |> expectHSLValues ( 350, 100, 0 )
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
            ]
        , describe "between color models"
            [ test "from rgb black to hsl black" <|
                \_ ->
                    expectHSLValues ( 0, 0, 0 ) black
            , test "from hsl black to rgb black" <|
                \_ ->
                    expectRGBValues ( 0, 0, 0 ) blackHSL
            , test "from rgb white to hsl white" <|
                \_ ->
                    expectHSLValues ( 0, 0, 100 ) white
            , test "from hsl white to rgb white" <|
                \_ ->
                    expectRGBValues ( 255, 255, 255 ) whiteHSL
            , test "from rgb red to hsl red" <|
                \_ ->
                    Color.fromRGB ( 255, 0, 0 )
                        |> expectHSLValues ( 0, 100, 50 )
            , test "from hsl red to rgb red" <|
                \_ ->
                    Color.fromHSL ( 0, 100, 50 )
                        |> expectRGBValues ( 255, 0, 0 )
            , test "from rgb green to hsl green" <|
                \_ ->
                    Color.fromRGB ( 0, 128, 0 )
                        |> expectHSLValues ( 120, 100, 25 )
            , test "from hsl green to rgb green" <|
                \_ ->
                    Color.fromHSL ( 120, 100, 25 )
                        |> expectRGBValues ( 0, 128, 0 )
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
        ]


rgbToHSLToRGB : Int -> ( Float, Float, Float ) -> Test
rgbToHSLToRGB index (( r, g, b ) as color) =
    test (String.fromInt index ++ ": " ++ Color.toRGBString (Color.fromRGB color)) <|
        \_ ->
            Color.fromRGB color
                |> Color.toHSL
                |> Color.fromHSL
                |> expectRGBValues ( round r, round g, round b )


hslToRGBtoHSL : Int -> ( Float, Float, Float ) -> Test
hslToRGBtoHSL index (( h, s, l ) as color) =
    test (String.fromInt index ++ ": " ++ Color.toHSLString (Color.fromHSL color)) <|
        \_ ->
            Color.fromHSL color
                |> Color.toRGB
                |> Color.fromRGB
                |> expectHSLValues ( round h, round s, round l )


luminanceSuite : Test
luminanceSuite =
    describe "luminance"
        [ test "white is very bright" <|
            \_ ->
                white
                    |> Color.luminance
                    |> floatEqual 1
        , test "grey is middlingly bright" <|
            \_ ->
                grey
                    |> Color.luminance
                    |> floatEqual 0.18
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
expectRGBValues : ( Int, Int, Int ) -> Color -> Expectation
expectRGBValues expected color =
    let
        ( r, g, b ) =
            Color.toRGB color
    in
    Expect.equal ( round r, round g, round b ) expected


{-| This exists mostly to make float equality checks nicer.
-}
expectHSLValues : ( Int, Int, Int ) -> Color -> Expectation
expectHSLValues expected color =
    let
        ( r, g, b ) =
            Color.toHSL color
    in
    Expect.equal ( round r, round g, round b ) expected

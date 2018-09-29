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
                        |> Color.toRGB
                        |> Expect.equal ( 0, 123, 255 )
            , test "from HSL to HSL" <|
                \_ ->
                    Color.fromHSL ( -10, 123, -10 )
                        |> Color.toHSL
                        |> Expect.equal ( 10, 100, 0 )
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
                        |> Expect.equal "hsl(15,0,100)"
            ]
        , describe "between color models"
            [ test "from rgb black to hsl black" <|
                \_ ->
                    black
                        |> Color.toHSL
                        |> Expect.equal ( 0, 0, 0 )
            , test "from hsl black to rgb black" <|
                \_ ->
                    blackHSL
                        |> Color.toRGB
                        |> Expect.equal ( 0, 0, 0 )
            , test "from rgb white to hsl white" <|
                \_ ->
                    white
                        |> Color.toHSL
                        |> Expect.equal ( 0, 0, 100 )
            , test "from hsl white to rgb white" <|
                \_ ->
                    whiteHSL
                        |> Color.toRGB
                        |> Expect.equal ( 255, 255, 255 )
            , test "from rgb red to hsl red" <|
                \_ ->
                    Color.fromRGB ( 255, 0, 0 )
                        |> Color.toHSL
                        |> Expect.equal ( 0, 100, 50 )
            , test "from hsl red to rgb red" <|
                \_ ->
                    Color.fromHSL ( 0, 100, 50 )
                        |> Color.toRGB
                        |> Expect.equal ( 255, 0, 0 )
            , test "from rgb green to hsl green" <|
                \_ ->
                    Color.fromRGB ( 0, 128, 0 )
                        |> Color.toHSL
                        |> Expect.equal ( 120, 100, 25 )
            , test "from hsl green to rgb green" <|
                \_ ->
                    Color.fromHSL ( 120, 100, 25 )
                        |> Color.toRGB
                        |> Expect.equal ( 0, 128, 0 )
            , test "from RGB to HSL and back to RGB again" <|
                \_ ->
                    Color.fromRGB ( 255, 0, 0 )
                        |> Color.toHSL
                        |> Color.fromHSL
                        |> Color.toRGB
                        |> Expect.equal ( 255, 0, 0 )
            , test "from HSL to RGB and back to HSL again" <|
                \_ ->
                    Color.fromHSL ( 3, 4, 5 )
                        |> Color.toRGB
                        |> Color.fromRGB
                        |> Color.toHSL
                        |> Expect.equal ( 3, 4, 5 )
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

module ColorSpec exposing (colorSpec, luminanceSuite)

import Color exposing (Color)
import Expect exposing (Expectation)
import Fixtures exposing (black, blackHSL, grey, greyHSL, white, whiteHSL)
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
            [ test "from RGB to HSL and back to RGB again" <|
                \_ ->
                    Color.fromRGB ( 3, 4, 5 )
                        |> Color.toHSL
                        |> Color.fromHSL
                        |> Color.toRGB
                        |> Expect.equal ( 3, 4, 5 )
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

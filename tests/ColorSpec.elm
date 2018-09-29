module ColorSpec exposing (colorSpec, luminanceSuite)

import Color exposing (Color)
import Expect exposing (Expectation)
import Fixtures exposing (black, grey, white)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


colorSpec : Test
colorSpec =
    describe "Color"
        [ test "to and from a Color" <|
            \_ ->
                Color.fromRGB ( -10, 123, 300 )
                    |> Color.toRGB
                    |> Expect.equal ( 0, 123, 255 )
        , test "to a String" <|
            \_ ->
                Color.fromRGB ( -10, 123, 300 )
                    |> Color.toRGBString
                    |> Expect.equal "rgb(0,123,255)"
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

module ColorSpec exposing (colorSpec)

import Color exposing (Color)
import Expect exposing (Expectation)
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
        ]

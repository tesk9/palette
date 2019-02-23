module OpacitySpec exposing (spec)

import Expect exposing (Expectation)
import Opacity
import Test exposing (..)


spec : Test
spec =
    describe "Opacity"
        [ test "custom bottom bound" <|
            \_ ->
                Expect.equal
                    (Opacity.custom -0.2)
                    Opacity.transparent
        , test "custom upper bound" <|
            \_ ->
                Expect.equal
                    (Opacity.custom 1.2)
                    Opacity.opaque
        , test "toFloat and toString" <|
            \_ ->
                let
                    opacity =
                        Opacity.custom 0.392408
                in
                Expect.equal
                    (Opacity.toFloat opacity |> String.fromFloat)
                    (Opacity.toString opacity)
        ]

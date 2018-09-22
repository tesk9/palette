module ContrastSpec exposing (contrastSuite, sufficientContrastSuite)

import Color exposing (Color)
import Contrast
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


white : Color
white =
    Color.fromRGB ( 255, 255, 255 )


grey : Color
grey =
    Color.fromRGB ( 46, 46, 46 )


black : Color
black =
    Color.fromRGB ( 0, 0, 0 )


contrastSuite : Test
contrastSuite =
    describe "contrast"
        [ describe "black and white"
            [ test "contrast black white == contrast white black" <|
                \_ ->
                    Expect.equal (Contrast.contrast black white) (Contrast.contrast white black)
            , test "contrast black white" <|
                \_ ->
                    Contrast.contrast black white
                        |> floatEqual 21
            , test "contrast white grey" <|
                \_ ->
                    Contrast.contrast white grey
                        |> floatEqual (4.5 / 1)
            , test "contrast white white" <|
                \_ ->
                    Contrast.contrast white white
                        |> floatEqual 1
            , test "contrast black black" <|
                \_ ->
                    Contrast.contrast black black
                        |> floatEqual 1
            ]
        ]


sufficientContrastSuite : Test
sufficientContrastSuite =
    describe "sufficientContrast"
        [ describe "Regular sized text" <|
            let
                fontSize =
                    12

                fontWeight =
                    300
            in
            [ describe "WCAG AA" <|
                let
                    subject =
                        Contrast.sufficientContrast Contrast.AA fontSize fontWeight
                in
                [ test "black and white has sufficient contrast" <|
                    \_ ->
                        subject white black
                            |> Expect.true "Expected black and white to have sufficient contrast."
                , test "grey and white do not have sufficient contrast" <|
                    \_ ->
                        subject white grey
                            |> Expect.false "Expected grey and white not to have sufficient contrast."
                ]
            , describe "WCAG AAA" <|
                let
                    subject =
                        Contrast.sufficientContrast Contrast.AAA fontSize fontWeight
                in
                [ test "black and white has sufficient contrast" <|
                    \_ ->
                        subject white black
                            |> Expect.true "Expected black and white to have sufficient contrast."
                , test "grey and white do not have sufficient contrast" <|
                    \_ ->
                        subject white grey
                            |> Expect.false "Expected grey and white not to have sufficient contrast."
                ]
            ]
        , describe "Large text" <|
            let
                fontSize =
                    19

                fontWeight =
                    300
            in
            [ describe "WCAG AA" <|
                let
                    subject =
                        Contrast.sufficientContrast Contrast.AA fontSize fontWeight
                in
                [ test "black and white has sufficient contrast" <|
                    \_ ->
                        subject white black
                            |> Expect.true "Expected black and white to have sufficient contrast."
                , test "grey and white do has sufficient contrast" <|
                    \_ ->
                        subject white grey
                            |> Expect.true "Expected grey and white to have sufficient contrast."
                ]
            , describe "WCAG AAA" <|
                let
                    subject =
                        Contrast.sufficientContrast Contrast.AAA fontSize fontWeight
                in
                [ test "black and white has sufficient contrast" <|
                    \_ ->
                        subject white black
                            |> Expect.true "Expected black and white to have sufficient contrast."
                , test "grey and white do not have sufficient contrast" <|
                    \_ ->
                        subject white grey
                            |> Expect.true "Expected grey and white not to have sufficient contrast."
                ]
            ]
        ]


floatEqual : Float -> Float -> Expectation
floatEqual =
    Expect.within (Expect.Absolute 0.000000001)

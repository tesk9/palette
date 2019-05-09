module OpaqueColor.ContrastSpec exposing (contrastSuite, sufficientContrastSuite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import OpaqueColor exposing (OpaqueColor)
import OpaqueColor.Contrast as Contrast
import Palette.X11 exposing (..)
import Test exposing (..)


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
            , test "contrast white gray" <|
                \_ ->
                    Contrast.contrast white gray
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
                font =
                    { fontSize = 12, fontWeight = 300 }
            in
            [ describe "WCAG AA" <|
                let
                    subject =
                        Contrast.sufficientContrast Contrast.AA font
                in
                [ test "black and white has sufficient contrast" <|
                    \_ ->
                        subject white black
                            |> Expect.true "Expected black and white to have sufficient contrast."
                , test "gray and white do not have sufficient contrast" <|
                    \_ ->
                        subject white gray
                            |> Expect.true "Expected gray and white to have sufficient contrast."
                ]
            , describe "WCAG AAA" <|
                let
                    subject =
                        Contrast.sufficientContrast Contrast.AAA font
                in
                [ test "black and white has sufficient contrast" <|
                    \_ ->
                        subject white black
                            |> Expect.true "Expected black and white to have sufficient contrast."
                , test "gray and white do not have sufficient contrast" <|
                    \_ ->
                        subject white gray
                            |> Expect.false "Expected gray and white not to have sufficient contrast."
                ]
            ]
        , describe "Large text" <|
            let
                font =
                    { fontSize = 19, fontWeight = 300 }
            in
            [ describe "WCAG AA" <|
                let
                    subject =
                        Contrast.sufficientContrast Contrast.AA font
                in
                [ test "black and white has sufficient contrast" <|
                    \_ ->
                        subject white black
                            |> Expect.true "Expected black and white to have sufficient contrast."
                , test "gray and white has sufficient contrast" <|
                    \_ ->
                        subject white gray
                            |> Expect.true "Expected gray and white to have sufficient contrast."
                ]
            , describe "WCAG AAA" <|
                let
                    subject =
                        Contrast.sufficientContrast Contrast.AAA font
                in
                [ test "black and white has sufficient contrast" <|
                    \_ ->
                        subject white black
                            |> Expect.true "Expected black and white to have sufficient contrast."
                , test "gray and white to have sufficient contrast" <|
                    \_ ->
                        subject white gray
                            |> Expect.true "Expected gray and white to have sufficient contrast."
                ]
            ]
        ]


floatEqual : Float -> Float -> Expectation
floatEqual =
    Expect.within (Expect.Absolute 0.1)


gray : OpaqueColor
gray =
    OpaqueColor.fromRGB ( 118, 118, 118 )

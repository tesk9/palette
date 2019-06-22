module Colour.AccessibilitySpec exposing
    ( contrastSuite
    , sufficientContrastSuite
    )

import Colour.Accessibility
import Expect exposing (Expectation)
import Opacity
import OpaqueColor exposing (OpaqueColor)
import OpaqueColorFuzzer exposing (hexStringOfLength)
import Palette.X11 exposing (black, white)
import Test exposing (..)


gray : OpaqueColor
gray =
    OpaqueColor.fromRGB ( 118, 118, 118 )


contrastSuite : Test
contrastSuite =
    describe "contrast"
        [ describe "black and white"
            [ test "contrast black white == contrast white black" <|
                \_ ->
                    Expect.equal
                        (Colour.Accessibility.contrast black white)
                        (Colour.Accessibility.contrast white black)
            , test "contrast black white" <|
                \_ ->
                    Colour.Accessibility.contrast black white
                        |> floatEqual 21
            , test "contrast white gray" <|
                \_ ->
                    Colour.Accessibility.contrast white gray
                        |> floatEqual (4.5 / 1)
            , test "contrast white white" <|
                \_ ->
                    Colour.Accessibility.contrast white white
                        |> floatEqual 1
            , test "contrast black black" <|
                \_ ->
                    Colour.Accessibility.contrast black black
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
                        Colour.Accessibility.sufficientContrast
                            Colour.Accessibility.AA
                            font
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
                        Colour.Accessibility.sufficientContrast
                            Colour.Accessibility.AAA
                            font
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
                        Colour.Accessibility.sufficientContrast
                            Colour.Accessibility.AA
                            font
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
                        Colour.Accessibility.sufficientContrast
                            Colour.Accessibility.AAA
                            font
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



--Test helpers


floatEqual : Float -> Float -> Expectation
floatEqual =
    Expect.within (Expect.Absolute 0.1)

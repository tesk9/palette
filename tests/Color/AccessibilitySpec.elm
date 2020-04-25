module Color.AccessibilitySpec exposing
    ( checkContrastSuite
    , contrastSuite
    , ratingSuite
    )

import ColorFuzzer exposing (hexStringOfLength)
import Expect exposing (Expectation)
import Palette.X11 exposing (black, white)
import SolidColor exposing (SolidColor)
import SolidColor.Accessibility exposing (..)
import Test exposing (..)


gray : SolidColor
gray =
    SolidColor.fromRGB ( 118, 118, 118 )


contrastSuite : Test
contrastSuite =
    describe "contrast"
        [ describe "black and white"
            [ test "contrast black white == contrast white black" <|
                \_ ->
                    Expect.equal
                        (contrast black white)
                        (contrast white black)
            , test "contrast black white" <|
                \_ ->
                    contrast black white
                        |> floatEqual 21
            , test "contrast white gray" <|
                \_ ->
                    contrast white gray
                        |> floatEqual (4.5 / 1)
            , test "contrast white white" <|
                \_ ->
                    contrast white white
                        |> floatEqual 1
            , test "contrast black black" <|
                \_ ->
                    contrast black black
                        |> floatEqual 1
            ]
        ]


checkContrastSuite : Test
checkContrastSuite =
    describe "checkContrast"
        [ describe "Regular sized text" <|
            let
                subject =
                    checkContrast { fontSize = 12, fontWeight = 300 }
            in
            [ test "black and white has sufficient contrast for AA standard" <|
                \_ ->
                    subject white black
                        |> meetsAA
                        |> Expect.true "Expected black and white to have sufficient contrast."
            , test "gray and white have sufficient contrast for AA standard" <|
                \_ ->
                    subject white gray
                        |> meetsAA
                        |> Expect.true "Expected gray and white to have sufficient contrast."
            , test "black and white has sufficient contrast" <|
                \_ ->
                    subject white black
                        |> meetsAAA
                        |> Expect.true "Expected black and white to have sufficient contrast."
            , test "gray and white do not have sufficient contrast" <|
                \_ ->
                    subject white gray
                        |> meetsAAA
                        |> Expect.false "Expected gray and white not to have sufficient contrast."
            ]
        , describe "Large text" <|
            let
                subject =
                    checkContrast { fontSize = 19, fontWeight = 300 }
            in
            [ test "black and white has sufficient contrast to meet AA standard" <|
                \_ ->
                    subject white black
                        |> meetsAA
                        |> Expect.true "Expected black and white to have sufficient contrast."
            , test "gray and white has sufficient contrast to meet AA standard" <|
                \_ ->
                    subject white gray
                        |> meetsAA
                        |> Expect.true "Expected gray and white to have sufficient contrast."
            , test "black and white has sufficient contrast to meet AAA standard" <|
                \_ ->
                    subject white black
                        |> meetsAAA
                        |> Expect.true "Expected black and white to have sufficient contrast."
            , test "gray and white to have sufficient contrast to meet AAA standard" <|
                \_ ->
                    subject white gray
                        |> meetsAAA
                        |> Expect.true "Expected gray and white to have sufficient contrast."
            ]
        ]


ratingSuite : Test
ratingSuite =
    describe "Rating"
        [ describe "meetsAA"
            [ test "Inaccessible" <|
                \_ ->
                    Expect.equal False (meetsAA Inaccessible)
            , test "AA" <|
                \_ ->
                    Expect.equal True (meetsAA AA)
            , test "AAA" <|
                \_ ->
                    Expect.equal True (meetsAA AAA)
            ]
        , describe "meetsAAA"
            [ test "Inaccessible" <|
                \_ ->
                    Expect.equal False (meetsAAA Inaccessible)
            , test "AA" <|
                \_ ->
                    Expect.equal False (meetsAAA AA)
            , test "AAA" <|
                \_ ->
                    Expect.equal True (meetsAAA AAA)
            ]
        ]



--Test helpers


floatEqual : Float -> Float -> Expectation
floatEqual =
    Expect.within (Expect.Absolute 0.1)

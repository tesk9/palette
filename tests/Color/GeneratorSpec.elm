module Color.GeneratorSpec exposing (highContrastSuite, invertSuite)

import Color exposing (Color)
import Color.Contrast as Contrast
import Color.Generator as Generator
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Palette.X11 exposing (..)
import Test exposing (..)


highContrastSuite : Test
highContrastSuite =
    describe "highContrast"
        [ describe "black and white"
            [ test "highContrast black == white" <|
                \_ ->
                    expectColorsEqual (Generator.highContrast black) white
            , test "highContrast white == black" <|
                \_ ->
                    expectColorsEqual (Generator.highContrast white) black
            , describe "highContrast grays"
                (List.map
                    (\( color, name ) ->
                        test name <|
                            \_ ->
                                color
                                    |> Generator.highContrast
                                    |> Contrast.contrast color
                                    |> Expect.greaterThan 4.5
                    )
                    grays
                )
            ]
        ]


grays : List ( Color, String )
grays =
    [ ( gainsboro, "gainsboro" )
    , ( lightGray, "lightGray" )
    , ( silver, "silver" )
    , ( darkGray, "darkGray" )
    , ( gray, "gray" )
    , ( dimGray, "dimGray" )
    , ( lightSlateGray, "lightSlateGray" )
    , ( slateGray, "slateGray" )
    , ( darkSlateGray, "darkSlateGray" )
    , ( black, "black" )
    ]


invertSuite : Test
invertSuite =
    describe "invert"
        [ describe "black and white"
            [ test "invert black == white" <|
                \_ ->
                    expectColorsEqual (Generator.invert black) white
            , test "invert white == black" <|
                \_ ->
                    expectColorsEqual (Generator.invert white) black
            ]
        ]


expectColorsEqual : Color -> Color -> Expectation
expectColorsEqual a b =
    Expect.equal (Color.toRGBString a) (Color.toRGBString b)

module Color.GeneratorSpec exposing (highContrastSuite)

import Color exposing (Color)
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
            ]
        ]


expectColorsEqual : Color -> Color -> Expectation
expectColorsEqual a b =
    Expect.equal (Color.toRGBString a) (Color.toRGBString b)

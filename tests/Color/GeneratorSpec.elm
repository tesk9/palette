module Color.GeneratorSpec exposing (highestContrastSuite)

import Color exposing (Color)
import Color.Generator as Generator
import Expect exposing (Expectation)
import Fixtures exposing (black, grey, white)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


highestContrastSuite : Test
highestContrastSuite =
    describe "highestContrast"
        [ describe "black and white"
            [ test "highestContrast black == white" <|
                \_ ->
                    expectColorsEqual (Generator.highestContrast black) white
            , test "highestContrast white == black" <|
                \_ ->
                    expectColorsEqual (Generator.highestContrast white) black
            ]
        ]


expectColorsEqual : Color -> Color -> Expectation
expectColorsEqual a b =
    Expect.equal (Color.toRGBString a) (Color.toRGBString b)

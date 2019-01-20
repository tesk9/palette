module Palette.CubehelixSpec exposing (cubehelixRotationsSpec)

import Color exposing (Color)
import Expect exposing (Expectation)
import Fuzz
import Palette.Cubehelix as Cubehelix
import Palette.X11 exposing (black, blue, red, white)
import Test exposing (..)


cubehelixRotationsSpec : Test
cubehelixRotationsSpec =
    describe "generate"
        [ describe "numLevels"
            [ test "negative numLevels" <|
                \() ->
                    Cubehelix.generate { emptyConfig | numLevels = -1 }
                        |> List.length
                        |> Expect.equal 0
            , test "numLevels = 0" <|
                \() ->
                    assertGeneratesNumLevels 0
            , test "numLevels = 1" <|
                \() ->
                    assertGeneratesNumLevels 1
            , fuzz (Fuzz.intRange 0 256) "numLevels fuzz" <|
                \number ->
                    assertGeneratesNumLevels number
            , test "numLevels large numbers" <|
                \() ->
                    assertGeneratesNumLevels 1000
            ]
        , describe "starting color"
            [ only <|
                test "start = 0 is blue" <|
                    \() ->
                        assertStartingColor 0 blue
            , test "start = 1 is red" <|
                \() ->
                    assertStartingColor 1 red
            , test "start = 2 is green" <|
                \() ->
                    assertStartingColor 2 (Color.fromRGB ( 0, 255, 0 ))
            , test "start = 3 is blue" <|
                \() ->
                    assertStartingColor 3 blue
            ]
        , test "without hue" <|
            \() ->
                -- When the hue is zero, we should go straight to from black to white.
                case Cubehelix.generate { emptyConfig | numLevels = 2 } of
                    start :: end :: [] ->
                        expectColorsEqual white end

                    _ ->
                        Expect.fail "Uh oh -- `generate` didn't return the right number of levels."
        ]


assertGeneratesNumLevels : Int -> Expectation
assertGeneratesNumLevels numLevels =
    Cubehelix.generate { emptyConfig | numLevels = numLevels }
        |> List.length
        |> Expect.equal numLevels


assertStartingColor : Float -> Color -> Expectation
assertStartingColor startingAngle color =
    case Cubehelix.generate { emptyConfig | numLevels = 1, start = startingAngle } of
        start :: [] ->
            expectColorsEqual color start

        _ ->
            Expect.fail "Uh oh -- `generate` didn't return the right number of levels. See `assertStartingColor`."


emptyConfig : Cubehelix.AdvancedConfig
emptyConfig =
    { start = 0
    , rotations = 1
    , saturation = 0.5
    , gamma = 0
    , numLevels = 0
    }


expectColorsEqual : Color -> Color -> Expectation
expectColorsEqual a b =
    Expect.equal (Color.toRGBString a) (Color.toRGBString b)

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
        , describe "without saturation"
            -- When the saturation is zero, we should go straight to from black to white.
            [ test "starting red" <|
                \() ->
                    assertEndingColor 1 white
            , test "starting green" <|
                \() ->
                    assertEndingColor 2 white
            , test "starting blue" <|
                \() ->
                    assertEndingColor 3 white
            , test "middle colors are grayscale" <|
                \() ->
                    assertMiddleColor (Color.fromRGB ( 127.5, 127.5, 127.5 ))
            ]
        ]


assertGeneratesNumLevels : Int -> Expectation
assertGeneratesNumLevels numLevels =
    Cubehelix.generate { emptyConfig | numLevels = numLevels }
        |> List.length
        |> Expect.equal numLevels


assertMiddleColor : Color -> Expectation
assertMiddleColor color =
    case Cubehelix.generate { emptyConfig | numLevels = 3, saturation = 0 } of
        start :: middle :: tail ->
            expectColorsEqual color middle

        _ ->
            Expect.fail "Uh oh -- `generate` didn't return the right number of levels. See `assertEndingColor`."


assertEndingColor : Float -> Color -> Expectation
assertEndingColor startingAngle color =
    case Cubehelix.generate { emptyConfig | numLevels = 2, saturation = 0, start = startingAngle } of
        start :: end :: [] ->
            expectColorsEqual color end

        _ ->
            Expect.fail "Uh oh -- `generate` didn't return the right number of levels. See `assertEndingColor`."


emptyConfig : Cubehelix.AdvancedConfig
emptyConfig =
    { start = 0
    , rotations = 1
    , saturation = 0.5
    , gamma = 1
    , numLevels = 0
    }


expectColorsEqual : Color -> Color -> Expectation
expectColorsEqual a b =
    Expect.equal (Color.toRGBString a) (Color.toRGBString b)

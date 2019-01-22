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
                    assertEndingColor (Color.fromHSL ( 0, 0, 100 )) white
            , test "starting green" <|
                \() ->
                    assertEndingColor (Color.fromHSL ( 120, 0, 100 )) white
            , test "starting blue" <|
                \() ->
                    assertEndingColor (Color.fromHSL ( 240, 0, 100 )) white
            , test "middle colors are grayscale" <|
                \() ->
                    assertSecondColor
                        { config = { emptyConfig | numLevels = 3, startingColor = Color.fromHSL ( 0, 0, 0 ) }
                        , expected = Color.fromRGB ( 127.5, 127.5, 127.5 )
                        }
            , describe "rotation direction" <|
                [ test "starting red, we should move through greens fastest with RGB direction" <|
                    \() ->
                        Cubehelix.generate
                            { startingColor = red
                            , rotationDirection = Cubehelix.RGB
                            , rotations = 1
                            , gamma = 1
                            , numLevels = 3
                            }
                            |> sumRGB
                            |> (\( rSum, gSum, bSum ) -> Expect.true "More greens than reds and blues" (rSum < gSum && bSum < gSum))
                ]
            ]
        ]


sumRGB : List Color -> ( Float, Float, Float )
sumRGB colors =
    colors
        |> List.map Color.toRGB
        |> List.foldl (\( r, g, b ) ( rSum, bSum, gSum ) -> ( rSum + r, gSum + g, bSum + b )) ( 0, 0, 0 )


assertGeneratesNumLevels : Int -> Expectation
assertGeneratesNumLevels numLevels =
    Cubehelix.generate { emptyConfig | numLevels = numLevels }
        |> List.length
        |> Expect.equal numLevels


assertSecondColor : { config : Cubehelix.AdvancedConfig, expected : Color } -> Expectation
assertSecondColor { config, expected } =
    case Cubehelix.generate config of
        start :: second :: tail ->
            expectColorsEqual expected second

        _ ->
            Expect.fail "Uh oh -- `generate` didn't return the right number of levels. See `assertEndingColor`."


assertEndingColor : Color -> Color -> Expectation
assertEndingColor startingColor color =
    case Cubehelix.generate { emptyConfig | numLevels = 2, startingColor = startingColor } of
        start :: end :: [] ->
            expectColorsEqual color end

        _ ->
            Expect.fail "Uh oh -- `generate` didn't return the right number of levels. See `assertEndingColor`."


emptyConfig : Cubehelix.AdvancedConfig
emptyConfig =
    { startingColor = red
    , rotationDirection = Cubehelix.RGB
    , rotations = 1
    , gamma = 1
    , numLevels = 0
    }


expectColorsEqual : Color -> Color -> Expectation
expectColorsEqual a b =
    Expect.equal (Color.toRGBString a) (Color.toRGBString b)

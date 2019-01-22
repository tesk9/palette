module Palette.CubehelixSpec exposing (cubehelixRotationsSpec)

import Color exposing (Color)
import Expect exposing (Expectation)
import Fuzz
import Palette.Cubehelix as Cubehelix exposing (defaultConfig)
import Palette.X11 exposing (black, blue, red, white)
import Test exposing (..)


cubehelixRotationsSpec : Test
cubehelixRotationsSpec =
    describe "generate"
        [ describe "numLevels"
            [ test "negative numLevels" <|
                \() ->
                    Cubehelix.generate { defaultConfig | numLevels = -1 }
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
                    Cubehelix.generate { defaultConfig | numLevels = 1000 }
                        |> List.length
                        |> Expect.equal 256
            ]
        , describe "without saturation"
            [ test "middle colors are grayscale" <|
                \() ->
                    assertSecondColor
                        { config = { defaultConfig | numLevels = 3, startingColor = Color.fromHSL ( 0, 0, 0 ) }
                        , expected = Color.fromRGB ( 127.5, 127.5, 127.5 )
                        }
            ]
        , describe "rotation direction" <|
            let
                generate direction =
                    Cubehelix.generate
                        { startingColor = red
                        , rotationDirection = direction
                        , rotations = 1.2
                        , gamma = 1
                        , numLevels = 3
                        }
            in
            [ test "starting red, we should move through greens fastest with RGB direction" <|
                \() ->
                    generate Cubehelix.RGB
                        |> sumRGB
                        |> (\( rSum, gSum, bSum ) -> Expect.true "More greens than reds and blues" (rSum < gSum && bSum < gSum))
            , test "starting red, we should move through blues fastest with BGR direction" <|
                \() ->
                    generate Cubehelix.BGR
                        |> sumRGB
                        |> (\( rSum, gSum, bSum ) -> Expect.true "More blues than reds and greens" (rSum < bSum && gSum < bSum))
            ]
        ]


sumRGB : List Color -> ( Float, Float, Float )
sumRGB colors =
    colors
        |> List.map Color.toRGB
        |> List.foldl (\( r, g, b ) ( rSum, bSum, gSum ) -> ( rSum + r, gSum + g, bSum + b )) ( 0, 0, 0 )


assertGeneratesNumLevels : Int -> Expectation
assertGeneratesNumLevels numLevels =
    Cubehelix.generate { defaultConfig | numLevels = numLevels }
        |> List.length
        |> Expect.equal numLevels


assertSecondColor : { config : Cubehelix.AdvancedConfig, expected : Color } -> Expectation
assertSecondColor { config, expected } =
    case Cubehelix.generate config of
        start :: second :: tail ->
            expectColorsEqual expected second

        _ ->
            Expect.fail "Uh oh -- `generate` didn't return the right number of levels. See `assertEndingColor`."


expectColorsEqual : Color -> Color -> Expectation
expectColorsEqual a b =
    Expect.equal (Color.toRGBString a) (Color.toRGBString b)

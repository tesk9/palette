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
                    List.length (Cubehelix.generate -1)
                        |> Expect.equal 0
            , test "numLevels = 0" <|
                \() ->
                    List.length (Cubehelix.generate 0)
                        |> Expect.equal 0
            , test "numLevels = 1" <|
                \() ->
                    List.length (Cubehelix.generate 1)
                        |> Expect.equal 1
            , fuzz (Fuzz.intRange 0 256) "numLevels fuzz" <|
                \number ->
                    List.length (Cubehelix.generate number)
                        |> Expect.equal number
            , test "numLevels large numbers" <|
                \() ->
                    List.length (Cubehelix.generate 1000)
                        |> Expect.equal 256
            ]
        , describe "without saturation"
            [ test "middle colors are grayscale" <|
                \() ->
                    let
                        config =
                            { defaultConfig | startingColor = Color.fromHSL ( 0, 0, 0 ) }
                    in
                    case Cubehelix.generateAdvanced 3 config of
                        start :: second :: tail ->
                            Expect.equal "rgb(127.5,127.5,127.5)" (Color.toRGBString second)

                        _ ->
                            Expect.fail "Uh oh -- `generate` didn't return the right number of levels."
            ]
        , describe "rotation direction" <|
            let
                generate direction =
                    Cubehelix.generateAdvanced 3
                        { defaultConfig | startingColor = red, rotationDirection = direction }

                sumRGB : List Color -> ( Float, Float, Float )
                sumRGB colors =
                    colors
                        |> List.map Color.toRGB
                        |> List.foldl (\( r, g, b ) ( rSum, bSum, gSum ) -> ( rSum + r, gSum + g, bSum + b )) ( 0, 0, 0 )
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

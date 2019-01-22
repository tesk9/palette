module PaletteExamples.Cubehelix exposing (examples)

import Color
import Color.Generator exposing (adjustSaturation)
import Comparison
import ExampleHelpers as Example
import Html exposing (Html)
import Html.Attributes exposing (style)
import Palette.Cubehelix as Cubehelix exposing (defaultConfig)


examples : Html msg
examples =
    Example.subsection "Cubehelix"
        (Html.div []
            [ Html.h3 [] [ Html.text "Number of levels" ]
            , Example.list
                [ ( Cubehelix.generate { defaultConfig | numLevels = 2 }
                  , "Cubehelix.generate { defaultConfig | numLevels = 2 }"
                  )
                , ( Cubehelix.generate { defaultConfig | numLevels = 5 }
                  , "Cubehelix.generate { defaultConfig | numLevels = 5 }"
                  )
                , ( Cubehelix.generate { defaultConfig | numLevels = 10 }
                  , "Cubehelix.generate { defaultConfig | numLevels = 10 }"
                  )
                , ( Cubehelix.generate { defaultConfig | numLevels = 100 }
                  , "Cubehelix.generate { defaultConfig | numLevels = 100 }"
                  )
                , ( Cubehelix.generate { defaultConfig | numLevels = 256 }
                  , "Cubehelix.generate { defaultConfig | numLevels = 256 }"
                  )
                ]
                viewExample
            , Html.h4 [] [ Html.text "Rotation direction" ]
            , Example.list
                [ ( Cubehelix.generate { defaultConfig | rotationDirection = Cubehelix.BGR, startingColor = Color.fromRGB ( 255, 0, 0 ) }
                  , "Cubehelix.generate { defaultConfig | rotationDirection = Cubehelix.BGR, startingColor = Color.fromRGB (255, 0, 0 ) }"
                  )
                , ( Cubehelix.generate { defaultConfig | rotationDirection = Cubehelix.RGB, startingColor = Color.fromRGB ( 255, 0, 0 ) }
                  , "Cubehelix.generate { defaultConfig | rotationDirection = Cubehelix.RGB, startingColor = Color.fromRGB (255, 0, 0 ) }"
                  )
                ]
                viewExample
            , Html.h4 [] [ Html.text "Rotation count" ]
            , Example.list
                [ ( Cubehelix.generate { defaultConfig | rotations = 0 }
                  , "Cubehelix.generate { defaultConfig | rotations = 0 }"
                  )
                , ( Cubehelix.generate { defaultConfig | rotationDirection = Cubehelix.RGB, rotations = 1 }
                  , "Cubehelix.generate { defaultConfig | rotationDirection = Cubehelix.RGB, rotations = 1 }"
                  )
                , ( Cubehelix.generate { defaultConfig | rotationDirection = Cubehelix.RGB, rotations = 1.5 }
                  , "Cubehelix.generate { defaultConfig | rotationDirection = Cubehelix.RGB, rotations = 1.5 }"
                  )
                ]
                viewExample
            , Html.h4 [] [ Html.text "Gamma factor" ]
            , Example.list
                [ ( Cubehelix.generate { defaultConfig | gamma = 0.25 }
                  , "Cubehelix.generate { defaultConfig | gamma = 0.25  }"
                  )
                , ( Cubehelix.generate { defaultConfig | gamma = 0.75 }
                  , "Cubehelix.generate { defaultConfig | gamma = 0.75  }"
                  )
                , ( Cubehelix.generate { defaultConfig | gamma = 1.75 }
                  , "Cubehelix.generate { defaultConfig | gamma = 1.75  }"
                  )
                ]
                viewExample
            , Html.h4 [] [ Html.text "Starting color, adjusting saturation" ]
            , Example.list
                [ ( Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 0, 0, 0 ), numLevels = 10 }
                  , "Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 0, 0, 0 ), numLevels = 10 }"
                  )
                , ( Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 0, 50, 0 ), numLevels = 10 }
                  , "Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 0, 50, 0 ), numLevels = 10 }"
                  )
                , ( Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 0, 100, 0 ), numLevels = 10 }
                  , "Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 0, 100, 0 ), numLevels = 10 }"
                  )
                ]
                viewExample
            , Html.h4 [] [ Html.text "Starting color, adjusting hue" ]
            , Example.list
                [ ( Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 0, 100, 0 ), numLevels = 10 }
                  , "Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 0, 100, 0 ), numLevels = 10 }"
                  )
                , ( Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 120, 100, 0 ), numLevels = 10 }
                  , "Cubehelix.generate { defaultConfig |  startingColor = Color.fromHSL ( 120, 100, 0 ), numLevels = 10 }"
                  )
                , ( Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 240, 100, 0 ), numLevels = 10 }
                  , "Cubehelix.generate { defaultConfig |  startingColor = Color.fromHSL ( 240, 100, 0 ), numLevels = 10 }"
                  )
                ]
                viewExample
            ]
        )


viewExample : ( List Color.Color, String ) -> Html msg
viewExample ( colors, description ) =
    Html.div
        [ style "display" "flex"
        , style "align-items" "center"
        , style "flex-wrap" "wrap"
        , style "margin-bottom" "6px"
        ]
        [ Comparison.viewSpectrum colors
        , Html.code [] [ Html.text description ]
        ]

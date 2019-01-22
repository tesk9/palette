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
            [ Html.h4 [] [ Html.text "Rotation direction" ]
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
            , Html.h4 [] [ Html.text "Starting color" ]
            , Example.list
                [ ( Cubehelix.generate defaultConfig
                  , "Cubehelix.generate Cubehelix.defaultConfig"
                  )
                , ( Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 0, 100, 0 ) }
                  , "Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 0, 100, 0 ) }"
                  )
                , ( Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 120, 100, 0 ) }
                  , "Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 120, 100, 0 ) }"
                  )
                ]
                viewExample
            , Html.h4 [] [ Html.text "Grayscale" ]
            , Example.list
                [ ( Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 120, 0, 100 ) }
                  , "Cubehelix.generate { defaultConfig | startingColor = Color.fromHSL ( 120, 0, 100 )  }"
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

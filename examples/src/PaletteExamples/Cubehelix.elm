module PaletteExamples.Cubehelix exposing (examples)

import Color
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
            , viewExamples
                [ ( Cubehelix.generate 2
                  , "Cubehelix.generate 2"
                  )
                , ( Cubehelix.generate 5
                  , "Cubehelix.generate 5"
                  )
                , ( Cubehelix.generate 10
                  , "Cubehelix.generate 10"
                  )
                , ( Cubehelix.generate 100
                  , "Cubehelix.generate 100"
                  )
                , ( Cubehelix.generate 256
                  , "Cubehelix.generate 256"
                  )
                ]
            , Html.h4 [] [ Html.text "Rotation direction" ]
            , viewExamples
                [ ( Cubehelix.generateAdvanced 256 { defaultConfig | rotationDirection = Cubehelix.BGR, start = Color.fromRGB ( 255, 0, 0 ) }
                  , "Cubehelix.generateAdvanced 256 { defaultConfig | rotationDirection = Cubehelix.BGR, start = Color.fromRGB (255, 0, 0 ) }"
                  )
                , ( Cubehelix.generateAdvanced 256 { defaultConfig | rotationDirection = Cubehelix.RGB, start = Color.fromRGB ( 255, 0, 0 ) }
                  , "Cubehelix.generateAdvanced 256 { defaultConfig | rotationDirection = Cubehelix.RGB, start = Color.fromRGB (255, 0, 0 ) }"
                  )
                ]
            , Html.h4 [] [ Html.text "Rotation count" ]
            , viewExamples
                [ ( Cubehelix.generateAdvanced 256 { defaultConfig | rotations = 0 }
                  , "Cubehelix.generateAdvanced 256 { defaultConfig | rotations = 0 }"
                  )
                , ( Cubehelix.generateAdvanced 256 { defaultConfig | rotationDirection = Cubehelix.RGB, rotations = 1 }
                  , "Cubehelix.generateAdvanced 256 { defaultConfig | rotationDirection = Cubehelix.RGB, rotations = 1 }"
                  )
                , ( Cubehelix.generateAdvanced 256 { defaultConfig | rotationDirection = Cubehelix.RGB, rotations = 1.5 }
                  , "Cubehelix.generateAdvanced 256 { defaultConfig | rotationDirection = Cubehelix.RGB, rotations = 1.5 }"
                  )
                ]
            , Html.h4 [] [ Html.text "Gamma factor" ]
            , viewExamples
                [ ( Cubehelix.generateAdvanced 256 { defaultConfig | gamma = 0.25 }
                  , "Cubehelix.generateAdvanced 256 { defaultConfig | gamma = 0.25  }"
                  )
                , ( Cubehelix.generateAdvanced 256 { defaultConfig | gamma = 0.75 }
                  , "Cubehelix.generateAdvanced 256 { defaultConfig | gamma = 0.75  }"
                  )
                , ( Cubehelix.generateAdvanced 256 { defaultConfig | gamma = 1.75 }
                  , "Cubehelix.generateAdvanced 256 { defaultConfig | gamma = 1.75  }"
                  )
                ]
            , Html.h4 [] [ Html.text "Starting color, adjusting saturation" ]
            , viewExamples
                [ ( Cubehelix.generateAdvanced 10 { defaultConfig | start = Color.fromHSL ( 0, 0, 0 ) }
                  , "Cubehelix.generateAdvanced 10 { defaultConfig | start = Color.fromHSL ( 0, 0, 0 ) }"
                  )
                , ( Cubehelix.generateAdvanced 10 { defaultConfig | start = Color.fromHSL ( 0, 50, 0 ) }
                  , "Cubehelix.generateAdvanced 10 { defaultConfig | start = Color.fromHSL ( 0, 50, 0 ) }"
                  )
                , ( Cubehelix.generateAdvanced 10 { defaultConfig | start = Color.fromHSL ( 0, 100, 0 ) }
                  , "Cubehelix.generateAdvanced 10 { defaultConfig | start = Color.fromHSL ( 0, 100, 0 ) }"
                  )
                ]
            , Html.h4 [] [ Html.text "Starting color, adjusting hue" ]
            , viewExamples
                [ ( Cubehelix.generateAdvanced 10 { defaultConfig | start = Color.fromHSL ( 0, 100, 0 ) }
                  , "Cubehelix.generateAdvanced 10 { defaultConfig | start = Color.fromHSL ( 0, 100, 0 ) }"
                  )
                , ( Cubehelix.generateAdvanced 10 { defaultConfig | start = Color.fromHSL ( 120, 100, 0 ) }
                  , "Cubehelix.generateAdvanced 10 { defaultConfig |  start = Color.fromHSL ( 120, 100, 0 ) }"
                  )
                , ( Cubehelix.generateAdvanced 10 { defaultConfig | start = Color.fromHSL ( 240, 100, 0 ) }
                  , "Cubehelix.generateAdvanced 10 { defaultConfig |  start = Color.fromHSL ( 240, 100, 0 ) }"
                  )
                ]
            ]
        )


viewExamples : List ( List Color.Color, String ) -> Html msg
viewExamples exs =
    Example.listVertical exs viewExample


viewExample : ( List Color.Color, String ) -> Html msg
viewExample ( colors, description ) =
    Html.div
        [ style "display" "flex"
        , style "align-items" "center"
        , style "flex-wrap" "wrap"
        , style "margin-bottom" "8px"
        ]
        [ Comparison.viewSpectrum colors
        , Html.code [] [ Html.text description ]
        ]

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
            [ Html.h4 [] [ Html.text "With Colors" ]
            , Example.list
                [ ( Cubehelix.generate defaultConfig
                  , "Cubehelix.generate Cubehelix.defaultConfig"
                  )
                , ( Cubehelix.generate { defaultConfig | start = 2, saturation = 1.0 }
                  , "Cubehelix.generate { defaultConfig | start = 2, saturation = 1.0 }"
                  )
                , ( Cubehelix.generate { defaultConfig | start = 3, saturation = 1.0 }
                  , "Cubehelix.generate { defaultConfig | start = 3, saturation = 1.0 }"
                  )
                ]
                viewExample
            , Html.h4 [] [ Html.text "Grayscale" ]
            , Example.list
                [ ( Cubehelix.generate { defaultConfig | saturation = 0 }
                  , "Cubehelix.generate { defaultConfig | saturation = 0 }"
                  )
                , ( Cubehelix.generate { defaultConfig | saturation = 0, start = 2 }
                  , "Cubehelix.generate { defaultConfig | saturation = 0, start = 2 }"
                  )
                , ( Cubehelix.generate { defaultConfig | saturation = 0, start = 3 }
                  , "Cubehelix.generate { defaultConfig | saturation = 0, start = 3 }"
                  )
                ]
                viewExample
            ]
        )


viewExample : ( List Color.Color, String ) -> Html msg
viewExample ( colors, description ) =
    Html.div [ style "display" "flex", style "align-items" "center" ]
        [ Comparison.viewSpectrum colors
        , Html.code [] [ Html.text description ]
        ]

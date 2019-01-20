module PaletteExamples.Cubehelix exposing (examples)

import Color
import Comparison
import ExampleHelpers as Example
import Html exposing (Html)
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
                ]
                viewExample
            , Html.h4 [] [ Html.text "Grayscale" ]
            , Example.list
                [ ( Cubehelix.generate { defaultConfig | saturation = 0 }
                  , "Cubehelix.generate { defaultConfig | saturation = 0 }"
                  )
                ]
                viewExample
            ]
        )


viewExample : ( List Color.Color, String ) -> Html msg
viewExample ( colors, description ) =
    Html.div []
        [ Comparison.viewSpectrum colors
        , Html.code [] [ Html.text description ]
        ]

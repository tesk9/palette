module PaletteExamples.Cubehelix exposing (examples)

import Color
import Comparison
import ExampleHelpers as Example
import Html exposing (Html)
import Palette.Cubehelix as Cubehelix


examples : Html msg
examples =
    Example.subsection "Cubehelix"
        (Html.div []
            [ Html.h4 [] [ Html.text "With Colors" ]
            , Example.list
                [ ( Cubehelix.generate Cubehelix.defaultConfig
                  , "Cubehelix.generate Cubehelix.defaultConfig"
                  )
                ]
                (\( colors, description ) ->
                    Html.div []
                        [ Comparison.viewSpectrum colors
                        , Html.code [] [ Html.text description ]
                        ]
                )
            ]
        )

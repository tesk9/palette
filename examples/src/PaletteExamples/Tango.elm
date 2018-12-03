module PaletteExamples.Tango exposing (examples)

import Color
import Comparison
import ExampleHelpers as Example
import Html exposing (Html)
import Palette.Tango exposing (..)


examples : Html msg
examples =
    Example.subsection "Tango"
        (Html.div []
            [ Html.h4 [] [ Html.text "Butters" ]
            , Example.list
                [ ( butter1, "butter1" )
                , ( butter2, "butter2" )
                , ( butter3, "butter3" )
                ]
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Oranges" ]
            , Example.list
                [ ( orange1, "orange1" )
                , ( orange2, "orange2" )
                , ( orange3, "orange3" )
                ]
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Chocolates" ]
            , Example.list
                [ ( chocolate1, "chocolate1" )
                , ( chocolate2, "chocolate2" )
                , ( chocolate3, "chocolate3" )
                ]
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Chameleons" ]
            , Example.list
                [ ( chameleon1, "chameleon1" )
                , ( chameleon2, "chameleon2" )
                , ( chameleon3, "chameleon3" )
                ]
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Sky Blues" ]
            , Example.list
                [ ( skyBlue1, "skyBlue1" )
                , ( skyBlue2, "skyBlue2" )
                , ( skyBlue3, "skyBlue3" )
                ]
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Plums" ]
            , Example.list
                [ ( plum1, "plum1" )
                , ( plum2, "plum2" )
                , ( plum3, "plum3" )
                ]
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Scarlet Reds" ]
            , Example.list
                [ ( scarletRed1, "scarletRed1" )
                , ( scarletRed2, "scarletRed2" )
                , ( scarletRed3, "scarletRed3" )
                ]
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Aluminums" ]
            , Example.list
                [ ( aluminum1, "aluminum1" )
                , ( aluminum2, "aluminum2" )
                , ( aluminum3, "aluminum3" )
                , ( aluminum4, "aluminum4" )
                , ( aluminum5, "aluminum5" )
                , ( aluminum6, "aluminum6" )
                ]
                Comparison.viewWithName
            ]
        )

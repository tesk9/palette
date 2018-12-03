module ExampleHelpers exposing (list, section, subsection)

import Html exposing (Html)
import Html.Attributes exposing (style)


section : String -> Html msg -> Html msg
section heading examples =
    Html.section []
        [ Html.h2 [] [ Html.text heading ]
        , examples
        ]


subsection : String -> Html msg -> Html msg
subsection heading examples =
    Html.div []
        [ Html.h3 [] [ Html.text heading ]
        , examples
        ]


list : List a -> (a -> Html msg) -> Html msg
list examples viewExample =
    Html.ul
        [ style "list-style" "none"
        , style "display" "flex"
        , style "flex-wrap" "wrap"
        , style "margin" "0"
        , style "padding" "0"
        ]
        (List.map
            (\example -> Html.li [] [ viewExample example ])
            examples
        )

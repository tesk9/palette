module ExampleHelpers exposing (list, listVertical, section, subsection)

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
    ul
        (List.map
            (\example -> Html.li [] [ viewExample example ])
            examples
        )


listVertical : List a -> (a -> Html msg) -> Html msg
listVertical examples viewExample =
    ul
        (List.map
            (\example ->
                Html.li
                    [ style "min-width" "100%"
                    ]
                    [ viewExample example ]
            )
            examples
        )


ul : List (Html msg) -> Html msg
ul =
    Html.ul
        [ style "list-style" "none"
        , style "display" "flex"
        , style "flex-wrap" "wrap"
        , style "margin" "0"
        , style "padding" "0"
        ]

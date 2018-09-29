module Main exposing (main)

import Browser
import Color exposing (Color)
import Color.Contrast
import Color.Generator
import Html exposing (Html)
import Html.Attributes exposing (style)
import Platform


main : Platform.Program () Model Msg
main =
    Browser.sandbox
        { init = {}
        , update = \_ model -> model
        , view = view
        }


type alias Model =
    {}


view : Model -> Html msg
view _ =
    Html.main_ []
        [ Html.h1 [] [ Html.text "Examples" ]
        , exampleSet "Colors"
            rainbow
            cell
        , exampleSet "Contrast checks"
            [ ( red, yellow ) ]
            viewContrast
        , exampleSet "Color Schemes"
            []
            identity
        ]


exampleSet : String -> List a -> (a -> Html msg) -> Html msg
exampleSet heading examples viewExample =
    Html.section []
        [ Html.h2 [] [ Html.text heading ]
        , Html.ul
            [ style "list-style" "none"
            , style "display" "flex"
            ]
            (List.map
                (\example -> Html.li [] [ viewExample example ])
                examples
            )
        ]


cell : Color -> Html msg
cell color =
    let
        rgbColor =
            Color.toRGBString color
    in
    Html.div
        [ style "width" "120px"
        , style "height" "50px"
        , style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "flex-start"
        , style "background-color" rgbColor
        ]
        [ Html.span
            [ style "margin" "6px"
            , style "padding" "2px"
            , style "background-color" "white"
            ]
            [ Html.text rgbColor ]
        ]


viewContrast : ( Color, Color ) -> Html msg
viewContrast ( a, b ) =
    Html.div [] [ cell a, cell b ]


type alias Msg =
    ()



-- SUPER CONVENIENT COLORS


rainbow : List Color
rainbow =
    [ red, orange, yellow, green, blue, purple ]


red : Color
red =
    Color.fromRGB ( 255, 0, 0 )


orange : Color
orange =
    Color.fromRGB ( 255, 165, 0 )


yellow : Color
yellow =
    Color.fromRGB ( 255, 255, 0 )


green : Color
green =
    Color.fromRGB ( 0, 255, 0 )


blue : Color
blue =
    Color.fromRGB ( 0, 0, 255 )


purple : Color
purple =
    Color.fromRGB ( 128, 0, 128 )

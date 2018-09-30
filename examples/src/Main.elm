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
        , exampleSection "Colors"
            (exampleList rainbow cell)
        , exampleSection "Contrast checks"
            (exampleList [ ( red, yellow ) ] viewContrast)
        , exampleSection "Color Schemes"
            (Html.div []
                [ exampleSubsection "Complementary"
                    (exampleList rainbow viewComplementary)
                , exampleSubsection "Triadic"
                    (exampleList rainbow viewTriadic)
                , exampleSubsection "Square"
                    (exampleList rainbow viewSquare)
                , exampleSubsection "Tetratic"
                    (exampleList [ 20, 40, 60, 80, 100, 120 ] viewRectangle)
                , exampleSubsection "Grayscale"
                    (exampleList rainbow viewGrayscale)
                ]
            )
        ]


exampleSection : String -> Html msg -> Html msg
exampleSection heading examples =
    Html.section []
        [ Html.h2 [] [ Html.text heading ]
        , examples
        ]


exampleSubsection : String -> Html msg -> Html msg
exampleSubsection heading examples =
    Html.div []
        [ Html.h3 [] [ Html.text heading ]
        , examples
        ]


exampleList : List a -> (a -> Html msg) -> Html msg
exampleList examples viewExample =
    Html.ul
        [ style "list-style" "none"
        , style "display" "flex"
        ]
        (List.map
            (\example -> Html.li [] [ viewExample example ])
            examples
        )


viewContrast : ( Color, Color ) -> Html msg
viewContrast ( a, b ) =
    cellsContainer [ plainCell a, plainCell b ]


viewGrayscale : Color -> Html msg
viewGrayscale color =
    cellsContainer
        [ plainCell color, plainCell (Color.Generator.grayscale color) ]


viewComplementary : Color -> Html msg
viewComplementary color =
    cellsContainer
        [ plainCell color, plainCell (Color.Generator.complementary color) ]


viewTriadic : Color -> Html msg
viewTriadic color =
    let
        ( one, two ) =
            Color.Generator.triadic color
    in
    cellsContainer
        [ plainCell color, multiCells [ one, two ] ]


viewSquare : Color -> Html msg
viewSquare color =
    let
        ( one, two, three ) =
            Color.Generator.square color
    in
    cellsContainer
        [ plainCell color, multiCells [ one, two, three ] ]


viewRectangle : Float -> Html msg
viewRectangle degree =
    let
        ( one, two, three ) =
            Color.Generator.tetratic degree red
    in
    cellsContainer
        [ plainCell red, multiCells [ one, two, three ] ]


cellsContainer : List (Html msg) -> Html msg
cellsContainer =
    Html.div [ style "margin" "8px" ]


cell : Color -> Html msg
cell color =
    let
        rgbColor =
            Color.toRGBString color
    in
    Html.div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "flex-start"
        , style "background-color" rgbColor
        ]
        [ Html.span
            [ style "margin" "8px 20px 30px"
            , style "padding" "4px"
            , style "background-color" "white"
            , style "overflow" "scroll"
            , style "text-align" "center"
            , style "width" "240px"
            ]
            [ Html.div [] [ Html.text rgbColor ]
            , Html.div [] [ Html.text (Color.toHSLString color) ]
            , Html.div [] [ Html.text ("Luminance: " ++ String.fromFloat (Color.luminance color)) ]
            ]
        ]


plainCell : Color -> Html msg
plainCell color =
    Html.div
        [ style "background-color" (Color.toRGBString color)
        , style "height" "50px"
        , style "width" "100px"
        ]
        []


multiCells : List Color -> Html msg
multiCells colors =
    let
        miniCell color =
            Html.span
                [ style "width" "100%"
                , style "height" "20px"
                , style "background-color" color
                ]
                []
    in
    Html.div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "flex-start"
        ]
        (List.map (\color -> miniCell (Color.toRGBString color)) colors)


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

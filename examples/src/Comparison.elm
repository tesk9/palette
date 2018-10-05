module Comparison exposing (viewOverlapping, viewPalette, viewWithName)

import Browser
import Color exposing (Color)
import Color.Blend
import Color.Contrast
import Color.Generator
import ColorModes
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import Palette.X11 exposing (..)
import Platform


viewWithName : ( Color, String ) -> Html msg
viewWithName ( color, name ) =
    let
        rgbColor =
            Color.toRGBString color

        highContrastColor =
            Color.Generator.highContrast color
                |> Color.toRGBString
    in
    Html.div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "flex-start"
        , style "background-color" rgbColor
        , style "width" "200px"
        ]
        [ Html.span
            [ style "margin" "8px"
            , style "padding" "4px"
            , style "overflow" "scroll"
            , style "text-align" "center"
            , style "color" highContrastColor
            ]
            [ Html.div [] [ Html.text name ] ]
        ]


viewPalette : Color -> List Color -> Html msg
viewPalette color otherColors =
    Html.div [ style "margin" "8px" ]
        [ plainCell color, multiCells otherColors ]


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


viewOverlapping : (Color -> Color -> Color) -> ( Color, Color ) -> Html msg
viewOverlapping blend ( a, b ) =
    Html.div
        [ style "width" "70px"
        , style "height" "70px"
        , style "background-color" (Color.toRGBString a)
        , style "position" "relative"
        , style "margin-right" "70px"
        , style "margin-bottom" "70px"
        ]
        [ Html.div
            [ style "width" "70px"
            , style "height" "70px"
            , style "background-color" (Color.toRGBString b)
            , style "position" "relative"
            , style "top" "20px"
            , style "left" "20px"
            ]
            [ Html.div
                [ style "width" "50px"
                , style "height" "50px"
                , style "background-color" (Color.toRGBString (blend a b))
                , style "position" "relative"
                , style "top" "0"
                , style "left" "0"
                ]
                []
            ]
        ]

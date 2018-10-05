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
viewPalette baseColor otherColors =
    let
        baseColorWidth =
            200

        baseColorHeight =
            100

        radius =
            if List.length otherColors > 8 then
                15

            else if List.length otherColors > 4 then
                25

            else
                35

        circleCount =
            List.length otherColors

        leftPlacement index =
            baseColorWidth
                * toFloat (index + 1)
                / (toFloat circleCount + 1)
                - radius
                |> String.fromFloat
    in
    Html.div
        [ style "margin-right" "16px"
        , style "height" (String.fromInt baseColorHeight ++ "px")
        , style "width" (String.fromInt baseColorWidth ++ "px")
        , style "position" "relative"
        , style "background-color" (Color.toRGBString baseColor)
        ]
        (List.indexedMap
            (\index color ->
                Html.div
                    [ style "width" (String.fromInt (radius * 2) ++ "px")
                    , style "height" (String.fromInt (radius * 2) ++ "px")
                    , style "border-radius" "50%"
                    , style "background-color" (Color.toRGBString color)
                    , style "position" "absolute"
                    , style "left" (leftPlacement index ++ "px")
                    , style "top" (String.fromFloat (baseColorHeight / 2 - radius) ++ "px")
                    ]
                    []
            )
            otherColors
        )


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

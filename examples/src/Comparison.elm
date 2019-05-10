module Comparison exposing (viewOverlapping, viewPalette, viewSpectrum, viewWithName)

import Browser
import ColorModes
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import OpaqueColor exposing (OpaqueColor)
import OpaqueColor.Contrast
import OpaqueColor.Generator
import Palette.X11 exposing (..)
import Platform


viewWithName : ( OpaqueColor, String ) -> Html msg
viewWithName ( color, name ) =
    let
        rgbColor =
            OpaqueColor.toRGBString color

        highContrastColor =
            OpaqueColor.Generator.highContrast color
                |> OpaqueColor.toRGBString
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


viewPalette : OpaqueColor -> List OpaqueColor -> Html msg
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
        , style "background-color" (OpaqueColor.toRGBString baseColor)
        ]
        (List.indexedMap
            (\index color ->
                Html.div
                    [ style "width" (String.fromInt (radius * 2) ++ "px")
                    , style "height" (String.fromInt (radius * 2) ++ "px")
                    , style "border-radius" "50%"
                    , style "background-color" (OpaqueColor.toRGBString color)
                    , style "position" "absolute"
                    , style "left" (leftPlacement index ++ "px")
                    , style "top" (String.fromFloat (baseColorHeight / 2 - radius) ++ "px")
                    ]
                    []
            )
            otherColors
        )


viewOverlapping : (OpaqueColor -> OpaqueColor -> OpaqueColor) -> ( OpaqueColor, OpaqueColor ) -> Html msg
viewOverlapping blend ( a, b ) =
    let
        rectangleSize =
            ( 140, 80 )

        rectangle ( width, height ) ( x, y ) color =
            Html.div
                [ style "position" "absolute"
                , style "width" (px width)
                , style "height" (px height)
                , style "top" (px y)
                , style "left" (px x)
                , style "background-color" (OpaqueColor.toRGBString color)
                ]
                []

        overlapPoint =
            ( 40, 30 )
    in
    Html.div
        [ style "position" "relative"
        , style "width" (px (Tuple.first rectangleSize * 1.5 |> round))
        , style "height" (px (Tuple.second rectangleSize * 1.5 |> round))
        ]
        [ rectangle rectangleSize ( 0, 0 ) a
        , rectangle rectangleSize overlapPoint b
        , rectangle
            ( Tuple.first rectangleSize - Tuple.first overlapPoint
            , Tuple.second rectangleSize - Tuple.second overlapPoint
            )
            overlapPoint
            (blend a b)
        ]


viewSpectrum : List OpaqueColor -> Html msg
viewSpectrum colors =
    let
        spectrumWidth =
            512

        sliceWidth =
            spectrumWidth // List.length colors

        slice color =
            Html.div
                [ style "width" (px sliceWidth)
                , style "height" (px 40)
                , style "background-color" (OpaqueColor.toRGBString color)
                , style "display" "inline-block"
                ]
                []
    in
    colors
        |> List.map slice
        |> Html.div [ style "min-width" (px spectrumWidth) ]


px : Int -> String
px num =
    String.fromInt num ++ "px"

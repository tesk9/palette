module Comparison exposing (viewOverlapping, viewPalette, viewSpectrum, viewWithName)

import Browser
import Colour exposing (Colour)
import ColourModes
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import Palette.X11 exposing (..)
import Platform


viewWithName : ( Colour, String ) -> Html msg
viewWithName ( colour, name ) =
    let
        rgbColour =
            Colour.toRGBString colour

        highContrastColour =
            Colour.highContrast colour
                |> Colour.toRGBString
    in
    Html.div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "flex-start"
        , style "background-color" rgbColour
        , style "width" "200px"
        ]
        [ Html.span
            [ style "margin" "8px"
            , style "padding" "4px"
            , style "overflow" "scroll"
            , style "text-align" "center"
            , style "color" highContrastColour
            ]
            [ Html.div [] [ Html.text name ] ]
        ]


viewPalette : Colour -> List Colour -> Html msg
viewPalette baseColour otherColours =
    let
        baseColourWidth =
            200

        baseColourHeight =
            100

        radius =
            if List.length otherColours > 8 then
                15

            else if List.length otherColours > 4 then
                25

            else
                35

        circleCount =
            List.length otherColours

        leftPlacement index =
            baseColourWidth
                * toFloat (index + 1)
                / (toFloat circleCount + 1)
                - radius
                |> String.fromFloat
    in
    Html.div
        [ style "margin-right" "16px"
        , style "height" (String.fromInt baseColourHeight ++ "px")
        , style "width" (String.fromInt baseColourWidth ++ "px")
        , style "position" "relative"
        , style "background-color" (Colour.toRGBString baseColour)
        ]
        (List.indexedMap
            (\index colour ->
                Html.div
                    [ style "width" (String.fromInt (radius * 2) ++ "px")
                    , style "height" (String.fromInt (radius * 2) ++ "px")
                    , style "border-radius" "50%"
                    , style "background-color" (Colour.toRGBString colour)
                    , style "position" "absolute"
                    , style "left" (leftPlacement index ++ "px")
                    , style "top" (String.fromFloat (baseColourHeight / 2 - radius) ++ "px")
                    ]
                    []
            )
            otherColours
        )


viewOverlapping : (Colour -> Colour -> Colour) -> ( Colour, Colour ) -> Html msg
viewOverlapping blend ( a, b ) =
    let
        rectangleSize =
            ( 140, 80 )

        rectangle ( width, height ) ( x, y ) colour =
            Html.div
                [ style "position" "absolute"
                , style "width" (px width)
                , style "height" (px height)
                , style "top" (px y)
                , style "left" (px x)
                , style "background-color" (Colour.toRGBString colour)
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


viewSpectrum : List Colour -> Html msg
viewSpectrum colours =
    let
        spectrumWidth =
            512

        sliceWidth =
            spectrumWidth // List.length colours

        slice colour =
            Html.div
                [ style "width" (px sliceWidth)
                , style "height" (px 40)
                , style "background-color" (Colour.toRGBString colour)
                , style "display" "inline-block"
                ]
                []
    in
    colours
        |> List.map slice
        |> Html.div [ style "min-width" (px spectrumWidth) ]


px : Int -> String
px num =
    String.fromInt num ++ "px"

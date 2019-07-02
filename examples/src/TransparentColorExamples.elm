module TransparentColorExamples exposing (view)

import Color
import Color.Transparent exposing (Color, customOpacity)
import Html exposing (..)
import Html.Attributes exposing (style)


screen : Color
screen =
    Color.Transparent.fromRGBA
        { red = 255
        , green = 200
        , blue = 200
        , alpha = customOpacity 0.8
        }


view : Html msg
view =
    div
        [ style "background-image" "url(https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Strawberries.jpg/2560px-Strawberries.jpg)"
        , style "background-size" "contain"
        , style "background-repeat" "no-repeat"
        , style "height" "200px"
        , style "display" "flex"
        ]
        [ span
            [ style "background-color" (Color.Transparent.toRGBAString screen)
            , style "color" (Color.toRGBString (Color.fromRGB ( 255, 0, 0 )))
            , style "border" <|
                "1px solid "
                    ++ Color.toRGBString (Color.Transparent.toColor screen)
            , style "padding" "12px"
            ]
            [ p [ style "font-size" "24px" ] [ text "Yum! Strawberries!" ]
            , p [] [ text "Woo, transparency!" ]
            ]
        ]

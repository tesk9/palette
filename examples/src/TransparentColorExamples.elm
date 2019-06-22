module TransparentColorExamples exposing (view)

import Colour
import Colour.Transparent exposing (Colour)
import Html exposing (..)
import Html.Attributes exposing (style)
import Opacity


screen : Colour
screen =
    Colour.Transparent.fromRGBA
        { red = 255
        , green = 200
        , blue = 200
        , alpha = Opacity.custom 0.8
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
            [ style "background-color" (Colour.Transparent.toRGBAString screen)
            , style "color" (Colour.toRGBAString (Colour.fromRGB ( 255, 0, 0 )))
            , style "border" <|
                "1px solid "
                    ++ Colour.toRGBString (Colour.Transparent.toColor screen)
            , style "padding" "12px"
            ]
            [ p [ style "font-size" "24px" ] [ text "Yum! Strawberries!" ]
            , p [] [ text "Woo, transparency!" ]
            ]
        ]

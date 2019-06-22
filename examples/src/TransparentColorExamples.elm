module TransparentColorExamples exposing (view)

import Html exposing (..)
import Html.Attributes exposing (style)
import Opacity
import OpaqueColor exposing (OpaqueColor)
import TransparentColor exposing (TransparentColor)


opaqueRed : OpaqueColor
opaqueRed =
    OpaqueColor.fromRGB ( 255, 0, 0 )


screen : TransparentColor
screen =
    TransparentColor.fromRGBA
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
            [ style "background-color" (TransparentColor.toRGBAString screen)
            , style "color" (OpaqueColor.toRGBAString opaqueRed)
            , style "border" <|
                "1px solid "
                    ++ OpaqueColor.toRGBString (TransparentColor.toColor screen)
            , style "padding" "12px"
            ]
            [ p [ style "font-size" "24px" ] [ text "Yum! Strawberries!" ]
            , p [] [ text "Woo, transparency!" ]
            ]
        ]

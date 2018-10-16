module Slider exposing (Config, view)

import Color exposing (Color, toRGBString)
import Color.Generator exposing (highContrast)
import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events
import Json.Decode


type alias Config msg =
    { increase : msg
    , decrease : msg
    , asColor : Int -> Color
    , setTo : Color -> msg
    , valueMin : Int
    , valueMax : Int
    , valueNow : Int
    , labelId : String
    , labelText : String
    }


view : Config msg -> Html msg
view config =
    Html.div [ style "padding" "10px 36px 10px 10px" ]
        [ Html.div [ style "position" "relative" ] (slider config :: range config)
        , Html.label
            [ id config.labelId
            , style "display" "block"
            , style "text-align" "center"
            ]
            [ Html.text config.labelText ]
        ]


slider : Config msg -> Html msg
slider { valueMin, valueMax, valueNow, labelId, labelText, increase, decrease, asColor } =
    let
        border =
            style "border" ("1px solid " ++ toRGBString (highContrast (asColor valueNow)))
    in
    Html.div
        [ style "position" "relative"
        , style "margin" "auto"
        , style "top" (String.fromInt (valueMax - valueNow + 2) ++ "px")
        ]
        [ Html.div
            [ attribute "aria-role" "slider"
            , attribute "aria-valuemin" (String.fromInt valueMin)
            , attribute "aria-valuemax" (String.fromInt valueMax)
            , attribute "aria-valuenow" (String.fromInt valueNow)
            , attribute "aria-labelledby" labelId
            , attribute "aria-controls" (labelId ++ "-result")
            , attribute "tabindex" "0"
            , style "width" "100px"
            , style "height" "1px"
            , border
            , onKeyDown [ upArrow increase, downArrow decrease ]
            ]
            []
        , Html.div
            [ attribute "aria-role" "presentation"
            , id (labelId ++ "-result")
            , style "position" "absolute"
            , style "width" "24px"
            , style "text-align" "center"
            , style "padding" "2px"
            , style "border-radius" "2px"
            , style "left" "100%"
            , style "top" "-10px"
            , style "background-color" "white"
            , border
            ]
            [ Html.text (String.fromInt valueNow) ]
        ]


range : Config msg -> List (Html msg)
range config =
    List.range config.valueMin config.valueMax
        |> List.reverse
        |> List.map (viewSlice config)


viewSlice : Config msg -> Int -> Html msg
viewSlice config value =
    Html.div
        [ style "width" "100px"
        , style "height" "1px"
        , style "margin" "auto"
        , style "background-color" (toRGBString (config.asColor value))
        , Html.Events.onClick (config.setTo (config.asColor value))
        ]
        []


upArrow : msg -> Json.Decode.Decoder ( msg, Bool )
upArrow msg =
    succeedForKeyCode 38 msg


downArrow : msg -> Json.Decode.Decoder ( msg, Bool )
downArrow msg =
    succeedForKeyCode 40 msg


succeedForKeyCode : Int -> msg -> Json.Decode.Decoder ( msg, Bool )
succeedForKeyCode key msg =
    Json.Decode.andThen
        (\keyCode ->
            if keyCode == key then
                Json.Decode.succeed ( msg, True )

            else
                Json.Decode.fail (String.fromInt keyCode)
        )
        Html.Events.keyCode


onKeyDown : List (Json.Decode.Decoder ( msg, Bool )) -> Html.Attribute msg
onKeyDown decoders =
    Html.Events.preventDefaultOn "keydown" (Json.Decode.oneOf decoders)

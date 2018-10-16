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
    Html.div []
        [ Html.div [ style "position" "relative" ] (slider config :: range config)
        , Html.label [ id config.labelId ] [ Html.text config.labelText ]
        ]


slider : Config msg -> Html msg
slider { valueMin, valueMax, valueNow, labelId, increase, decrease, asColor } =
    Html.div
        [ attribute "aria-role" "slider"
        , attribute "aria-valuemin" (String.fromInt valueMin)
        , attribute "aria-valuemax" (String.fromInt valueMax)
        , attribute "aria-valuenow" (String.fromInt valueNow)
        , attribute "aria-labelledby" labelId
        , attribute "tabindex" "0"
        , style "width" "100px"
        , style "height" "1px"
        , style "border" ("1px solid " ++ toRGBString (highContrast (asColor valueNow)))
        , style "position" "relative"
        , style "top" (String.fromInt valueNow ++ "px")
        , onKeyDown [ upArrow increase, downArrow decrease ]
        ]
        []


range : Config msg -> List (Html msg)
range config =
    List.map (viewSlice config) (List.range config.valueMin config.valueMax)


viewSlice : Config msg -> Int -> Html msg
viewSlice config value =
    Html.div
        [ style "width" "100px"
        , style "height" "1px"
        , style "margin-left" "1px"
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

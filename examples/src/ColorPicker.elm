module ColorPicker exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator exposing (adjustLightness, adjustSaturation, rotate)
import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events
import Json.Decode


type Model
    = Model Color


init : Model
init =
    Model (Color.fromHSL ( 0, 100, 50 ))


type Msg
    = AdjustHue Int


view : Model -> Html Msg
view model =
    Html.div
        []
        [ viewHueSelector model
        ]


viewHueSelector : Model -> Html Msg
viewHueSelector (Model selectedColor) =
    let
        ( currentHue, _, _ ) =
            Color.toHSL selectedColor

        labelId =
            "hue-selector"

        slider =
            Html.div
                [ attribute "aria-role" "slider"
                , attribute "aria-valuemin" "1"
                , attribute "aria-valuemax" "360"
                , attribute "aria-valuenow" (String.fromFloat currentHue)
                , attribute "aria-labelledby" labelId
                , attribute "tabindex" "0"
                , style "width" "100px"
                , style "height" "1px"
                , style "border" "1px solid black"
                , style "position" "relative"
                , style "top" (String.fromFloat currentHue ++ "px")
                , onKeyDown [ upArrow (AdjustHue 1), downArrow (AdjustHue -1) ]
                ]
                []

        rainbow =
            List.range 1 360
                |> List.map (\hue -> viewHueSlice (Color.fromHSL ( toFloat hue, 100, 50 )))
    in
    Html.div []
        [ Html.div [ style "position" "relative" ] (slider :: rainbow)
        , Html.label [ id labelId ] [ Html.text "Hue Selector" ]
        ]


viewHueSlice : Color -> Html Msg
viewHueSlice color =
    Html.div
        [ style "width" "100px"
        , style "height" "1px"
        , style "margin-left" "1px"
        , style "background-color" (Color.toHSLString color)
        ]
        []


update : Msg -> Model -> Model
update msg (Model color) =
    case msg of
        AdjustHue degree ->
            Color.Generator.rotate (toFloat degree) color
                |> Model


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

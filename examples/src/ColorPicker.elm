module ColorPicker exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator exposing (adjustLightness, adjustSaturation, rotate)
import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events


type Model
    = Model Color


init : Model
init =
    Model (Color.fromHSL ( 0, 100, 50 ))


type alias Msg =
    ()


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
                ]
                []

        rainbow =
            List.range 1 360
                |> List.map (\hue -> viewHueSlice (Color.fromHSL ( toFloat hue, 100, 50 )))
    in
    Html.div []
        [ Html.div [] (slider :: rainbow)
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
update msg model =
    case msg of
        () ->
            model

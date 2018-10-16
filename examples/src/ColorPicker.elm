module ColorPicker exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator exposing (adjustLightness, adjustSaturation, rotate)
import Html exposing (Html)
import Html.Attributes exposing (style)


type Model
    = Model Color


init : Model
init =
    Model (Color.fromHSL ( 0, 100, 50 ))


type alias Msg =
    ()


view : Model -> Html Msg
view (Model color) =
    Html.div
        []
        [ viewHueSelector color
        ]


viewHueSelector : Color -> Html Msg
viewHueSelector color =
    List.range 1 360
        |> List.map (\rotation -> rotate (toFloat rotation) color)
        |> List.map viewHueSlice
        |> Html.div []


viewHueSlice : Color -> Html Msg
viewHueSlice color =
    Html.div
        [ style "width" "100px"
        , style "height" "1px"
        , style "background-color" (Color.toRGBString color)
        ]
        []


update : Msg -> Model -> Model
update msg model =
    case msg of
        () ->
            model

module ColorPicker exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator exposing (adjustLightness, adjustSaturation, rotate)
import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events
import Json.Decode
import Slider


type Model
    = Model Color


init : Model
init =
    Model (Color.fromHSL ( 0, 100, 50 ))


type Msg
    = AdjustHue Float
    | SetColor Color


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
    in
    Slider.view
        { increase = AdjustHue 1
        , decrease = AdjustHue -1
        , setTo = \hue -> SetColor (Color.fromHSL ( toFloat hue, 100, 50 ))
        , valueAsColor = \hue -> Color.fromHSL ( toFloat hue, 100, 50 ) |> Color.toHSLString
        , valueMin = 1
        , valueMax = 360
        , valueNow = currentHue
        , labelId = "hue-selector"
        }


update : Msg -> Model -> Model
update msg (Model color) =
    case msg of
        AdjustHue degree ->
            Color.Generator.rotate degree color
                |> Model

        SetColor newColor ->
            Model newColor

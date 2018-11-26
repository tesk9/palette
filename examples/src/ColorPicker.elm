module ColorPicker exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events


type alias Model =
    { selectedColor : Color
    }


init : Color -> Model
init color =
    Model color


view : Model -> Html Msg
view model =
    Html.label []
        [ Html.input
            [ Html.Attributes.type_ "color"
            , Color.toHexString model.selectedColor
                |> Html.Attributes.value
            , Html.Events.onInput SetHexColor
            ]
            []
        , Html.span [ style "padding" "2px" ] [ Html.text "Select a color" ]
        ]


type Msg
    = SetHexColor String


update : Msg -> Model -> ( Model, Maybe Color )
update msg { selectedColor } =
    case msg of
        SetHexColor colorString ->
            let
                newColor =
                    Color.fromHexString colorString
                        |> Result.withDefault selectedColor
            in
            ( Model newColor, Just newColor )

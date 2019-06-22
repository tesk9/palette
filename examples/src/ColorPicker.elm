module ColorPicker exposing (Model, Msg, init, update, view)

import Colour exposing (Colour)
import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events


type alias Model =
    { selectedColor : Colour
    }


init : Colour -> Model
init color =
    Model color


view : Model -> Html Msg
view model =
    Html.label []
        [ Html.input
            [ Html.Attributes.type_ "color"
            , Colour.toHex model.selectedColor
                |> Html.Attributes.value
            , Html.Events.onInput SetHexColor
            ]
            []
        , Html.span [ style "padding" "2px" ] [ Html.text "Select a color" ]
        ]


type Msg
    = SetHexColor String


update : Msg -> Model -> ( Model, Maybe Colour )
update msg { selectedColor } =
    case msg of
        SetHexColor colorString ->
            let
                newColor =
                    Colour.fromHex colorString
                        |> Result.withDefault selectedColor
            in
            ( Model newColor, Just newColor )

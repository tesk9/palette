module ColorPicker exposing (Model, Msg, init, update, view)

import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events
import SolidColor exposing (SolidColor)


type alias Model =
    { selectedColor : SolidColor
    }


init : SolidColor -> Model
init color =
    Model color


view : Model -> Html Msg
view model =
    Html.label []
        [ Html.input
            [ Html.Attributes.type_ "color"
            , SolidColor.toHex model.selectedColor
                |> Html.Attributes.value
            , Html.Events.onInput SetHexColor
            ]
            []
        , Html.span [ style "padding" "2px" ] [ Html.text "Select a color" ]
        ]


type Msg
    = SetHexColor String


update : Msg -> Model -> ( Model, Maybe SolidColor )
update msg { selectedColor } =
    case msg of
        SetHexColor colorString ->
            let
                newColor =
                    SolidColor.fromHex colorString
                        |> Result.withDefault selectedColor
            in
            ( Model newColor, Just newColor )

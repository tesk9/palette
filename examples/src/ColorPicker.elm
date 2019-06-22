module ColorPicker exposing (Model, Msg, init, update, view)

import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events
import OpaqueColor exposing (OpaqueColor)


type alias Model =
    { selectedColor : OpaqueColor
    }


init : OpaqueColor -> Model
init color =
    Model color


view : Model -> Html Msg
view model =
    Html.label []
        [ Html.input
            [ Html.Attributes.type_ "color"
            , OpaqueColor.toHexString model.selectedColor
                |> Html.Attributes.value
            , Html.Events.onInput SetHexColor
            ]
            []
        , Html.span [ style "padding" "2px" ] [ Html.text "Select a color" ]
        ]


type Msg
    = SetHexColor String


update : Msg -> Model -> ( Model, Maybe OpaqueColor )
update msg { selectedColor } =
    case msg of
        SetHexColor colorString ->
            let
                newColor =
                    OpaqueColor.fromHexString colorString
                        |> Result.withDefault selectedColor
            in
            ( Model newColor, Just newColor )

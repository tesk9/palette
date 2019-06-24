module ColourPicker exposing (Model, Msg, init, update, view)

import Colour exposing (Colour)
import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events


type alias Model =
    { selectedColour : Colour
    }


init : Colour -> Model
init colour =
    Model colour


view : Model -> Html Msg
view model =
    Html.label []
        [ Html.input
            [ Html.Attributes.type_ "color"
            , Colour.toHex model.selectedColour
                |> Html.Attributes.value
            , Html.Events.onInput SetHexColour
            ]
            []
        , Html.span [ style "padding" "2px" ] [ Html.text "Select a colour" ]
        ]


type Msg
    = SetHexColour String


update : Msg -> Model -> ( Model, Maybe Colour )
update msg { selectedColour } =
    case msg of
        SetHexColour colourString ->
            let
                newColour =
                    Colour.fromHex colourString
                        |> Result.withDefault selectedColour
            in
            ( Model newColour, Just newColour )

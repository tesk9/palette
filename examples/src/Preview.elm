module Preview exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator
import Comparison
import Html exposing (Html)
import Html.Attributes exposing (style)


type alias Model =
    {}


init : Model
init =
    {}


view : Color -> Model -> Html Msg
view selectedColor model =
    Html.div []
        [ Html.h3 [] [ Html.text "Palette generators" ]
        , Html.div [ style "text-align" "center" ]
            [ viewComplementary selectedColor
            , Html.text ".complementary"
            ]
        , Html.div [ style "text-align" "center" ]
            [ viewTriadic selectedColor
            , Html.text ".triadic"
            ]
        ]


viewComplementary : Color -> Html msg
viewComplementary color =
    Comparison.viewPalette color [ Color.Generator.complementary color ]


viewTriadic : Color -> Html msg
viewTriadic color =
    let
        ( one, two ) =
            Color.Generator.triadic color
    in
    Comparison.viewPalette color [ one, two ]


type alias Msg =
    ()


update : Msg -> Model -> Model
update msg model =
    case msg of
        () ->
            model

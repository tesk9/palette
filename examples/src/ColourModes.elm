module ColourModes exposing (Model, Msg, init, update, view)

import Browser
import Colour exposing (Colour)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import Palette.Generative
import Palette.X11 exposing (..)
import Platform


type alias Model =
    ColourPreference


init : Model
init =
    Standard


type alias Palette =
    { primary : Colour
    , secondary : Colour
    , backgroundColours : ( Colour, Colour )
    }


mapPalette : (Colour -> Colour) -> Palette -> Palette
mapPalette map palette =
    { primary = map palette.primary
    , secondary = map palette.secondary
    , backgroundColours = Tuple.mapBoth map map palette.backgroundColours
    }


type ColourPreference
    = Standard
    | InvertStandard
    | HighContrast
    | InvertHighContrast


colourPreferenceToString : ColourPreference -> String
colourPreferenceToString colourPreference =
    case colourPreference of
        Standard ->
            "Standard"

        InvertStandard ->
            "Invert Standard"

        HighContrast ->
            "High Contrast"

        InvertHighContrast ->
            "Invert High Contrast"


colourPreferenceToPalette : ColourPreference -> Palette
colourPreferenceToPalette colourPreference =
    let
        standardPalette =
            { primary = dimGray
            , secondary = lightSalmon
            , backgroundColours = ( lavenderBlush, Palette.Generative.complementary lavenderBlush )
            }

        highContrastPalette =
            { primary = black
            , secondary = red
            , backgroundColours = ( white, white )
            }
    in
    case colourPreference of
        Standard ->
            standardPalette

        InvertStandard ->
            mapPalette Colour.invert standardPalette

        HighContrast ->
            highContrastPalette

        InvertHighContrast ->
            mapPalette Colour.invert highContrastPalette


type Msg
    = ChangePreference ColourPreference


update : Msg -> Model -> Model
update msg m =
    case msg of
        ChangePreference preference ->
            preference


view : Model -> Html Msg
view colourPreference =
    let
        palette =
            colourPreferenceToPalette colourPreference
    in
    Html.div []
        [ Html.div []
            (List.map
                (\i ->
                    Html.div []
                        [ Html.input
                            [ Html.Attributes.name "ColourPreference"
                            , Html.Attributes.type_ "radio"
                            , Html.Attributes.id (colourPreferenceToString i)
                            , Html.Attributes.value (colourPreferenceToString i)
                            , Html.Attributes.checked (colourPreference == i)
                            , Html.Events.onCheck (\_ -> ChangePreference i)
                            ]
                            []
                        , Html.label
                            [ Html.Attributes.for (colourPreferenceToString i)
                            ]
                            [ Html.text (colourPreferenceToString i) ]
                        ]
                )
                [ Standard, InvertStandard, HighContrast, InvertHighContrast ]
            )
        , viewContent palette
            [ Html.h3
                [ style "color" (Colour.toRGBString palette.secondary) ]
                [ Html.text (colourPreferenceToString colourPreference) ]
            , Html.div
                [ style "color" (Colour.toRGBString palette.primary) ]
                [ Html.text "I'm some text." ]
            ]
        ]


viewContent : Palette -> List (Html msg) -> Html msg
viewContent palette content =
    let
        linearGradient ( top, bottom ) =
            "linear-gradient(" ++ Colour.toRGBString top ++ "," ++ Colour.toRGBString bottom ++ ")"
    in
    Html.div
        [ style "background-color" (Colour.toRGBString (Tuple.first palette.backgroundColours))
        , style "padding" "8px"
        ]
        [ Html.div
            [ style "background-image" (linearGradient palette.backgroundColours)

            --Positioning
            , style "margin" "20px"
            , style "padding" "8px"
            , style "border" ("1px dashed " ++ Colour.toRGBString palette.secondary)
            ]
            content
        ]


button : msg -> String -> Html msg
button msg text =
    Html.button
        [ Html.Events.onClick msg
        ]
        [ Html.text text ]

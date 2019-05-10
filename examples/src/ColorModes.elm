module ColorModes exposing (Model, Msg, init, update, view)

import Browser
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import OpaqueColor exposing (OpaqueColor)
import Palette.Generative
import Palette.X11 exposing (..)
import Platform


type alias Model =
    ColorPreference


init : Model
init =
    Standard


type alias Palette =
    { primary : OpaqueColor
    , secondary : OpaqueColor
    , backgroundColors : ( OpaqueColor, OpaqueColor )
    }


mapPalette : (OpaqueColor -> OpaqueColor) -> Palette -> Palette
mapPalette map palette =
    { primary = map palette.primary
    , secondary = map palette.secondary
    , backgroundColors = Tuple.mapBoth map map palette.backgroundColors
    }


type ColorPreference
    = Standard
    | InvertStandard
    | HighContrast
    | InvertHighContrast


colorPreferenceToString : ColorPreference -> String
colorPreferenceToString colorPreference =
    case colorPreference of
        Standard ->
            "Standard"

        InvertStandard ->
            "Invert Standard"

        HighContrast ->
            "High Contrast"

        InvertHighContrast ->
            "Invert High Contrast"


colorPreferenceToPalette : ColorPreference -> Palette
colorPreferenceToPalette colorPreference =
    let
        standardPalette =
            { primary = dimGray
            , secondary = lightSalmon
            , backgroundColors = ( lavenderBlush, Palette.Generative.complementary lavenderBlush )
            }

        highContrastPalette =
            { primary = black
            , secondary = red
            , backgroundColors = ( white, white )
            }
    in
    case colorPreference of
        Standard ->
            standardPalette

        InvertStandard ->
            mapPalette OpaqueColor.invert standardPalette

        HighContrast ->
            highContrastPalette

        InvertHighContrast ->
            mapPalette OpaqueColor.invert highContrastPalette


type Msg
    = ChangePreference ColorPreference


update : Msg -> Model -> Model
update msg m =
    case msg of
        ChangePreference preference ->
            preference


view : Model -> Html Msg
view colorPreference =
    let
        palette =
            colorPreferenceToPalette colorPreference
    in
    Html.div []
        [ [ Standard, InvertStandard, HighContrast, InvertHighContrast ]
            |> List.map
                (\mode ->
                    if mode == colorPreference then
                        Html.text ""

                    else
                        button (ChangePreference mode)
                            ("Change to " ++ colorPreferenceToString mode)
                )
            |> Html.div []
        , viewContent palette
            [ Html.h3
                [ style "color" (OpaqueColor.toRGBString palette.secondary) ]
                [ Html.text (colorPreferenceToString colorPreference) ]
            , Html.div
                [ style "color" (OpaqueColor.toRGBString palette.primary) ]
                [ Html.text "Try changing the color scheme using the buttons." ]
            ]
        ]


viewContent : Palette -> List (Html msg) -> Html msg
viewContent palette content =
    let
        linearGradient ( top, bottom ) =
            "linear-gradient(" ++ OpaqueColor.toRGBString top ++ "," ++ OpaqueColor.toRGBString bottom ++ ")"
    in
    Html.div
        [ style "background-color" (OpaqueColor.toRGBString (Tuple.first palette.backgroundColors))
        , style "padding" "8px"
        ]
        [ Html.div
            [ style "background-image" (linearGradient palette.backgroundColors)

            --Positioning
            , style "margin" "20px"
            , style "padding" "8px"
            , style "border" ("1px dashed " ++ OpaqueColor.toRGBString palette.secondary)
            ]
            content
        ]


button : msg -> String -> Html msg
button msg text =
    Html.button
        [ Html.Events.onClick msg
        ]
        [ Html.text text ]

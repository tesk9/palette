module ColorModes exposing (Model, Msg, init, update, view)

import Browser
import Color exposing (Color)
import Color.Blend
import Color.Contrast
import Color.Generator
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import Palette.X11 exposing (..)
import Platform


type alias Model =
    ColorPreference


init : Model
init =
    Standard


type ColorPreference
    = Standard
    | InvertStandard
    | HighContrast
    | InvertHighContrast


type alias Palette =
    { primary : Color
    , secondary : Color
    , backgroundColors : ( Color, Color )
    }


mapPalette : (Color -> Color) -> Palette -> Palette
mapPalette map palette =
    { primary = map palette.primary
    , secondary = map palette.secondary
    , backgroundColors = Tuple.mapBoth map map palette.backgroundColors
    }


standardPalette : Palette
standardPalette =
    { primary = dimGray
    , secondary = lightSalmon
    , backgroundColors = ( lavenderBlush, Color.Generator.complementary lavenderBlush )
    }


highContrastPalette : Palette
highContrastPalette =
    { primary = black
    , secondary = red
    , backgroundColors = ( white, white )
    }


colorPreferenceToString : ColorPreference -> String
colorPreferenceToString colorPreference =
    case colorPreference of
        Standard ->
            "standard"

        InvertStandard ->
            "invert standard"

        HighContrast ->
            "high contrast"

        InvertHighContrast ->
            "invert high contrast"


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
        currentMode mode =
            Html.div [] [ Html.text ("Currently in " ++ colorPreferenceToString mode ++ " mode") ]

        modeOption mode =
            Html.button [ Html.Events.onClick (ChangePreference mode) ] [ Html.text ("Change to " ++ colorPreferenceToString mode) ]
    in
    case colorPreference of
        Standard ->
            viewContent standardPalette
                [ currentMode Standard
                , modeOption InvertStandard
                , modeOption HighContrast
                ]

        InvertStandard ->
            viewContent (mapPalette Color.Generator.invert standardPalette)
                [ modeOption Standard
                , currentMode InvertStandard
                ]

        HighContrast ->
            viewContent highContrastPalette
                [ modeOption Standard
                , currentMode HighContrast
                , modeOption InvertHighContrast
                ]

        InvertHighContrast ->
            viewContent (mapPalette Color.Generator.invert highContrastPalette)
                [ modeOption HighContrast
                , currentMode InvertHighContrast
                ]


viewContent : Palette -> List (Html msg) -> Html msg
viewContent palette content =
    let
        linearGradient ( top, bottom ) =
            "linear-gradient(" ++ Color.toRGBString top ++ "," ++ Color.toRGBString bottom ++ ")"
    in
    Html.div
        [ style "background-color" (Color.toRGBString (Tuple.first palette.backgroundColors))
        , style "padding" "20px"
        ]
        [ Html.div
            [ style "background-image" (linearGradient palette.backgroundColors)
            , style "color" (Color.toRGBString palette.primary)

            --Positioning
            , style "display" "flex"
            , style "justify-content" "space-around"
            , style "margin" "20px"
            , style "border" ("1px dashed " ++ Color.toRGBString palette.secondary)
            , style "padding" "20px"
            ]
            content
        ]

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
        standardPalette =
            { top = lavenderBlush
            , bottom = Color.Generator.complementary lavenderBlush
            , font = dimGray
            , border = steelBlue
            }

        highContrastPalette =
            { top = white
            , bottom = white
            , font = Color.Generator.highContrast white
            , border = blue
            }

        mapPalette map p =
            { top = map p.top
            , bottom = map p.bottom
            , font = map p.font
            , border = map p.border
            }

        currentMode mode =
            Html.div [] [ Html.text ("Currently in " ++ colorPreferenceToString mode ++ " mode") ]

        modeOption mode =
            Html.button [ Html.Events.onClick (ChangePreference mode) ] [ Html.text ("Change to " ++ colorPreferenceToString mode) ]

        viewWithPalette { top, bottom, font, border } =
            let
                linearGradient =
                    "linear-gradient(" ++ Color.toRGBString top ++ "," ++ Color.toRGBString bottom ++ ")"
            in
            Html.div
                [ style "background-image" linearGradient
                , style "color" (Color.toRGBString font)

                --Positioning
                , style "display" "flex"
                , style "justify-content" "space-around"
                , style "margin" "20px"
                , style "border" ("1px dashed " ++ Color.toRGBString border)
                , style "padding" "20px"
                ]
    in
    case colorPreference of
        Standard ->
            viewWithPalette standardPalette
                [ currentMode Standard
                , modeOption InvertStandard
                , modeOption HighContrast
                ]

        InvertStandard ->
            viewWithPalette (mapPalette Color.Generator.invert standardPalette)
                [ modeOption Standard
                , currentMode InvertStandard
                ]

        HighContrast ->
            viewWithPalette highContrastPalette
                [ modeOption Standard
                , currentMode HighContrast
                , modeOption InvertHighContrast
                ]

        InvertHighContrast ->
            viewWithPalette (mapPalette Color.Generator.invert highContrastPalette)
                [ modeOption HighContrast
                , currentMode InvertHighContrast
                ]

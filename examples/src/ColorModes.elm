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


colorPreferenceToPalette : ColorPreference -> Palette
colorPreferenceToPalette colorPreference =
    case colorPreference of
        Standard ->
            standardPalette

        InvertStandard ->
            mapPalette Color.Generator.invert standardPalette

        HighContrast ->
            highContrastPalette

        InvertHighContrast ->
            mapPalette Color.Generator.invert highContrastPalette


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
    [ Standard, InvertStandard, HighContrast, InvertHighContrast ]
        |> List.map
            (\mode ->
                if mode == colorPreference then
                    Html.div [] [ Html.text ("Currently in " ++ colorPreferenceToString mode ++ " mode") ]

                else
                    button palette (ChangePreference mode) ("Change to " ++ colorPreferenceToString mode)
            )
        |> viewContent palette


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


button : Palette -> msg -> String -> Html msg
button palette msg text =
    Html.button
        [ Html.Events.onClick msg
        , style "background-color" (Color.toRGBString (Tuple.second palette.backgroundColors))
        , style "border-color" (Color.toRGBString palette.secondary)
        , style "color" (Color.toRGBString palette.primary)
        ]
        [ Html.text text ]

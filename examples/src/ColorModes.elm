module ColorModes exposing (Model, Msg, init, update, view)

import Browser
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import Palette.Generative
import Palette.X11 exposing (..)
import Platform
import SolidColor exposing (SolidColor)


type alias Model =
    ColorPreference


init : Model
init =
    Standard


type alias Palette =
    { primary : SolidColor
    , secondary : SolidColor
    , backgroundColors : ( SolidColor, SolidColor )
    }


mapPalette : (SolidColor -> SolidColor) -> Palette -> Palette
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
            mapPalette SolidColor.invert standardPalette

        HighContrast ->
            highContrastPalette

        InvertHighContrast ->
            mapPalette SolidColor.invert highContrastPalette


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
        [ Html.div []
            (List.map
                (\i ->
                    Html.div []
                        [ Html.input
                            [ Html.Attributes.name "ColorPreference"
                            , Html.Attributes.type_ "radio"
                            , Html.Attributes.id (colorPreferenceToString i)
                            , Html.Attributes.value (colorPreferenceToString i)
                            , Html.Attributes.checked (colorPreference == i)
                            , Html.Events.onCheck (\_ -> ChangePreference i)
                            ]
                            []
                        , Html.label
                            [ Html.Attributes.for (colorPreferenceToString i)
                            ]
                            [ Html.text (colorPreferenceToString i) ]
                        ]
                )
                [ Standard, InvertStandard, HighContrast, InvertHighContrast ]
            )
        , viewContent palette
            [ Html.h3
                [ style "color" (SolidColor.toRGBString palette.secondary) ]
                [ Html.text (colorPreferenceToString colorPreference) ]
            , Html.div
                [ style "color" (SolidColor.toRGBString palette.primary) ]
                [ Html.text "I'm some text." ]
            ]
        ]


viewContent : Palette -> List (Html msg) -> Html msg
viewContent palette content =
    let
        linearGradient ( top, bottom ) =
            "linear-gradient(" ++ SolidColor.toRGBString top ++ "," ++ SolidColor.toRGBString bottom ++ ")"
    in
    Html.div
        [ style "background-color" (SolidColor.toRGBString (Tuple.first palette.backgroundColors))
        , style "padding" "8px"
        ]
        [ Html.div
            [ style "background-image" (linearGradient palette.backgroundColors)

            --Positioning
            , style "margin" "20px"
            , style "padding" "8px"
            , style "border" ("1px dashed " ++ SolidColor.toRGBString palette.secondary)
            ]
            content
        ]


button : msg -> String -> Html msg
button msg text =
    Html.button
        [ Html.Events.onClick msg
        ]
        [ Html.text text ]

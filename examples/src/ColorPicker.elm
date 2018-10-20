module ColorPicker exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator exposing (adjustLightness, adjustSaturation, rotate)
import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events
import Json.Decode
import Slider


type alias Model =
    { selectedColor : Color
    , pickerStyle : PickerStyle
    }


type PickerStyle
    = RGB
    | HSL


init : Color -> Model
init color =
    Model color HSL


view : Model -> Html Msg
view model =
    Html.section
        [ style "display" "flex"
        , style "align-items" "stretch"
        , style "background-color" "lightgrey"
        , style "width" "min-content"
        , style "border-radius" "8px"
        , style "border" "1px solid grey"
        ]
    <|
        case model.pickerStyle of
            HSL ->
                viewHSLSelectors model

            RGB ->
                viewRGBSelectors model


viewHSLSelectors : Model -> List (Html Msg)
viewHSLSelectors ({ selectedColor } as model) =
    let
        ( currentHue, currentSaturation, currentLightness ) =
            Color.toHSL selectedColor

        setHue hue =
            ( hue, currentSaturation, currentLightness )
                |> Color.fromHSL
                |> SetColor

        setSaturation saturation =
            ( currentHue, saturation, currentLightness )
                |> Color.fromHSL
                |> SetColor

        setLightness lightness =
            ( currentHue, currentSaturation, lightness )
                |> Color.fromHSL
                |> SetColor
    in
    [ Slider.view
        { setValue = toFloat >> setHue
        , asColor = \hue -> Color.fromHSL ( toFloat hue, 100, 50 )
        , valueMin = 0
        , valueMax = 359
        , valueNow = round currentHue
        , labelId = "hue-selector"
        , labelText = "Hue"
        , width = 70
        }
    , Html.div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        ]
        [ Html.h2 [] [ Html.text "HSL Color Picker" ]
        , changePicker "RGB" RGB
        , viewColor model
        , Html.div
            [ style "display" "flex"
            , style "margin-top" "auto"
            ]
            [ Slider.view
                { setValue = toFloat >> setSaturation
                , asColor = \saturation -> Color.fromHSL ( currentHue, toFloat saturation, 50 )
                , valueMin = 0
                , valueMax = 100
                , valueNow = round currentSaturation
                , labelId = "saturation-selector"
                , labelText = "Saturation"
                , width = 70
                }
            , Slider.view
                { setValue = toFloat >> setLightness
                , asColor = \lightness -> Color.fromHSL ( currentHue, currentSaturation, toFloat lightness )
                , valueMin = 0
                , valueMax = 100
                , valueNow = round currentLightness
                , labelId = "lightness-selector"
                , labelText = "Lightness"
                , width = 70
                }
            ]
        ]
    ]


viewRGBSelectors : Model -> List (Html Msg)
viewRGBSelectors ({ selectedColor } as model) =
    let
        ( currentR, currentG, currentB ) =
            Color.toRGB selectedColor

        setR redness =
            ( redness, currentG, currentB )
                |> Color.fromRGB
                |> SetColor

        setG greenness =
            ( currentR, greenness, currentB )
                |> Color.fromRGB
                |> SetColor

        setB blueness =
            ( currentR, currentG, blueness )
                |> Color.fromRGB
                |> SetColor
    in
    [ Html.div []
        [ Html.div [ style "display" "flex", style "justify-content" "space-around" ]
            [ Slider.view
                { setValue = toFloat >> setR
                , asColor = \r -> Color.fromRGB ( toFloat r, 0, 0 )
                , valueMin = 0
                , valueMax = 255
                , valueNow = round currentR
                , labelId = "redness-selector"
                , labelText = "Red"
                , width = 35
                }
            , Slider.view
                { setValue = toFloat >> setG
                , asColor = \g -> Color.fromRGB ( 0, toFloat g, 0 )
                , valueMin = 0
                , valueMax = 255
                , valueNow = round currentG
                , labelId = "greenness-selector"
                , labelText = "Green"
                , width = 35
                }
            , Slider.view
                { setValue = toFloat >> setB
                , asColor = \b -> Color.fromRGB ( 0, 0, toFloat b )
                , valueMin = 0
                , valueMax = 255
                , valueNow = round currentB
                , labelId = "blueness-selector"
                , labelText = "Blue"
                , width = 35
                }
            ]
        ]
    , Html.div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        , style "min-width" "200px"
        ]
        [ Html.h2 [] [ Html.text "RGB Color Picker" ]
        , changePicker "HSL" HSL
        , viewColor model
        ]
    ]


changePicker : String -> PickerStyle -> Html Msg
changePicker text pickerStyle =
    Html.button
        [ Html.Events.onClick (SetPickerStyle pickerStyle)
        , style "padding" "8px"
        , style "border-radius" "6px"
        ]
        [ Html.text ("View " ++ text ++ " ColorPicker") ]


viewColor : Model -> Html Msg
viewColor { selectedColor } =
    Html.div
        [ style "display" "flex"
        , style "flex-direction" "column"
        ]
        [ Html.div
            [ style "width" "100px"
            , style "height" "100px"
            , style "margin-top" "16px"
            , style "border-radius" "50%"
            , style "background-color" (Color.toRGBString selectedColor)
            ]
            []
        ]


type Msg
    = SetColor Color
    | SetPickerStyle PickerStyle


update : Msg -> Model -> ( Model, Maybe Color )
update msg { selectedColor, pickerStyle } =
    case msg of
        SetColor newColor ->
            ( Model newColor pickerStyle, Just newColor )

        SetPickerStyle newPickerStyle ->
            ( Model selectedColor newPickerStyle, Nothing )

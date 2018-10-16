module ColorPicker exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator exposing (adjustLightness, adjustSaturation, rotate)
import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events
import Json.Decode
import Slider


type Model
    = Model Color PickerStyle


type PickerStyle
    = RGB
    | HSL


init : Model
init =
    Model (Color.fromHSL ( 0, 100, 50 )) HSL


type Msg
    = AdjustHue Float
    | AdjustSaturation Float
    | AdjustLightness Float
    | SetColor Color
    | SetPickerStyle PickerStyle


view : Model -> Html Msg
view (Model color pickerStyle) =
    Html.section
        [ style "display" "flex"
        , style "align-items" "stretch"
        , style "background-color" "lightgrey"
        , style "width" "445px"
        , style "border-radius" "8px"
        , style "border" "1px solid grey"
        ]
    <|
        case pickerStyle of
            HSL ->
                [ hueSelector color
                , Html.div
                    [ style "display" "flex"
                    , style "flex-direction" "column"
                    , style "align-items" "center"
                    ]
                    [ Html.h2 [] [ Html.text "HSL Color Picker" ]
                    , changePicker "RGB" RGB
                    , viewColor color
                    , Html.div
                        [ style "display" "flex"
                        , style "margin-top" "auto"
                        ]
                        [ saturationSelector color
                        , lightnessSelector color
                        ]
                    ]
                ]

            RGB ->
                [ Html.div
                    [ style "display" "flex"
                    , style "flex-direction" "column"
                    , style "align-items" "center"
                    ]
                    [ Html.h2 [] [ Html.text "RGB Color Picker" ]
                    , changePicker "HSL" HSL
                    , viewColor color
                    ]
                ]


changePicker : String -> PickerStyle -> Html Msg
changePicker text pickerStyle =
    Html.button
        [ Html.Events.onClick (SetPickerStyle pickerStyle)
        , style "margin" "8px"
        ]
        [ Html.text ("View " ++ text ++ " ColorPicker") ]


hueSelector : Color -> Html Msg
hueSelector selectedColor =
    let
        ( currentHue, _, _ ) =
            Color.toHSL selectedColor

        asColor hue =
            Color.fromHSL ( toFloat hue, 100, 50 )
    in
    Slider.view
        { increase = AdjustHue 1
        , decrease = AdjustHue -1
        , asColor = asColor
        , setTo = SetColor
        , valueMin = 0
        , valueMax = 359
        , valueNow = round currentHue
        , labelId = "hue-selector"
        , labelText = "Hue"
        }


saturationSelector : Color -> Html Msg
saturationSelector selectedColor =
    let
        ( hue, currentSaturation, lightness ) =
            Color.toHSL selectedColor

        asColor saturation =
            Color.fromHSL ( hue, toFloat saturation, 50 )
    in
    Slider.view
        { increase = AdjustSaturation 1
        , decrease = AdjustSaturation -1
        , asColor = asColor
        , setTo = SetColor
        , valueMin = 0
        , valueMax = 100
        , valueNow = round currentSaturation
        , labelId = "saturation-selector"
        , labelText = "Saturation"
        }


lightnessSelector : Color -> Html Msg
lightnessSelector selectedColor =
    let
        ( hue, saturation, currentLightness ) =
            Color.toHSL selectedColor

        asColor lightness =
            Color.fromHSL ( hue, saturation, toFloat lightness )
    in
    Slider.view
        { increase = AdjustLightness 1
        , decrease = AdjustLightness -1
        , asColor = asColor
        , setTo = SetColor
        , valueMin = 0
        , valueMax = 100
        , valueNow = round currentLightness
        , labelId = "lightness-selector"
        , labelText = "Lightness"
        }


viewColor : Color -> Html msg
viewColor color =
    Html.div
        [ style "width" "150px"
        , style "height" "150px"
        , style "border-radius" "50%"
        , style "background-color" (Color.toRGBString color)
        ]
        []


update : Msg -> Model -> Model
update msg (Model color pickerStyle) =
    case msg of
        AdjustHue degree ->
            Model (rotate degree color) pickerStyle

        AdjustSaturation percentage ->
            Model (adjustSaturation percentage color) pickerStyle

        AdjustLightness percentage ->
            Model (adjustLightness percentage color) pickerStyle

        SetColor newColor ->
            Model newColor pickerStyle

        SetPickerStyle newPickerStyle ->
            Model color newPickerStyle

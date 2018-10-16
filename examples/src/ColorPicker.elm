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
    | AdjustRedness Float
    | AdjustGreenness Float
    | AdjustBlueness Float
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
                viewHSLSelectors color

            RGB ->
                viewRGBSelectors color


viewHSLSelectors : Color -> List (Html Msg)
viewHSLSelectors selectedColor =
    let
        ( currentHue, currentSaturation, currentLightness ) =
            Color.toHSL selectedColor
    in
    [ Slider.view
        { increase = AdjustHue 1
        , decrease = AdjustHue -1
        , asColor = \hue -> Color.fromHSL ( toFloat hue, 100, 50 )
        , setTo = SetColor
        , valueMin = 0
        , valueMax = 359
        , valueNow = round currentHue
        , labelId = "hue-selector"
        , labelText = "Hue"
        }
    , Html.div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        ]
        [ Html.h2 [] [ Html.text "HSL Color Picker" ]
        , changePicker "RGB" RGB
        , viewColor selectedColor
        , Html.div
            [ style "display" "flex"
            , style "margin-top" "auto"
            ]
            [ Slider.view
                { increase = AdjustSaturation 1
                , decrease = AdjustSaturation -1
                , asColor = \saturation -> Color.fromHSL ( currentHue, toFloat saturation, 50 )
                , setTo = SetColor
                , valueMin = 0
                , valueMax = 100
                , valueNow = round currentSaturation
                , labelId = "saturation-selector"
                , labelText = "Saturation"
                }
            , Slider.view
                { increase = AdjustLightness 1
                , decrease = AdjustLightness -1
                , asColor = \lightness -> Color.fromHSL ( currentHue, currentSaturation, toFloat lightness )
                , setTo = SetColor
                , valueMin = 0
                , valueMax = 100
                , valueNow = round currentLightness
                , labelId = "lightness-selector"
                , labelText = "Lightness"
                }
            ]
        ]
    ]


viewRGBSelectors : Color -> List (Html Msg)
viewRGBSelectors selectedColor =
    let
        ( currentR, currentG, currentB ) =
            Color.toRGB selectedColor
    in
    [ Html.div []
        [ Html.div [ style "display" "flex" ]
            [ Slider.view
                { increase = AdjustRedness 1
                , decrease = AdjustRedness -1
                , asColor = \r -> Color.fromRGB ( toFloat r, 0, 0 )
                , setTo = SetColor
                , valueMin = 0
                , valueMax = 255
                , valueNow = round currentR
                , labelId = "redness-selector"
                , labelText = "Red"
                }
            , Slider.view
                { increase = AdjustGreenness 1
                , decrease = AdjustGreenness -1
                , asColor = \g -> Color.fromRGB ( 0, toFloat g, 0 )
                , setTo = SetColor
                , valueMin = 0
                , valueMax = 255
                , valueNow = round currentG
                , labelId = "greenness-selector"
                , labelText = "Green"
                }
            , Slider.view
                { increase = AdjustBlueness 1
                , decrease = AdjustBlueness -1
                , asColor = \b -> Color.fromRGB ( 0, 0, toFloat b )
                , setTo = SetColor
                , valueMin = 0
                , valueMax = 255
                , valueNow = round currentB
                , labelId = "blueness-selector"
                , labelText = "Blue"
                }
            ]
        ]
    , Html.div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        ]
        [ Html.h2 [] [ Html.text "RGB Color Picker" ]
        , changePicker "HSL" HSL
        , viewColor selectedColor
        ]
    ]


changePicker : String -> PickerStyle -> Html Msg
changePicker text pickerStyle =
    Html.button
        [ Html.Events.onClick (SetPickerStyle pickerStyle)
        , style "margin" "8px"
        ]
        [ Html.text ("View " ++ text ++ " ColorPicker") ]


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

        AdjustRedness by ->
            let
                ( current, g, b ) =
                    Color.toRGB color
            in
            Model (Color.fromRGB ( current + by, g, b )) pickerStyle

        AdjustGreenness by ->
            let
                ( r, current, b ) =
                    Color.toRGB color
            in
            Model (Color.fromRGB ( r, current + by, b )) pickerStyle

        AdjustBlueness by ->
            let
                ( r, g, current ) =
                    Color.toRGB color
            in
            Model (Color.fromRGB ( r, g, current + by )) pickerStyle

        SetColor newColor ->
            Model newColor pickerStyle

        SetPickerStyle newPickerStyle ->
            Model color newPickerStyle

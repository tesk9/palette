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
        , width = 100
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
                { setValue = toFloat >> setSaturation
                , asColor = \saturation -> Color.fromHSL ( currentHue, toFloat saturation, 50 )
                , valueMin = 0
                , valueMax = 100
                , valueNow = round currentSaturation
                , labelId = "saturation-selector"
                , labelText = "Saturation"
                , width = 100
                }
            , Slider.view
                { setValue = toFloat >> setLightness
                , asColor = \lightness -> Color.fromHSL ( currentHue, currentSaturation, toFloat lightness )
                , valueMin = 0
                , valueMax = 100
                , valueNow = round currentLightness
                , labelId = "lightness-selector"
                , labelText = "Lightness"
                , width = 100
                }
            ]
        ]
    ]


viewRGBSelectors : Color -> List (Html Msg)
viewRGBSelectors selectedColor =
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
        [ Html.div [ style "display" "flex" ]
            [ Slider.view
                { setValue = toFloat >> setR
                , asColor = \r -> Color.fromRGB ( toFloat r, 0, 0 )
                , valueMin = 0
                , valueMax = 255
                , valueNow = round currentR
                , labelId = "redness-selector"
                , labelText = "Red"
                , width = 40
                }
            , Slider.view
                { setValue = toFloat >> setG
                , asColor = \g -> Color.fromRGB ( 0, toFloat g, 0 )
                , valueMin = 0
                , valueMax = 255
                , valueNow = round currentG
                , labelId = "greenness-selector"
                , labelText = "Green"
                , width = 40
                }
            , Slider.view
                { setValue = toFloat >> setB
                , asColor = \b -> Color.fromRGB ( 0, 0, toFloat b )
                , valueMin = 0
                , valueMax = 255
                , valueNow = round currentB
                , labelId = "blueness-selector"
                , labelText = "Blue"
                , width = 40
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


type Msg
    = SetColor Color
    | SetPickerStyle PickerStyle


update : Msg -> Model -> Model
update msg (Model color pickerStyle) =
    case msg of
        SetColor newColor ->
            Model newColor pickerStyle

        SetPickerStyle newPickerStyle ->
            Model color newPickerStyle

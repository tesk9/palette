module ColorPicker exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator exposing (adjustLightness, adjustSaturation, rotate)
import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events
import Json.Decode
import Slider


type Model
    = Model Color


init : Model
init =
    Model (Color.fromHSL ( 0, 100, 50 ))


type Msg
    = AdjustHue Float
    | AdjustSaturation Float
    | AdjustLightness Float
    | SetColor Color


view : Model -> Html Msg
view model =
    Html.section
        [ style "display" "flex"
        , style "align-items" "stretch"
        , style "background-color" "lightgrey"
        , style "width" "445px"
        , style "border-radius" "8px"
        , style "border" "1px solid grey"
        ]
        [ hueSelector model
        , Html.div
            [ style "display" "flex"
            , style "flex-direction" "column"
            , style "align-items" "center"
            ]
            [ Html.h2 [] [ Html.text "HSL Color Picker" ]
            , viewColor model
            , Html.div
                [ style "display" "flex"
                , style "margin-top" "auto"
                ]
                [ saturationSelector model
                , lightnessSelector model
                ]
            ]
        ]


hueSelector : Model -> Html Msg
hueSelector (Model selectedColor) =
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


saturationSelector : Model -> Html Msg
saturationSelector (Model selectedColor) =
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


lightnessSelector : Model -> Html Msg
lightnessSelector (Model selectedColor) =
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


viewColor : Model -> Html msg
viewColor (Model color) =
    Html.div
        [ style "width" "150px"
        , style "height" "150px"
        , style "border-radius" "50%"
        , style "background-color" (Color.toRGBString color)
        ]
        []


update : Msg -> Model -> Model
update msg (Model color) =
    case msg of
        AdjustHue degree ->
            Model (rotate degree color)

        AdjustSaturation percentage ->
            Model (adjustSaturation percentage color)

        AdjustLightness percentage ->
            Model (adjustLightness percentage color)

        SetColor newColor ->
            Model newColor

module ColorPicker exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator exposing (adjustLightness, adjustSaturation, highContrast, rotate)
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
    Html.div
        []
        [ hueSelector model
        , saturationSelector model
        , lightnessSelector model
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
        , setTo = asColor >> SetColor
        , valueAsColor = asColor >> Color.toHSLString
        , valueToSliderColor = asColor >> highContrast >> Color.toHSLString
        , valueMin = 1
        , valueMax = 360
        , valueNow = round currentHue
        , labelId = "hue-selector"
        , labelText = "Hue Selector"
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
        , setTo = asColor >> SetColor
        , valueAsColor = asColor >> Color.toHSLString
        , valueToSliderColor = asColor >> highContrast >> Color.toHSLString
        , valueMin = 0
        , valueMax = 100
        , valueNow = round currentSaturation
        , labelId = "saturation-selector"
        , labelText = "Saturation Selector"
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
        , setTo = asColor >> SetColor
        , valueAsColor = asColor >> Color.toHSLString
        , valueToSliderColor = asColor >> highContrast >> Color.toHSLString
        , valueMin = 0
        , valueMax = 100
        , valueNow = round currentLightness
        , labelId = "lightness-selector"
        , labelText = "Lightness Selector"
        }


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

module ColorPicker exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator exposing (adjustLightness, adjustSaturation, rotate)
import Dict
import Html exposing (Html)
import Html.Attributes exposing (attribute, id, style)
import Html.Events
import Json.Decode


type alias Model =
    { selectedColor : Color
    }


init : Color -> Model
init color =
    Model color


view : Model -> Html Msg
view model =
    Html.label []
        [ Html.input
            [ Html.Attributes.type_ "color"
            , Color.toRGB model.selectedColor
                |> toHexString
                |> Html.Attributes.value
            , Html.Events.onInput SetHexColor
            ]
            []
        , Html.span [ style "padding" "2px" ] [ Html.text "Select a color" ]
        ]


type Msg
    = SetHexColor String


update : Msg -> Model -> ( Model, Maybe Color )
update msg { selectedColor } =
    case msg of
        SetHexColor colorString ->
            let
                newColor =
                    Color.fromHexString colorString
                        |> Result.withDefault selectedColor
            in
            ( Model newColor, Just newColor )



-- HEX conversions (to be pulled into the main Color module eventually)


getHexSymbol : Int -> String
getHexSymbol m =
    let
        hexValues =
            Dict.fromList
                [ ( 0, "0" )
                , ( 1, "1" )
                , ( 2, "2" )
                , ( 3, "3" )
                , ( 4, "4" )
                , ( 5, "5" )
                , ( 6, "6" )
                , ( 7, "7" )
                , ( 8, "8" )
                , ( 9, "9" )
                , ( 10, "A" )
                , ( 11, "B" )
                , ( 12, "C" )
                , ( 13, "D" )
                , ( 14, "E" )
                , ( 15, "F" )
                ]
    in
    Dict.get m hexValues
        |> Maybe.withDefault "0"


decToHex : Float -> String
decToHex c =
    let
        nextValue ( dec, hex ) =
            if dec == 0 then
                hex

            else
                nextValue
                    ( dec // 16
                    , getHexSymbol (remainderBy 16 dec) ++ hex
                    )
    in
    if c == 0 then
        "00"

    else
        nextValue ( round c, "" )


toHexString : ( Float, Float, Float ) -> String
toHexString ( r, g, b ) =
    "#" ++ decToHex r ++ decToHex g ++ decToHex b

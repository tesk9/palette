module Preview exposing (Model, Msg, init, update, view)

import Comparison
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import Json.Decode
import Palette.Generative as Generator
import SolidColor exposing (SolidColor)


type alias Model =
    { generators : List Generator
    , selectedGenerator : Generator
    }


type Generator
    = Generator
        { name : String
        , generate : SolidColor -> List SolidColor
        }
    | GeneratorWith
        { name : String
        , unit : Unit
        , generate : Float -> SolidColor -> List SolidColor
        , editable : Maybe Float
        }


generatorName : Generator -> String
generatorName generator =
    case generator of
        Generator { name } ->
            name

        GeneratorWith { name } ->
            name


type Unit
    = Degrees
    | Steps
    | Percentage


unitToString : Unit -> String
unitToString unit =
    case unit of
        Degrees ->
            "degrees"

        Steps ->
            "steps"

        Percentage ->
            "percent"


generatorList : ( Generator, List Generator )
generatorList =
    let
        apply generator normalize a b =
            normalize (generator a b)
    in
    ( Generator
        { name = "SolidColor.highContrast"
        , generate = SolidColor.highContrast >> List.singleton
        }
    , [ GeneratorWith
            { name = "SolidColor.blacken"
            , unit = Percentage
            , generate = apply SolidColor.blacken List.singleton
            , editable = Nothing
            }
      , GeneratorWith
            { name = "SolidColor.whiten"
            , unit = Percentage
            , generate = apply SolidColor.whiten List.singleton
            , editable = Nothing
            }
      , GeneratorWith
            { name = "SolidColor.grayen"
            , unit = Percentage
            , generate = apply SolidColor.grayen List.singleton
            , editable = Nothing
            }
      , Generator
            { name = "SolidColor.grayscale"
            , generate = SolidColor.grayscale >> List.singleton
            }
      , Generator
            { name = "SolidColor.invert"
            , generate = SolidColor.invert >> List.singleton
            }
      ]
    )


tupleToList : ( a, a ) -> List a
tupleToList ( a, b ) =
    [ a, b ]


tripleToList : ( a, a, a ) -> List a
tripleToList ( a, b, c ) =
    [ a, b, c ]


init : Model
init =
    { generators = Tuple.first generatorList :: Tuple.second generatorList
    , selectedGenerator = Tuple.first generatorList
    }


view : SolidColor -> Model -> Html Msg
view selectedColor model =
    Html.div [ style "margin-top" "4px" ]
        [ generatorOptions model
        , case model.selectedGenerator of
            Generator details ->
                viewPalette selectedColor details.name details.generate

            GeneratorWith details ->
                Html.div []
                    [ customValueEditor (unitToString details.unit) details.editable
                    , viewEditablePalette selectedColor details
                    ]
                    |> Html.map
                        (\newEditable ->
                            GeneratorWith { details | editable = newEditable }
                                |> SetGenerator
                        )
        ]


generatorOptions : Model -> Html Msg
generatorOptions model =
    Html.div [ style "margin-bottom" "8px" ]
        [ Html.label [ Html.Attributes.for "generator-select" ]
            [ Html.text "Modify/generate new colors with:" ]
        , Html.select
            [ Html.Attributes.id "generator-select"
            , Html.Events.onInput
                (\value ->
                    model.generators
                        |> List.filter (\g -> generatorName g == value)
                        |> List.head
                        |> Maybe.withDefault model.selectedGenerator
                        |> SetGenerator
                )
            ]
            (List.map (generatorOption (generatorName model.selectedGenerator)) model.generators)
        ]


generatorOption : String -> Generator -> Html Msg
generatorOption selectedGenerator generator =
    let
        name =
            generatorName generator
    in
    Html.option
        [ Html.Attributes.value name
        , Html.Attributes.selected (name == selectedGenerator)
        ]
        [ Html.text name ]


customValueEditor : String -> Maybe Float -> Html (Maybe Float)
customValueEditor unit currentValue =
    Html.div [ style "margin-bottom" "8px" ]
        [ Html.label []
            [ Html.input
                [ Maybe.map String.fromFloat currentValue
                    |> Maybe.withDefault ""
                    |> Html.Attributes.value
                , Html.Events.onInput String.toFloat
                ]
                []
            , Html.text unit
            ]
        ]


viewEditablePalette :
    SolidColor
    -> { a | name : String, generate : Float -> SolidColor -> List SolidColor, editable : Maybe Float }
    -> Html msg
viewEditablePalette selectedColor { name, generate, editable } =
    case editable of
        Just value ->
            viewPalette selectedColor (name ++ " " ++ String.fromFloat value) (generate value)

        Nothing ->
            Html.text ""


viewPalette : SolidColor -> String -> (SolidColor -> List SolidColor) -> Html msg
viewPalette selectedColor name generate =
    let
        ( r, g, b ) =
            SolidColor.toRGB selectedColor
    in
    Html.div []
        [ Html.code []
            [ Html.text
                (name
                    ++ " <| SolidColor.fromRGB ( "
                    ++ String.fromFloat r
                    ++ ", "
                    ++ String.fromFloat g
                    ++ ", "
                    ++ String.fromFloat b
                    ++ " ) == "
                )
            ]
        , Comparison.viewPalette (SolidColor.fromRGB ( 255, 255, 255 )) (generate selectedColor)
        ]


type Msg
    = SetGenerator Generator


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetGenerator generator ->
            { model | selectedGenerator = generator }

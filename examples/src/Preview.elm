module Preview exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator as Generator
import Comparison
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import Json.Decode


type alias Model =
    { generators : List Generator
    , selectedGenerator : Generator
    }


type Generator
    = Generator
        { name : String
        , generate : Color -> List Color
        }
    | GeneratorWith
        { name : String
        , unit : Unit
        , generate : Float -> Color -> List Color
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
        { name = "complementary"
        , generate = Generator.complementary >> List.singleton
        }
    , [ Generator
            { name = "triadic"
            , generate = Generator.triadic >> tupleToList
            }
      , GeneratorWith
            { name = "splitComplementary"
            , unit = Degrees
            , generate = apply Generator.splitComplementary tupleToList
            , editable = Nothing
            }
      , Generator
            { name = "square"
            , generate = Generator.square >> tripleToList
            }
      , GeneratorWith
            { name = "tetratic"
            , unit = Degrees
            , generate = apply Generator.tetratic tripleToList
            , editable = Nothing
            }
      , GeneratorWith
            { name = "monochromatic"
            , unit = Degrees
            , generate = Generator.monochromatic
            , editable = Nothing
            }
      , Generator
            { name = "highContrast"
            , generate = Generator.highContrast >> List.singleton
            }
      , GeneratorWith
            { name = "shade"
            , unit = Percentage
            , generate = apply Generator.shade List.singleton
            , editable = Nothing
            }
      , GeneratorWith
            { name = "tint"
            , unit = Percentage
            , generate = apply Generator.tint List.singleton
            , editable = Nothing
            }
      , GeneratorWith
            { name = "tone"
            , unit = Percentage
            , generate = apply Generator.tone List.singleton
            , editable = Nothing
            }
      , Generator
            { name = "grayscale"
            , generate = Generator.grayscale >> List.singleton
            }
      , Generator
            { name = "invert"
            , generate = Generator.invert >> List.singleton
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


view : Color -> Model -> Html Msg
view selectedColor model =
    Html.div [ style "margin-top" "4px" ]
        [ generatorOptions model
        , case model.selectedGenerator of
            Generator details ->
                viewPalette selectedColor details.generate

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
            [ Html.text "Color.Generator." ]
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
    Color
    -> { a | generate : Float -> Color -> List Color, editable : Maybe Float }
    -> Html msg
viewEditablePalette selectedColor { generate, editable } =
    case editable of
        Just value ->
            viewPalette selectedColor (generate value)

        Nothing ->
            Html.text ""


viewPalette : Color -> (Color -> List Color) -> Html msg
viewPalette selectedColor generate =
    Comparison.viewPalette selectedColor (generate selectedColor)


type Msg
    = SetGenerator Generator


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetGenerator generator ->
            { model | selectedGenerator = generator }

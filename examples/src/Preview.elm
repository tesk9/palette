module Preview exposing (Model, Msg, init, update, view)

import Comparison
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import Json.Decode
import OpaqueColor exposing (OpaqueColor)
import Palette.Generative as Generator


type alias Model =
    { generators : List Generator
    , selectedGenerator : Generator
    }


type Generator
    = Generator
        { name : String
        , generate : OpaqueColor -> List OpaqueColor
        }
    | GeneratorWith
        { name : String
        , unit : Unit
        , generate : Float -> OpaqueColor -> List OpaqueColor
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
        { name = "Palette.Generative.complementary"
        , generate = Generator.complementary >> List.singleton
        }
    , [ Generator
            { name = "Palette.Generative.triadic"
            , generate = Generator.triadic >> tupleToList
            }
      , GeneratorWith
            { name = "Palette.Generative.splitComplementary"
            , unit = Degrees
            , generate = apply Generator.splitComplementary tupleToList
            , editable = Nothing
            }
      , Generator
            { name = "Palette.Generative.square"
            , generate = Generator.square >> tripleToList
            }
      , GeneratorWith
            { name = "Palette.Generative.tetratic"
            , unit = Degrees
            , generate = apply Generator.tetratic tripleToList
            , editable = Nothing
            }
      , GeneratorWith
            { name = "Palette.Generative.monochromatic"
            , unit = Degrees
            , generate = Generator.monochromatic
            , editable = Nothing
            }
      , Generator
            { name = "OpaqueColor.highContrast"
            , generate = OpaqueColor.highContrast >> List.singleton
            }
      , GeneratorWith
            { name = "OpaqueColor.shade"
            , unit = Percentage
            , generate = apply OpaqueColor.shade List.singleton
            , editable = Nothing
            }
      , GeneratorWith
            { name = "OpaqueColor.tint"
            , unit = Percentage
            , generate = apply OpaqueColor.tint List.singleton
            , editable = Nothing
            }
      , GeneratorWith
            { name = "OpaqueColor.tone"
            , unit = Percentage
            , generate = apply OpaqueColor.tone List.singleton
            , editable = Nothing
            }
      , Generator
            { name = "OpaqueColor.grayscale"
            , generate = OpaqueColor.grayscale >> List.singleton
            }
      , Generator
            { name = "OpaqueColor.invert"
            , generate = OpaqueColor.invert >> List.singleton
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


view : OpaqueColor -> Model -> Html Msg
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
    OpaqueColor
    -> { a | name : String, generate : Float -> OpaqueColor -> List OpaqueColor, editable : Maybe Float }
    -> Html msg
viewEditablePalette selectedColor { name, generate, editable } =
    case editable of
        Just value ->
            viewPalette selectedColor (name ++ " " ++ String.fromFloat value) (generate value)

        Nothing ->
            Html.text ""


viewPalette : OpaqueColor -> String -> (OpaqueColor -> List OpaqueColor) -> Html msg
viewPalette selectedColor name generate =
    let
        ( r, g, b ) =
            OpaqueColor.toRGB selectedColor
    in
    Html.div []
        [ Html.code []
            [ Html.text
                (name
                    ++ " <| OpaqueColor.fromRGB ( "
                    ++ String.fromFloat r
                    ++ ", "
                    ++ String.fromFloat g
                    ++ ", "
                    ++ String.fromFloat b
                    ++ " ) == "
                )
            ]
        , Comparison.viewPalette (OpaqueColor.fromRGB ( 255, 255, 255 )) (generate selectedColor)
        ]


type Msg
    = SetGenerator Generator


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetGenerator generator ->
            { model | selectedGenerator = generator }

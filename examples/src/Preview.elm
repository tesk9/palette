module Preview exposing (Model, Msg, init, update, view)

import Colour exposing (Colour)
import Comparison
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import Json.Decode
import Palette.Generative as Generator


type alias Model =
    { generators : List Generator
    , selectedGenerator : Generator
    }


type Generator
    = Generator
        { name : String
        , generate : Colour -> List Colour
        }
    | GeneratorWith
        { name : String
        , unit : Unit
        , generate : Float -> Colour -> List Colour
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
        { name = "Colour.highContrast"
        , generate = Colour.highContrast >> List.singleton
        }
    , [ GeneratorWith
            { name = "Colour.blacken"
            , unit = Percentage
            , generate = apply Colour.blacken List.singleton
            , editable = Nothing
            }
      , GeneratorWith
            { name = "Colour.whiten"
            , unit = Percentage
            , generate = apply Colour.whiten List.singleton
            , editable = Nothing
            }
      , GeneratorWith
            { name = "Colour.grayen"
            , unit = Percentage
            , generate = apply Colour.grayen List.singleton
            , editable = Nothing
            }
      , Generator
            { name = "Colour.grayscale"
            , generate = Colour.grayscale >> List.singleton
            }
      , Generator
            { name = "Colour.invert"
            , generate = Colour.invert >> List.singleton
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


view : Colour -> Model -> Html Msg
view selectedColour model =
    Html.div [ style "margin-top" "4px" ]
        [ generatorOptions model
        , case model.selectedGenerator of
            Generator details ->
                viewPalette selectedColour details.name details.generate

            GeneratorWith details ->
                Html.div []
                    [ customValueEditor (unitToString details.unit) details.editable
                    , viewEditablePalette selectedColour details
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
            [ Html.text "Modify/generate new colours with:" ]
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
    Colour
    -> { a | name : String, generate : Float -> Colour -> List Colour, editable : Maybe Float }
    -> Html msg
viewEditablePalette selectedColour { name, generate, editable } =
    case editable of
        Just value ->
            viewPalette selectedColour (name ++ " " ++ String.fromFloat value) (generate value)

        Nothing ->
            Html.text ""


viewPalette : Colour -> String -> (Colour -> List Colour) -> Html msg
viewPalette selectedColour name generate =
    let
        ( r, g, b ) =
            Colour.toRGB selectedColour
    in
    Html.div []
        [ Html.code []
            [ Html.text
                (name
                    ++ " <| Colour.fromRGB ( "
                    ++ String.fromFloat r
                    ++ ", "
                    ++ String.fromFloat g
                    ++ ", "
                    ++ String.fromFloat b
                    ++ " ) == "
                )
            ]
        , Comparison.viewPalette (Colour.fromRGB ( 255, 255, 255 )) (generate selectedColour)
        ]


type Msg
    = SetGenerator Generator


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetGenerator generator ->
            { model | selectedGenerator = generator }

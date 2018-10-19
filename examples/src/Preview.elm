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
    = Generator String (Color -> List Color)
    | GeneratorWith Unit String (Float -> Color -> List Color) (Maybe Float)


generatorName : Generator -> String
generatorName generator =
    case generator of
        Generator name _ ->
            name

        GeneratorWith _ name _ _ ->
            name


type Unit
    = Degrees
    | Steps


unitToString : Unit -> String
unitToString unit =
    case unit of
        Degrees ->
            "Degrees"

        Steps ->
            "Steps"


generatorList : ( Generator, List Generator )
generatorList =
    ( Generator "complementary"
        (normalizeSingularFunction Generator.complementary)
    , [ Generator "triadic"
            (normalizeTupleFunction Generator.triadic)
      , GeneratorWith Degrees
            "splitComplementary"
            (\degrees -> normalizeTupleFunction (Generator.splitComplementary degrees))
            Nothing
      , Generator "square"
            (normalizeTripleFunction Generator.square)
      , GeneratorWith Degrees
            "tetratic"
            (\degrees -> normalizeTripleFunction (Generator.tetratic degrees))
            Nothing
      , GeneratorWith Degrees "monochromatic" Generator.monochromatic Nothing
      ]
    )


normalizeSingularFunction : (a -> a) -> a -> List a
normalizeSingularFunction func color =
    [ func color ]


normalizeTupleFunction : (a -> ( a, a )) -> a -> List a
normalizeTupleFunction func color =
    let
        ( one, two ) =
            func color
    in
    [ one, two ]


normalizeTripleFunction : (a -> ( a, a, a )) -> a -> List a
normalizeTripleFunction func color =
    let
        ( one, two, three ) =
            func color
    in
    [ one, two, three ]


init : Model
init =
    { generators = Tuple.first generatorList :: Tuple.second generatorList
    , selectedGenerator = Tuple.first generatorList
    }


view : Color -> Model -> Html Msg
view selectedColor model =
    Html.div [ style "margin-left" "20px" ]
        [ Html.h3 [] [ Html.text "Generate additional colors" ]
        , Html.div []
            [ generatorOptions model
            , case model.selectedGenerator of
                Generator name generate ->
                    viewPalette selectedColor generate

                GeneratorWith unit name generate unitIncrements ->
                    Html.div []
                        [ customValueEditor (unitToString unit) unitIncrements
                        , viewEditablePalette selectedColor generate unitIncrements
                        ]
                        |> Html.map (GeneratorWith unit name generate >> SetGenerator)
            ]
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


viewEditablePalette : Color -> (Float -> Color -> List Color) -> Maybe Float -> Html msg
viewEditablePalette selectedColor generate editable =
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

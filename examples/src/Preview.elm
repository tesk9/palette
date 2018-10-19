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
    | WithStep String (Float -> Color -> List Color) Step


type Step
    = Editing (Maybe Float)
    | Confirmed Float


generatorName : Generator -> String
generatorName generator =
    case generator of
        Generator name _ ->
            name

        WithStep name _ _ ->
            name


polychromatic : ( Generator, List Generator )
polychromatic =
    ( Generator "complementary"
        (normalizeSingularFunction Generator.complementary)
    , [ Generator "triadic"
            (normalizeTupleFunction Generator.triadic)
      , WithStep "splitComplementary"
            (\step -> normalizeTupleFunction (Generator.splitComplementary step))
            (Editing Nothing)
      , Generator "square"
            (normalizeTripleFunction Generator.square)
      , WithStep "tetratic"
            (\step -> normalizeTripleFunction (Generator.tetratic step))
            (Editing Nothing)

      --, Generator "monochromatic" Generator.monochromatic
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
    { generators = Tuple.first polychromatic :: Tuple.second polychromatic
    , selectedGenerator = Tuple.first polychromatic
    }


view : Color -> Model -> Html Msg
view selectedColor model =
    Html.div [ style "margin-left" "20px" ]
        [ Html.h3 [] [ Html.text "Generate additional colors" ]
        , Html.div [] <|
            case model.selectedGenerator of
                Generator name generate ->
                    [ generatorOptions model
                    , Comparison.viewPalette selectedColor (generate selectedColor)
                    ]

                WithStep name generate (Editing currentValue) ->
                    [ generatorOptions model
                    , Html.label []
                        [ Html.text "Degrees"
                        , Html.input
                            [ Maybe.map String.fromFloat currentValue
                                |> Maybe.withDefault ""
                                |> Html.Attributes.value
                            , Html.Events.onInput
                                (\value ->
                                    String.toFloat value
                                        |> Editing
                                        |> WithStep name generate
                                        |> SetStep
                                )
                            ]
                            []
                        ]
                    , Html.button
                        (case currentValue of
                            Just value ->
                                [ Html.Events.onClick
                                    (SetStep (WithStep name generate (Confirmed value)))
                                , Html.Attributes.disabled False
                                ]

                            Nothing ->
                                [ Html.Attributes.disabled True ]
                        )
                        [ Html.text "Generate!" ]
                    ]

                WithStep name generate (Confirmed step) ->
                    [ generatorOptions model
                    , Comparison.viewPalette selectedColor (generate step selectedColor)
                    ]
        ]


generatorOptions : Model -> Html Msg
generatorOptions model =
    Html.div [ style "margin-bottom" "8px" ]
        [ Html.label [ Html.Attributes.for "generator-select" ]
            [ Html.text "Color.Generator." ]
        , Html.select
            [ Html.Attributes.id "generator-select"
            , Html.Events.onInput SetGenerator
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


type Msg
    = SetGenerator String
    | SetStep Generator


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetGenerator generator ->
            { model
                | selectedGenerator =
                    model.generators
                        |> List.filter (\g -> generatorName g == generator)
                        |> List.head
                        |> Maybe.withDefault model.selectedGenerator
            }

        SetStep generator ->
            { model | selectedGenerator = generator }

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


polychromatic : ( Generator, List Generator )
polychromatic =
    ( Generator "complementary"
        (normalizeSingularFunction Generator.complementary)
    , [ Generator "triadic"
            (normalizeTupleFunction Generator.triadic)

      --, Generator "splitComplementary" Generator.splitComplementary
      , Generator "square"
            (normalizeTripleFunction Generator.square)

      --, Generator "tetratic"
      --      (normalizeTripleFunction Generator.tetratic)
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
    case model.selectedGenerator of
        Generator name generate ->
            Html.div [ style "margin-left" "20px" ]
                [ Html.h3 [] [ Html.text "Generate additional colors" ]
                , generatorOptions model
                , Comparison.viewPalette selectedColor (generate selectedColor)
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
            (List.map (generatorOption model.selectedGenerator) model.generators)
        ]


generatorOption : Generator -> Generator -> Html Msg
generatorOption (Generator selectedGenerator _) (Generator name generator) =
    Html.option
        [ Html.Attributes.value name
        , Html.Attributes.selected (name == selectedGenerator)
        ]
        [ Html.text name ]


type Msg
    = SetGenerator String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetGenerator generator ->
            { model
                | selectedGenerator =
                    model.generators
                        |> List.filter (\(Generator name _) -> name == generator)
                        |> List.head
                        |> Maybe.withDefault model.selectedGenerator
            }

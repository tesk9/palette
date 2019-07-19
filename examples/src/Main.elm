module Main exposing (main)

import Browser
import ColorModes
import ColorPicker
import Color exposing (Color)
import Comparison
import ExampleHelpers as Example
import Html exposing (Html)
import Palette.Generative
import Palette.X11 as X11
import PaletteExamples.Cubehelix
import PaletteExamples.Tango
import PaletteExamples.X11
import Platform
import Preview
import TransparentColorExamples
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string)


main : Platform.Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


init : Model
init =
    let
        selectedColor =
            Color.fromHSL ( 0, 100, 50 )
    in
    { colorModesModel = ColorModes.init
    , colorPickerModel = ColorPicker.init selectedColor
    , previewModel = Preview.init
    , selectedColor = selectedColor
    }


type alias Model =
    { colorModesModel : ColorModes.Model
    , colorPickerModel : ColorPicker.Model
    , previewModel : Preview.Model
    , selectedColor : Color
    }


type Msg
    = ColorModesMsg ColorModes.Msg
    | ColorPickerMsg ColorPicker.Msg
    | PreviewMsg Preview.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        ColorModesMsg colorMsg ->
            { model | colorModesModel = ColorModes.update colorMsg model.colorModesModel }

        ColorPickerMsg colorMsg ->
            let
                ( newColorPickerModel, maybeNewColor ) =
                    ColorPicker.update colorMsg model.colorPickerModel
            in
            { model
                | colorPickerModel = newColorPickerModel
                , selectedColor = Maybe.withDefault model.selectedColor maybeNewColor
            }

        PreviewMsg previewMsg ->
            { model | previewModel = Preview.update previewMsg model.previewModel }


view : Model -> Html Msg
view model =
    Html.main_ []
        [ Html.h1 [] [ Html.text "Examples" ]
        , Example.section "Color"
            (Html.div []
                [ Example.subsection "API"
                    (Html.div []
                        [ ColorPicker.view model.colorPickerModel
                            |> Html.map ColorPickerMsg
                        , Preview.view model.selectedColor model.previewModel
                            |> Html.map PreviewMsg
                        ]
                    )
                , Example.subsection "Grayscale"
                    (Example.list rainbow viewGrayscale)
                , Example.subsection "Invert"
                    (Example.list rainbow viewInverse)
                , Example.subsection "Monochromatic"
                    (Html.div []
                        [ Html.h4 [] [ Html.text "Shades" ]
                        , Example.list rainbow viewMonochromaticShades
                        , Html.h4 [] [ Html.text "Tints" ]
                        , Example.list rainbow viewMonochromaticTints
                        , Html.h4 [] [ Html.text "Tones" ]
                        , Example.list rainbow viewMonochromaticTones
                        ]
                    )
                , Example.subsection "Blending"
                    (Html.div []
                        [ Html.h4 [] [ Html.text "Add" ]
                        , Example.list (List.map (\color -> ( color, X11.lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Color.add)
                        , Html.h4 [] [ Html.text "Subtract" ]
                        , Example.list (List.map (\color -> ( color, X11.lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Color.subtract)
                        , Html.h4 [] [ Html.text "Multiply" ]
                        , Example.list (List.map (\color -> ( color, X11.lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Color.multiply)
                        , Html.h4 [] [ Html.text "Divide" ]
                        , Example.list (List.map (\color -> ( color, X11.lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Color.divide)
                        ]
                    )
                , Example.subsection "Contrast"
                    (ColorModes.view model.colorModesModel
                        |> Html.map ColorModesMsg
                    )
                ]
            )
        , Example.section "Color.Transparent" TransparentColorExamples.view
        , Example.section "Palette.Cubehelix" PaletteExamples.Cubehelix.examples
        , Example.section "Palette.Tango" PaletteExamples.Tango.examples
        , Example.section "Palette.X11" PaletteExamples.X11.examples
        , Example.section "Palette.Generative"
            (Html.div
                []
                [ Example.subsection "Complementary"
                    (Example.list rainbow viewComplementary)
                , Example.subsection "Triadic"
                    (Example.list rainbow viewTriadic)
                , Example.subsection "Split Complementary"
                    (Example.list (List.map (\color -> ( 30, color )) rainbow)
                        viewSplitComplementary
                    )
                , Example.subsection "Square"
                    (Example.list rainbow viewSquare)
                , Example.subsection "Tetratic"
                    (Example.list (List.map (\color -> ( 30, color )) rainbow)
                        viewRectangle
                    )
                , Example.subsection "Monochromatic"
                    (Example.list (List.map (\color -> ( 10, color )) rainbow)
                        viewMonochromaticGenerator
                    )
                ]
            )
        ]


viewGrayscale : Color -> Html msg
viewGrayscale color =
    Comparison.viewPalette color [ Color.grayscale color ]


viewInverse : Color -> Html msg
viewInverse color =
    Comparison.viewPalette color [ Color.invert color ]


viewComplementary : Color -> Html msg
viewComplementary color =
    Comparison.viewPalette color [ Palette.Generative.complementary color ]


viewTriadic : Color -> Html msg
viewTriadic color =
    let
        ( one, two ) =
            Palette.Generative.triadic color
    in
    Comparison.viewPalette color [ one, two ]


viewSplitComplementary : ( Float, Color ) -> Html msg
viewSplitComplementary ( degree, color ) =
    let
        ( one, two ) =
            Palette.Generative.splitComplementary degree color
    in
    Comparison.viewPalette color [ one, two ]


viewSquare : Color -> Html msg
viewSquare color =
    let
        ( one, two, three ) =
            Palette.Generative.square color
    in
    Comparison.viewPalette color [ one, two, three ]


viewRectangle : ( Float, Color ) -> Html msg
viewRectangle ( degree, color ) =
    let
        ( one, two, three ) =
            Palette.Generative.tetratic degree color
    in
    Comparison.viewPalette color [ one, two, three ]


viewMonochromaticShades : Color -> Html msg
viewMonochromaticShades color =
    Comparison.viewPalette color
        [ Color.blacken 10 color
        , Color.blacken 20 color
        , Color.blacken 30 color
        , Color.blacken 40 color
        ]


viewMonochromaticTints : Color -> Html msg
viewMonochromaticTints color =
    Comparison.viewPalette color
        [ Color.whiten 10 color
        , Color.whiten 20 color
        , Color.whiten 30 color
        , Color.whiten 40 color
        , Color.whiten 50 color
        ]


viewMonochromaticTones : Color -> Html msg
viewMonochromaticTones color =
    Comparison.viewPalette color
        [ Color.grayen 20 color
        , Color.grayen 40 color
        , Color.grayen 60 color
        , Color.grayen 80 color
        , Color.grayen 100 color
        ]


viewMonochromaticGenerator : ( Float, Color ) -> Html msg
viewMonochromaticGenerator ( stepSize, color ) =
    Comparison.viewPalette color
        (Palette.Generative.monochromatic stepSize color)



-- SUPER CONVENIENT COLORS


rainbow : List Color
rainbow =
    [ X11.coral
    , X11.olive
    , X11.gold
    , X11.teal
    , X11.blueViolet
    ]

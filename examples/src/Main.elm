module Main exposing (main)

import Browser
import ColorModes
import ColorPicker
import Comparison
import ExampleHelpers as Example
import Html exposing (Html)
import OpaqueColor exposing (OpaqueColor)
import OpaqueColor.Blend
import OpaqueColor.Contrast
import OpaqueColor.Generator
import Palette.Tango as Tango
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
            OpaqueColor.fromHSL ( 0, 100, 50 )
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
    , selectedColor : OpaqueColor
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
        , Example.section "API"
            (Html.div []
                [ ColorPicker.view model.colorPickerModel
                    |> Html.map ColorPickerMsg
                , Preview.view model.selectedColor model.previewModel
                    |> Html.map PreviewMsg
                ]
            )
        , Example.section "Contrast"
            (ColorModes.view model.colorModesModel
                |> Html.map ColorModesMsg
            )
        , Example.section "OpaqueColor Schemes"
            (Html.div []
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
                , Example.subsection "Grayscale"
                    (Example.list rainbow viewGrayscale)
                , Example.subsection "Invert"
                    (Example.list rainbow viewInverse)
                , Example.subsection "Monochromatic"
                    (Html.div []
                        [ Html.h4 [] [ Html.text "Monochromatic Palette" ]
                        , Example.list (List.map (\color -> ( 10, color )) rainbow)
                            viewMonochromaticGenerator
                        , Html.h4 [] [ Html.text "Shades" ]
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
                            (Comparison.viewOverlapping OpaqueColor.Blend.add)
                        , Html.h4 [] [ Html.text "Subtract" ]
                        , Example.list (List.map (\color -> ( color, X11.lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping OpaqueColor.Blend.subtract)
                        , Html.h4 [] [ Html.text "Multiply" ]
                        , Example.list (List.map (\color -> ( color, X11.lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping OpaqueColor.Blend.multiply)
                        , Html.h4 [] [ Html.text "Divide" ]
                        , Example.list (List.map (\color -> ( color, X11.lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping OpaqueColor.Blend.divide)
                        ]
                    )
                ]
            )
        , Example.section "Palette"
            (Html.div []
                [ PaletteExamples.Tango.examples
                , PaletteExamples.X11.examples
                , PaletteExamples.Cubehelix.examples
                ]
            )
        , Example.section "Transparent Colors"
            TransparentColorExamples.view
        ]


viewGrayscale : OpaqueColor -> Html msg
viewGrayscale color =
    Comparison.viewPalette color [ OpaqueColor.Generator.grayscale color ]


viewInverse : OpaqueColor -> Html msg
viewInverse color =
    Comparison.viewPalette color [ OpaqueColor.Generator.invert color ]


viewComplementary : OpaqueColor -> Html msg
viewComplementary color =
    Comparison.viewPalette color [ OpaqueColor.Generator.complementary color ]


viewTriadic : OpaqueColor -> Html msg
viewTriadic color =
    let
        ( one, two ) =
            OpaqueColor.Generator.triadic color
    in
    Comparison.viewPalette color [ one, two ]


viewSplitComplementary : ( Float, OpaqueColor ) -> Html msg
viewSplitComplementary ( degree, color ) =
    let
        ( one, two ) =
            OpaqueColor.Generator.splitComplementary degree color
    in
    Comparison.viewPalette color [ one, two ]


viewSquare : OpaqueColor -> Html msg
viewSquare color =
    let
        ( one, two, three ) =
            OpaqueColor.Generator.square color
    in
    Comparison.viewPalette color [ one, two, three ]


viewRectangle : ( Float, OpaqueColor ) -> Html msg
viewRectangle ( degree, color ) =
    let
        ( one, two, three ) =
            OpaqueColor.Generator.tetratic degree color
    in
    Comparison.viewPalette color [ one, two, three ]


viewMonochromaticShades : OpaqueColor -> Html msg
viewMonochromaticShades color =
    Comparison.viewPalette color
        [ OpaqueColor.Generator.shade 10 color
        , OpaqueColor.Generator.shade 20 color
        , OpaqueColor.Generator.shade 30 color
        , OpaqueColor.Generator.shade 40 color
        ]


viewMonochromaticTints : OpaqueColor -> Html msg
viewMonochromaticTints color =
    Comparison.viewPalette color
        [ OpaqueColor.Generator.tint 10 color
        , OpaqueColor.Generator.tint 20 color
        , OpaqueColor.Generator.tint 30 color
        , OpaqueColor.Generator.tint 40 color
        , OpaqueColor.Generator.tint 50 color
        ]


viewMonochromaticTones : OpaqueColor -> Html msg
viewMonochromaticTones color =
    Comparison.viewPalette color
        [ OpaqueColor.Generator.tone -100 color
        , OpaqueColor.Generator.tone -80 color
        , OpaqueColor.Generator.tone -60 color
        , OpaqueColor.Generator.tone -40 color
        , OpaqueColor.Generator.tone -20 color
        ]


viewMonochromaticGenerator : ( Float, OpaqueColor ) -> Html msg
viewMonochromaticGenerator ( stepSize, color ) =
    Comparison.viewPalette color
        (OpaqueColor.Generator.monochromatic stepSize color)



-- SUPER CONVENIENT COLORS


rainbow : List OpaqueColor
rainbow =
    [ X11.coral
    , X11.olive
    , X11.gold
    , X11.teal
    , X11.blueViolet
    ]

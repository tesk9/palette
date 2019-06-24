module Main exposing (main)

import Browser
import ColourModes
import ColourPicker
import Colour exposing (Colour)
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
import TransparentColourExamples
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
        selectedColour =
            Colour.fromHSL ( 0, 100, 50 )
    in
    { colourModesModel = ColourModes.init
    , colourPickerModel = ColourPicker.init selectedColour
    , previewModel = Preview.init
    , selectedColour = selectedColour
    }


type alias Model =
    { colourModesModel : ColourModes.Model
    , colourPickerModel : ColourPicker.Model
    , previewModel : Preview.Model
    , selectedColour : Colour
    }


type Msg
    = ColourModesMsg ColourModes.Msg
    | ColourPickerMsg ColourPicker.Msg
    | PreviewMsg Preview.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        ColourModesMsg colourMsg ->
            { model | colourModesModel = ColourModes.update colourMsg model.colourModesModel }

        ColourPickerMsg colourMsg ->
            let
                ( newColourPickerModel, maybeNewColour ) =
                    ColourPicker.update colourMsg model.colourPickerModel
            in
            { model
                | colourPickerModel = newColourPickerModel
                , selectedColour = Maybe.withDefault model.selectedColour maybeNewColour
            }

        PreviewMsg previewMsg ->
            { model | previewModel = Preview.update previewMsg model.previewModel }


view : Model -> Html Msg
view model =
    Html.main_ []
        [ Html.h1 [] [ Html.text "Examples" ]
        , Example.section "Colour"
            (Html.div []
                [ Example.subsection "API"
                    (Html.div []
                        [ ColourPicker.view model.colourPickerModel
                            |> Html.map ColourPickerMsg
                        , Preview.view model.selectedColour model.previewModel
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
                        , Example.list (List.map (\colour -> ( colour, X11.lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Colour.add)
                        , Html.h4 [] [ Html.text "Subtract" ]
                        , Example.list (List.map (\colour -> ( colour, X11.lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Colour.subtract)
                        , Html.h4 [] [ Html.text "Multiply" ]
                        , Example.list (List.map (\colour -> ( colour, X11.lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Colour.multiply)
                        , Html.h4 [] [ Html.text "Divide" ]
                        , Example.list (List.map (\colour -> ( colour, X11.lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Colour.divide)
                        ]
                    )
                , Example.subsection "Contrast"
                    (ColourModes.view model.colourModesModel
                        |> Html.map ColourModesMsg
                    )
                ]
            )
        , Example.section "Colour.Transparent" TransparentColourExamples.view
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
                    (Example.list (List.map (\colour -> ( 30, colour )) rainbow)
                        viewSplitComplementary
                    )
                , Example.subsection "Square"
                    (Example.list rainbow viewSquare)
                , Example.subsection "Tetratic"
                    (Example.list (List.map (\colour -> ( 30, colour )) rainbow)
                        viewRectangle
                    )
                , Example.subsection "Monochromatic"
                    (Example.list (List.map (\colour -> ( 10, colour )) rainbow)
                        viewMonochromaticGenerator
                    )
                ]
            )
        ]


viewGrayscale : Colour -> Html msg
viewGrayscale colour =
    Comparison.viewPalette colour [ Colour.grayscale colour ]


viewInverse : Colour -> Html msg
viewInverse colour =
    Comparison.viewPalette colour [ Colour.invert colour ]


viewComplementary : Colour -> Html msg
viewComplementary colour =
    Comparison.viewPalette colour [ Palette.Generative.complementary colour ]


viewTriadic : Colour -> Html msg
viewTriadic colour =
    let
        ( one, two ) =
            Palette.Generative.triadic colour
    in
    Comparison.viewPalette colour [ one, two ]


viewSplitComplementary : ( Float, Colour ) -> Html msg
viewSplitComplementary ( degree, colour ) =
    let
        ( one, two ) =
            Palette.Generative.splitComplementary degree colour
    in
    Comparison.viewPalette colour [ one, two ]


viewSquare : Colour -> Html msg
viewSquare colour =
    let
        ( one, two, three ) =
            Palette.Generative.square colour
    in
    Comparison.viewPalette colour [ one, two, three ]


viewRectangle : ( Float, Colour ) -> Html msg
viewRectangle ( degree, colour ) =
    let
        ( one, two, three ) =
            Palette.Generative.tetratic degree colour
    in
    Comparison.viewPalette colour [ one, two, three ]


viewMonochromaticShades : Colour -> Html msg
viewMonochromaticShades colour =
    Comparison.viewPalette colour
        [ Colour.blacken 10 colour
        , Colour.blacken 20 colour
        , Colour.blacken 30 colour
        , Colour.blacken 40 colour
        ]


viewMonochromaticTints : Colour -> Html msg
viewMonochromaticTints colour =
    Comparison.viewPalette colour
        [ Colour.whiten 10 colour
        , Colour.whiten 20 colour
        , Colour.whiten 30 colour
        , Colour.whiten 40 colour
        , Colour.whiten 50 colour
        ]


viewMonochromaticTones : Colour -> Html msg
viewMonochromaticTones colour =
    Comparison.viewPalette colour
        [ Colour.grayen 20 colour
        , Colour.grayen 40 colour
        , Colour.grayen 60 colour
        , Colour.grayen 80 colour
        , Colour.grayen 100 colour
        ]


viewMonochromaticGenerator : ( Float, Colour ) -> Html msg
viewMonochromaticGenerator ( stepSize, colour ) =
    Comparison.viewPalette colour
        (Palette.Generative.monochromatic stepSize colour)



-- SUPER CONVENIENT COLORS


rainbow : List Colour
rainbow =
    [ X11.coral
    , X11.olive
    , X11.gold
    , X11.teal
    , X11.blueViolet
    ]

module Main exposing (main)

import Browser
import Color exposing (Color)
import Color.Blend
import Color.Contrast
import Color.Generator
import Html exposing (Html)
import Html.Attributes exposing (style)
import Palette.X11 exposing (..)
import Platform


main : Platform.Program () Model Msg
main =
    Browser.sandbox
        { init = {}
        , update = \_ model -> model
        , view = view
        }


type alias Model =
    {}


view : Model -> Html msg
view _ =
    Html.main_ []
        [ Html.h1 [] [ Html.text "Examples" ]
        , exampleSection "Contrast checks"
            (exampleList [ ( red, yellow ) ] viewContrast)
        , exampleSection "Color Schemes"
            (Html.div []
                [ exampleSubsection "Complementary"
                    (exampleList rainbow viewComplementary)
                , exampleSubsection "Triadic"
                    (exampleList rainbow viewTriadic)
                , exampleSubsection "Split Complementary"
                    (exampleList (List.map (\color -> ( 30, color )) rainbow)
                        viewSplitComplementary
                    )
                , exampleSubsection "Square"
                    (exampleList rainbow viewSquare)
                , exampleSubsection "Tetratic"
                    (exampleList (List.map (\color -> ( 30, color )) rainbow)
                        viewRectangle
                    )
                , exampleSubsection "Grayscale"
                    (exampleList rainbow viewGrayscale)
                , exampleSubsection "Monochromatic"
                    (Html.div []
                        [ Html.h4 [] [ Html.text "Monochromatic Palette" ]
                        , exampleList (List.map (\color -> ( 10, color )) rainbow)
                            viewMonochromaticGenerator
                        , exampleList
                            (List.map (\stepSize -> ( toFloat stepSize * 5, black )) (List.range 1 11))
                            viewMonochromaticGenerator
                        , Html.h4 [] [ Html.text "Shades" ]
                        , exampleList rainbow viewMonochromaticShades
                        , Html.h4 [] [ Html.text "Tints" ]
                        , exampleList rainbow viewMonochromaticTints
                        , Html.h4 [] [ Html.text "Tones" ]
                        , exampleList rainbow viewMonochromaticTones
                        ]
                    )
                , exampleSubsection "Blending"
                    (Html.div []
                        [ Html.h4 [] [ Html.text "Add" ]
                        , exampleList (List.map (\color -> ( color, lightSeaGreen )) rainbow)
                            (overlappingSquares Color.Blend.add)
                        , Html.h4 [] [ Html.text "Subtract" ]
                        , exampleList (List.map (\color -> ( color, lightSeaGreen )) rainbow)
                            (overlappingSquares Color.Blend.subtract)
                        , Html.h4 [] [ Html.text "Multiply" ]
                        , exampleList (List.map (\color -> ( color, lightSeaGreen )) rainbow)
                            (overlappingSquares Color.Blend.multiply)
                        , Html.h4 [] [ Html.text "Divide" ]
                        , exampleList (List.map (\color -> ( color, lightSeaGreen )) rainbow)
                            (overlappingSquares Color.Blend.divide)
                        ]
                    )
                ]
            )
        , exampleSection "Palette"
            (Html.div []
                [ exampleSubsection "X11"
                    (Html.div []
                        [ Html.h4 [] [ Html.text "Pinks" ]
                        , exampleList [ pink, lightPink, hotPink, deepPink, paleVioletRed, mediumVioletRed ] cell
                        , Html.h4 [] [ Html.text "Reds" ]
                        , exampleList [ lightSalmon, salmon, darkSalmon, lightCoral, indianRed, crimson, firebrick, darkRed, red ] cell
                        , Html.h4 [] [ Html.text "Orange-Reds" ]
                        , exampleList [ orangeRed, tomato, coral, darkOrange, orange ] cell
                        , Html.h4 [] [ Html.text "Yellows" ]
                        , exampleList [ yellow, lightYellow, lemonChiffon, lightGoldenrodYellow, papayaWhip, moccasin, peachPuff, paleGoldenrod, khaki, darkKhaki, gold ] cell
                        , Html.h4 [] [ Html.text "Browns" ]
                        , exampleList [ cornsilk, blanchedAlmond, bisque, navajoWhite, wheat, burlywood, Palette.X11.tan, rosyBrown, sandyBrown, goldenrod, darkGoldenrod, peru, chocolate, saddleBrown, sienna, brown, maroon ] cell
                        , Html.h4 [] [ Html.text "Greens" ]
                        , exampleList [ darkOliveGreen, olive, oliveDrab, yellowGreen, limeGreen, lime, lawnGreen, chartreuse, greenYellow, springGreen, mediumSpringGreen, lightGreen, paleGreen, darkSeaGreen, mediumAquamarine, mediumSeaGreen, seaGreen, forestGreen, green, darkGreen ] cell
                        , Html.h4 [] [ Html.text "Cyans" ]
                        , exampleList [ aqua, cyan, lightCyan, paleTurquoise, aquamarine, turquoise, mediumTurquoise, darkTurquoise, lightSeaGreen, cadetBlue, darkCyan, teal ] cell
                        , Html.h4 [] [ Html.text "Blues" ]
                        , exampleList [ lightSteelBlue, powderBlue, lightBlue, skyBlue, lightSkyBlue, deepSkyBlue, dodgerBlue, cornflowerBlue, steelBlue, royalBlue, blue, mediumBlue, darkBlue, navy, midnightBlue ] cell
                        , Html.h4 [] [ Html.text "Purples" ]
                        , exampleList [ lavender, thistle, plum, violet, orchid, fuchsia, magenta, mediumOrchid, mediumPurple, blueViolet, darkViolet, darkOrchid, darkMagenta, purple, indigo, darkSlateBlue, slateBlue, mediumSlateBlue ] cell
                        , Html.h4 [] [ Html.text "Whites" ]
                        , exampleList [ white, snow, honeydew, mintCream, azure, aliceBlue, ghostWhite, whiteSmoke, seashell, beige, oldLace, floralWhite, ivory, antiqueWhite, linen, lavenderBlush, mistyRose ] cell
                        , Html.h4 [] [ Html.text "Blacks and Grays" ]
                        , exampleList [ gainsboro, lightGray, silver, darkGray, gray, dimGray, lightSlateGray, slateGray, darkSlateGray, black ] cell
                        ]
                    )
                ]
            )
        ]


exampleSection : String -> Html msg -> Html msg
exampleSection heading examples =
    Html.section []
        [ Html.h2 [] [ Html.text heading ]
        , examples
        ]


exampleSubsection : String -> Html msg -> Html msg
exampleSubsection heading examples =
    Html.div []
        [ Html.h3 [] [ Html.text heading ]
        , examples
        ]


exampleList : List a -> (a -> Html msg) -> Html msg
exampleList examples viewExample =
    Html.ul
        [ style "list-style" "none"
        , style "display" "flex"
        , style "flex-wrap" "wrap"
        ]
        (List.map
            (\example -> Html.li [] [ viewExample example ])
            examples
        )


viewContrast : ( Color, Color ) -> Html msg
viewContrast ( a, b ) =
    cellsContainer [ plainCell a, plainCell b ]


viewGrayscale : Color -> Html msg
viewGrayscale color =
    cellsContainer
        [ plainCell color, plainCell (Color.Generator.grayscale color) ]


viewComplementary : Color -> Html msg
viewComplementary color =
    cellsContainer
        [ plainCell color, plainCell (Color.Generator.complementary color) ]


viewTriadic : Color -> Html msg
viewTriadic color =
    let
        ( one, two ) =
            Color.Generator.triadic color
    in
    cellsContainer
        [ plainCell color, multiCells [ one, two ] ]


viewSplitComplementary : ( Float, Color ) -> Html msg
viewSplitComplementary ( degree, color ) =
    let
        ( one, two ) =
            Color.Generator.splitComplementary degree color
    in
    cellsContainer
        [ plainCell color, multiCells [ one, two ] ]


viewSquare : Color -> Html msg
viewSquare color =
    let
        ( one, two, three ) =
            Color.Generator.square color
    in
    cellsContainer
        [ plainCell color, multiCells [ one, two, three ] ]


viewRectangle : ( Float, Color ) -> Html msg
viewRectangle ( degree, color ) =
    let
        ( one, two, three ) =
            Color.Generator.tetratic degree color
    in
    cellsContainer
        [ plainCell color, multiCells [ one, two, three ] ]


viewMonochromaticShades : Color -> Html msg
viewMonochromaticShades color =
    cellsContainer
        [ plainCell color
        , multiCells
            [ color
            , Color.Generator.shade 10 color
            , Color.Generator.shade 20 color
            , Color.Generator.shade 30 color
            , Color.Generator.shade 40 color
            ]
        ]


viewMonochromaticTints : Color -> Html msg
viewMonochromaticTints color =
    cellsContainer
        [ plainCell color
        , multiCells
            [ color
            , Color.Generator.tint 10 color
            , Color.Generator.tint 20 color
            , Color.Generator.tint 30 color
            , Color.Generator.tint 40 color
            ]
        ]


viewMonochromaticTones : Color -> Html msg
viewMonochromaticTones color =
    cellsContainer
        [ plainCell color
        , multiCells
            [ Color.Generator.tone -100 color
            , Color.Generator.tone -80 color
            , Color.Generator.tone -60 color
            , Color.Generator.tone -40 color
            , Color.Generator.tone -20 color
            , color
            , Color.Generator.tone 20 color
            , Color.Generator.tone 40 color
            ]
        ]


viewMonochromaticGenerator : ( Float, Color ) -> Html msg
viewMonochromaticGenerator ( stepSize, color ) =
    cellsContainer
        [ plainCell color
        , multiCells (Color.Generator.monochromatic stepSize color)
        ]


cellsContainer : List (Html msg) -> Html msg
cellsContainer =
    Html.div [ style "margin" "8px" ]


cell : Color -> Html msg
cell color =
    let
        rgbColor =
            Color.toRGBString color
    in
    Html.div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "flex-start"
        , style "background-color" rgbColor
        ]
        [ Html.span
            [ style "margin" "8px 40px"
            , style "padding" "4px"
            , style "background-color" "white"
            , style "overflow" "scroll"
            , style "text-align" "center"
            , style "width" "130px"
            ]
            [ Html.div [] [ Html.text rgbColor ] ]
        ]


plainCell : Color -> Html msg
plainCell color =
    Html.div
        [ style "background-color" (Color.toRGBString color)
        , style "height" "50px"
        , style "width" "100px"
        ]
        []


multiCells : List Color -> Html msg
multiCells colors =
    let
        miniCell color =
            Html.span
                [ style "width" "100%"
                , style "height" "20px"
                , style "background-color" color
                ]
                []
    in
    Html.div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "flex-start"
        ]
        (List.map (\color -> miniCell (Color.toRGBString color)) colors)


overlappingSquares : (Color -> Color -> Color) -> ( Color, Color ) -> Html msg
overlappingSquares blend ( a, b ) =
    Html.div
        [ style "width" "100px"
        , style "height" "100px"
        , style "background-color" (Color.toRGBString a)
        , style "position" "relative"
        , style "margin-right" "70px"
        , style "margin-bottom" "70px"
        ]
        [ Html.div
            [ style "width" "100px"
            , style "height" "100px"
            , style "background-color" (Color.toRGBString b)
            , style "position" "relative"
            , style "top" "40%"
            , style "left" "40%"
            ]
            [ Html.div
                [ style "width" "60px"
                , style "height" "60px"
                , style "background-color" (Color.toRGBString (blend a b))
                , style "position" "relative"
                , style "top" "0"
                , style "left" "0"
                ]
                []
            ]
        ]


type alias Msg =
    ()



-- SUPER CONVENIENT COLORS


rainbow : List Color
rainbow =
    [ red, orange, yellow, green, blue, purple, lightSeaGreen, coral, hotPink, lavender, aliceBlue ]

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
                        , exampleList
                            [ ( pink, "pink" )
                            , ( lightPink, "lightPink" )
                            , ( hotPink, "hotPink" )
                            , ( deepPink, "deepPink" )
                            , ( paleVioletRed, "paleVioletRed" )
                            , ( mediumVioletRed, "mediumVioletRed" )
                            ]
                            cell
                        , Html.h4 [] [ Html.text "Reds" ]
                        , exampleList
                            [ ( lightSalmon, "lightSalmon" )
                            , ( salmon, "salmon" )
                            , ( darkSalmon, "darkSalmon" )
                            , ( lightCoral, "lightCoral" )
                            , ( indianRed, "indianRed" )
                            , ( crimson, "crimson" )
                            , ( firebrick, "firebrick" )
                            , ( darkRed, "darkRed" )
                            , ( red, "red" )
                            ]
                            cell
                        , Html.h4 [] [ Html.text "Orange-Reds" ]
                        , exampleList
                            [ ( orangeRed, "orangeRed" )
                            , ( tomato, "tomato" )
                            , ( coral, "coral" )
                            , ( darkOrange, "coral" )
                            , ( orange, "coral" )
                            ]
                            cell
                        , Html.h4 [] [ Html.text "Yellows" ]
                        , exampleList
                            [ ( yellow, "yellow" )
                            , ( lightYellow, "lightYellow" )
                            , ( lemonChiffon, "lemonChiffon" )
                            , ( lightGoldenrodYellow, "lightGoldenrodYellow" )
                            , ( papayaWhip, "papayaWhip" )
                            , ( moccasin, "moccasin" )
                            , ( peachPuff, "peachPuff" )
                            , ( paleGoldenrod, "paleGoldenrod" )
                            , ( khaki, "khaki" )
                            , ( darkKhaki, "darkKhaki" )
                            , ( gold, "gold" )
                            ]
                            cell
                        , Html.h4 [] [ Html.text "Browns" ]
                        , exampleList
                            [ ( cornsilk, "cornsilk" )
                            , ( blanchedAlmond, "blanchedAlmond" )
                            , ( bisque, "bisque" )
                            , ( navajoWhite, "navajoWhite" )
                            , ( wheat, "wheat" )
                            , ( burlywood, "burlywood" )
                            , ( Palette.X11.tan, "tan" )
                            , ( rosyBrown, "rosyBrown" )
                            , ( sandyBrown, "sandyBrown" )
                            , ( goldenrod, "goldenrod" )
                            , ( darkGoldenrod, "darkGoldenrod" )
                            , ( peru, "peru" )
                            , ( chocolate, "chocolate" )
                            , ( saddleBrown, "saddleBrown" )
                            , ( sienna, "sienna" )
                            , ( brown, "brown" )
                            , ( maroon, "maroon" )
                            ]
                            cell
                        , Html.h4 [] [ Html.text "Greens" ]
                        , exampleList
                            [ ( darkOliveGreen, "darkOliveGreen" )
                            , ( olive, "olive" )
                            , ( oliveDrab, "oliveDrab" )
                            , ( yellowGreen, "yellowGreen" )
                            , ( limeGreen, "limeGreen" )
                            , ( lime, "lime" )
                            , ( lawnGreen, "lawnGreen" )
                            , ( chartreuse, "chartreuse" )
                            , ( greenYellow, "greenYellow" )
                            , ( springGreen, "springGreen" )
                            , ( mediumSpringGreen, "mediumSpringGreen" )
                            , ( lightGreen, "lightGreen" )
                            , ( paleGreen, "paleGreen" )
                            , ( darkSeaGreen, "darkSeaGreen" )
                            , ( mediumAquamarine, "mediumAquamarine" )
                            , ( mediumSeaGreen, "mediumSeaGreen" )
                            , ( seaGreen, "seaGreen" )
                            , ( forestGreen, "forestGreen" )
                            , ( green, "green" )
                            , ( darkGreen, "darkGreen" )
                            ]
                            cell
                        , Html.h4 [] [ Html.text "Cyans" ]
                        , exampleList
                            [ ( aqua, "aqua" )
                            , ( cyan, "cyan" )
                            , ( lightCyan, "lightCyan" )
                            , ( paleTurquoise, "paleTurquoise" )
                            , ( aquamarine, "aquamarine" )
                            , ( turquoise, "turquoise" )
                            , ( mediumTurquoise, "mediumTurquoise" )
                            , ( darkTurquoise, "darkTurquoise" )
                            , ( lightSeaGreen, "lightSeaGreen" )
                            , ( cadetBlue, "cadetBlue" )
                            , ( darkCyan, "darkCyan" )
                            , ( teal, "teal" )
                            ]
                            cell
                        , Html.h4 [] [ Html.text "Blues" ]
                        , exampleList
                            [ ( lightSteelBlue, "lightSteelBlue" )
                            , ( powderBlue, "powderBlue" )
                            , ( lightBlue, "lightBlue" )
                            , ( skyBlue, "skyBlue" )
                            , ( lightSkyBlue, "lightSkyBlue" )
                            , ( deepSkyBlue, "deepSkyBlue" )
                            , ( dodgerBlue, "dodgerBlue" )
                            , ( cornflowerBlue, "cornflowerBlue" )
                            , ( steelBlue, "steelBlue" )
                            , ( royalBlue, "royalBlue" )
                            , ( blue, "blue" )
                            , ( mediumBlue, "mediumBlue" )
                            , ( darkBlue, "darkBlue" )
                            , ( navy, "navy" )
                            , ( midnightBlue, "midnightBlue" )
                            ]
                            cell
                        , Html.h4 [] [ Html.text "Purples" ]
                        , exampleList
                            [ ( lavender, "lavender" )
                            , ( thistle, "thistle" )
                            , ( plum, "plum" )
                            , ( violet, "violet" )
                            , ( orchid, "orchid" )
                            , ( fuchsia, "fuchsia" )
                            , ( magenta, "magenta" )
                            , ( mediumOrchid, "mediumOrchid" )
                            , ( mediumPurple, "mediumPurple" )
                            , ( blueViolet, "blueViolet" )
                            , ( darkViolet, "darkViolet" )
                            , ( darkOrchid, "darkOrchid" )
                            , ( darkMagenta, "darkMagenta" )
                            , ( purple, "purple" )
                            , ( indigo, "indigo" )
                            , ( darkSlateBlue, "darkSlateBlue" )
                            , ( slateBlue, "slateBlue" )
                            , ( mediumSlateBlue, "mediumSlateBlue" )
                            ]
                            cell
                        , Html.h4 [] [ Html.text "Whites" ]
                        , exampleList
                            [ ( white, "white" )
                            , ( snow, "snow" )
                            , ( honeydew, "honeydew" )
                            , ( mintCream, "mintCream" )
                            , ( azure, "azure" )
                            , ( aliceBlue, "aliceBlue" )
                            , ( ghostWhite, "ghostWhite" )
                            , ( whiteSmoke, "whiteSmoke" )
                            , ( seashell, "seashell" )
                            , ( beige, "beige" )
                            , ( oldLace, "oldLace" )
                            , ( floralWhite, "floralWhite" )
                            , ( ivory, "ivory" )
                            , ( antiqueWhite, "antiqueWhite" )
                            , ( linen, "linen" )
                            , ( lavenderBlush, "lavenderBlush" )
                            , ( mistyRose, "mistyRose" )
                            ]
                            cell
                        , Html.h4 [] [ Html.text "Blacks and Grays" ]
                        , exampleList
                            [ ( gainsboro, "gainsboro" )
                            , ( lightGray, "lightGray" )
                            , ( silver, "silver" )
                            , ( darkGray, "darkGray" )
                            , ( gray, "gray" )
                            , ( dimGray, "dimGray" )
                            , ( lightSlateGray, "lightSlateGray" )
                            , ( slateGray, "slateGray" )
                            , ( darkSlateGray, "darkSlateGray" )
                            , ( black, "black" )
                            ]
                            cell
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


cell : ( Color, String ) -> Html msg
cell ( color, name ) =
    let
        rgbColor =
            Color.toRGBString color

        highContrastColor =
            Color.Generator.complementary color
                |> Color.Generator.adjustSaturation 100
                |> Color.Generator.invertLightnessFrom color
                |> Color.toRGBString
    in
    Html.div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "flex-start"
        , style "background-color" rgbColor
        , style "width" "200px"
        ]
        [ Html.span
            [ style "margin" "8px"
            , style "padding" "4px"
            , style "overflow" "scroll"
            , style "text-align" "center"
            , style "color" highContrastColor
            ]
            [ Html.div [] [ Html.text name ] ]
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

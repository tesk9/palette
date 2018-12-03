module PaletteExamples.X11 exposing (examples)

import Comparison
import ExampleHelpers as Example
import Html exposing (Html)
import Palette.X11 exposing (..)


examples : Html msg
examples =
    Example.subsection "X11"
        (Html.div []
            [ Html.h4 [] [ Html.text "Pinks" ]
            , Example.list
                [ ( pink, "pink" )
                , ( lightPink, "lightPink" )
                , ( hotPink, "hotPink" )
                , ( deepPink, "deepPink" )
                , ( paleVioletRed, "paleVioletRed" )
                , ( mediumVioletRed, "mediumVioletRed" )
                ]
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Reds" ]
            , Example.list
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
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Orange-Reds" ]
            , Example.list
                [ ( orangeRed, "orangeRed" )
                , ( tomato, "tomato" )
                , ( coral, "coral" )
                , ( darkOrange, "darkOrange" )
                , ( orange, "orange" )
                ]
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Yellows" ]
            , Example.list
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
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Browns" ]
            , Example.list
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
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Greens" ]
            , Example.list
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
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Cyans" ]
            , Example.list
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
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Blues" ]
            , Example.list
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
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Purples" ]
            , Example.list
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
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Whites" ]
            , Example.list
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
                Comparison.viewWithName
            , Html.h4 [] [ Html.text "Blacks and Grays" ]
            , Example.list
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
                Comparison.viewWithName
            ]
        )

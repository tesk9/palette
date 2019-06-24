module Palette.X11 exposing
    ( pink, lightPink, hotPink, deepPink, paleVioletRed, mediumVioletRed
    , lightSalmon, salmon, darkSalmon, lightCoral, indianRed, crimson, firebrick, darkRed, red
    , orangeRed, tomato, coral, darkOrange, orange
    , yellow, lightYellow, lemonChiffon, lightGoldenrodYellow, papayaWhip, moccasin, peachPuff, paleGoldenrod, khaki, darkKhaki, gold
    , cornsilk, blanchedAlmond, bisque, navajoWhite, wheat, burlywood, tan, rosyBrown, sandyBrown, goldenrod, darkGoldenrod, peru, chocolate, saddleBrown, sienna, brown, maroon
    , darkOliveGreen, olive, oliveDrab, yellowGreen, limeGreen, lime, lawnGreen, chartreuse, greenYellow, springGreen, mediumSpringGreen, lightGreen, paleGreen, darkSeaGreen, mediumAquamarine, mediumSeaGreen, seaGreen, forestGreen, green, darkGreen
    , aqua, cyan, lightCyan, paleTurquoise, aquamarine, turquoise, mediumTurquoise, darkTurquoise, lightSeaGreen, cadetBlue, darkCyan, teal
    , lightSteelBlue, powderBlue, lightBlue, skyBlue, lightSkyBlue, deepSkyBlue, dodgerBlue, cornflowerBlue, steelBlue, royalBlue, blue, mediumBlue, darkBlue, navy, midnightBlue
    , lavender, thistle, plum, violet, orchid, fuchsia, magenta, mediumOrchid, mediumPurple, blueViolet, darkViolet, darkOrchid, darkMagenta, purple, indigo, darkSlateBlue, slateBlue, mediumSlateBlue
    , white, snow, honeydew, mintCream, azure, aliceBlue, ghostWhite, whiteSmoke, seashell, beige, oldLace, floralWhite, ivory, antiqueWhite, linen, lavenderBlush, mistyRose
    , gainsboro, lightGray, silver, darkGray, gray, dimGray, lightSlateGray, slateGray, darkSlateGray, black
    )

{-| [X11 colours](https://en.wikipedia.org/wiki/Web_colours#X11_colour_names).
![](https://user-images.githubusercontent.com/8811312/51518957-62d66200-1dd4-11e9-86c7-ef90e7b06811.png)
Play with this example on [ellie](https://ellie-app.com/4wBgLmNppNHa1).


## Pinks

@docs pink, lightPink, hotPink, deepPink, paleVioletRed, mediumVioletRed


## Reds

@docs lightSalmon, salmon, darkSalmon, lightCoral, indianRed, crimson, firebrick, darkRed, red


## Orange-Reds

@docs orangeRed, tomato, coral, darkOrange, orange


## Yellows

@docs yellow, lightYellow, lemonChiffon, lightGoldenrodYellow, papayaWhip, moccasin, peachPuff, paleGoldenrod, khaki, darkKhaki, gold


## Browns

@docs cornsilk, blanchedAlmond, bisque, navajoWhite, wheat, burlywood, tan, rosyBrown, sandyBrown, goldenrod, darkGoldenrod, peru, chocolate, saddleBrown, sienna, brown, maroon


## Greens

@docs darkOliveGreen, olive, oliveDrab, yellowGreen, limeGreen, lime, lawnGreen, chartreuse, greenYellow, springGreen, mediumSpringGreen, lightGreen, paleGreen, darkSeaGreen, mediumAquamarine, mediumSeaGreen, seaGreen, forestGreen, green, darkGreen


## Cyans

@docs aqua, cyan, lightCyan, paleTurquoise, aquamarine, turquoise, mediumTurquoise, darkTurquoise, lightSeaGreen, cadetBlue, darkCyan, teal


## Blues

@docs lightSteelBlue, powderBlue, lightBlue, skyBlue, lightSkyBlue, deepSkyBlue, dodgerBlue, cornflowerBlue, steelBlue, royalBlue, blue, mediumBlue, darkBlue, navy, midnightBlue


## Purples

@docs lavender, thistle, plum, violet, orchid, fuchsia, magenta, mediumOrchid, mediumPurple, blueViolet, darkViolet, darkOrchid, darkMagenta, purple, indigo, darkSlateBlue, slateBlue, mediumSlateBlue


## Whites

@docs white, snow, honeydew, mintCream, azure, aliceBlue, ghostWhite, whiteSmoke, seashell, beige, oldLace, floralWhite, ivory, antiqueWhite, linen, lavenderBlush, mistyRose


## Blacks and Grays

@docs gainsboro, lightGray, silver, darkGray, gray, dimGray, lightSlateGray, slateGray, darkSlateGray, black

-}

import Colour exposing (Colour)



--PINKS


{-| -}
pink : Colour
pink =
    Colour.fromRGB ( 255, 192, 203 )


{-| -}
lightPink : Colour
lightPink =
    Colour.fromRGB ( 255, 182, 193 )


{-| -}
hotPink : Colour
hotPink =
    Colour.fromRGB ( 255, 105, 180 )


{-| -}
deepPink : Colour
deepPink =
    Colour.fromRGB ( 255, 20, 147 )


{-| -}
paleVioletRed : Colour
paleVioletRed =
    Colour.fromRGB ( 219, 112, 147 )


{-| -}
mediumVioletRed : Colour
mediumVioletRed =
    Colour.fromRGB ( 199, 21, 133 )



-- REDS


{-| -}
lightSalmon : Colour
lightSalmon =
    Colour.fromRGB ( 255, 160, 122 )


{-| -}
salmon : Colour
salmon =
    Colour.fromRGB ( 250, 128, 114 )


{-| -}
darkSalmon : Colour
darkSalmon =
    Colour.fromRGB ( 233, 150, 122 )


{-| -}
lightCoral : Colour
lightCoral =
    Colour.fromRGB ( 240, 128, 128 )


{-| -}
indianRed : Colour
indianRed =
    Colour.fromRGB ( 205, 92, 92 )


{-| -}
crimson : Colour
crimson =
    Colour.fromRGB ( 220, 20, 60 )


{-| -}
firebrick : Colour
firebrick =
    Colour.fromRGB ( 178, 34, 34 )


{-| -}
darkRed : Colour
darkRed =
    Colour.fromRGB ( 139, 0, 0 )


{-| -}
red : Colour
red =
    Colour.fromRGB ( 255, 0, 0 )



-- ORANGE REDS


{-| -}
orangeRed : Colour
orangeRed =
    Colour.fromRGB ( 255, 69, 0 )


{-| -}
tomato : Colour
tomato =
    Colour.fromRGB ( 255, 99, 71 )


{-| -}
coral : Colour
coral =
    Colour.fromRGB ( 255, 127, 80 )


{-| -}
darkOrange : Colour
darkOrange =
    Colour.fromRGB ( 255, 140, 0 )


{-| -}
orange : Colour
orange =
    Colour.fromRGB ( 255, 165, 0 )



-- YELLOWS


{-| -}
yellow : Colour
yellow =
    Colour.fromRGB ( 255, 255, 0 )


{-| -}
lightYellow : Colour
lightYellow =
    Colour.fromRGB ( 255, 255, 224 )


{-| -}
lemonChiffon : Colour
lemonChiffon =
    Colour.fromRGB ( 255, 250, 205 )


{-| -}
lightGoldenrodYellow : Colour
lightGoldenrodYellow =
    Colour.fromRGB ( 250, 250, 210 )


{-| -}
papayaWhip : Colour
papayaWhip =
    Colour.fromRGB ( 255, 239, 213 )


{-| -}
moccasin : Colour
moccasin =
    Colour.fromRGB ( 255, 228, 181 )


{-| -}
peachPuff : Colour
peachPuff =
    Colour.fromRGB ( 255, 218, 185 )


{-| -}
paleGoldenrod : Colour
paleGoldenrod =
    Colour.fromRGB ( 238, 232, 170 )


{-| -}
khaki : Colour
khaki =
    Colour.fromRGB ( 240, 230, 140 )


{-| -}
darkKhaki : Colour
darkKhaki =
    Colour.fromRGB ( 189, 183, 107 )


{-| -}
gold : Colour
gold =
    Colour.fromRGB ( 255, 215, 0 )



-- BROWNS


{-| -}
cornsilk : Colour
cornsilk =
    Colour.fromRGB ( 255, 248, 220 )


{-| -}
blanchedAlmond : Colour
blanchedAlmond =
    Colour.fromRGB ( 255, 235, 205 )


{-| -}
bisque : Colour
bisque =
    Colour.fromRGB ( 255, 228, 196 )


{-| -}
navajoWhite : Colour
navajoWhite =
    Colour.fromRGB ( 255, 222, 173 )


{-| -}
wheat : Colour
wheat =
    Colour.fromRGB ( 245, 222, 179 )


{-| -}
burlywood : Colour
burlywood =
    Colour.fromRGB ( 222, 184, 135 )


{-| -}
tan : Colour
tan =
    Colour.fromRGB ( 210, 180, 140 )


{-| -}
rosyBrown : Colour
rosyBrown =
    Colour.fromRGB ( 188, 143, 143 )


{-| -}
sandyBrown : Colour
sandyBrown =
    Colour.fromRGB ( 244, 164, 96 )


{-| -}
goldenrod : Colour
goldenrod =
    Colour.fromRGB ( 218, 165, 32 )


{-| -}
darkGoldenrod : Colour
darkGoldenrod =
    Colour.fromRGB ( 184, 134, 11 )


{-| -}
peru : Colour
peru =
    Colour.fromRGB ( 205, 133, 63 )


{-| -}
chocolate : Colour
chocolate =
    Colour.fromRGB ( 210, 105, 30 )


{-| -}
saddleBrown : Colour
saddleBrown =
    Colour.fromRGB ( 139, 69, 19 )


{-| -}
sienna : Colour
sienna =
    Colour.fromRGB ( 160, 82, 45 )


{-| -}
brown : Colour
brown =
    Colour.fromRGB ( 165, 42, 42 )


{-| -}
maroon : Colour
maroon =
    Colour.fromRGB ( 128, 0, 0 )



-- GREENS


{-| -}
darkOliveGreen : Colour
darkOliveGreen =
    Colour.fromRGB ( 85, 107, 47 )


{-| -}
olive : Colour
olive =
    Colour.fromRGB ( 128, 128, 0 )


{-| -}
oliveDrab : Colour
oliveDrab =
    Colour.fromRGB ( 107, 142, 35 )


{-| -}
yellowGreen : Colour
yellowGreen =
    Colour.fromRGB ( 154, 205, 50 )


{-| -}
limeGreen : Colour
limeGreen =
    Colour.fromRGB ( 50, 205, 50 )


{-| -}
lime : Colour
lime =
    Colour.fromRGB ( 0, 255, 0 )


{-| -}
lawnGreen : Colour
lawnGreen =
    Colour.fromRGB ( 124, 252, 0 )


{-| -}
chartreuse : Colour
chartreuse =
    Colour.fromRGB ( 127, 255, 0 )


{-| -}
greenYellow : Colour
greenYellow =
    Colour.fromRGB ( 173, 255, 47 )


{-| -}
springGreen : Colour
springGreen =
    Colour.fromRGB ( 0, 255, 127 )


{-| -}
mediumSpringGreen : Colour
mediumSpringGreen =
    Colour.fromRGB ( 0, 250, 154 )


{-| -}
lightGreen : Colour
lightGreen =
    Colour.fromRGB ( 144, 238, 144 )


{-| -}
paleGreen : Colour
paleGreen =
    Colour.fromRGB ( 152, 251, 152 )


{-| -}
darkSeaGreen : Colour
darkSeaGreen =
    Colour.fromRGB ( 143, 188, 143 )


{-| -}
mediumAquamarine : Colour
mediumAquamarine =
    Colour.fromRGB ( 102, 205, 170 )


{-| -}
mediumSeaGreen : Colour
mediumSeaGreen =
    Colour.fromRGB ( 60, 179, 113 )


{-| -}
seaGreen : Colour
seaGreen =
    Colour.fromRGB ( 46, 139, 87 )


{-| -}
forestGreen : Colour
forestGreen =
    Colour.fromRGB ( 34, 139, 34 )


{-| -}
green : Colour
green =
    Colour.fromRGB ( 0, 128, 0 )


{-| -}
darkGreen : Colour
darkGreen =
    Colour.fromRGB ( 0, 100, 0 )



-- CYANS


{-| -}
aqua : Colour
aqua =
    Colour.fromRGB ( 0, 255, 255 )


{-| -}
cyan : Colour
cyan =
    Colour.fromRGB ( 0, 255, 255 )


{-| -}
lightCyan : Colour
lightCyan =
    Colour.fromRGB ( 224, 255, 255 )


{-| -}
paleTurquoise : Colour
paleTurquoise =
    Colour.fromRGB ( 175, 238, 238 )


{-| -}
aquamarine : Colour
aquamarine =
    Colour.fromRGB ( 127, 255, 212 )


{-| -}
turquoise : Colour
turquoise =
    Colour.fromRGB ( 64, 224, 208 )


{-| -}
mediumTurquoise : Colour
mediumTurquoise =
    Colour.fromRGB ( 72, 209, 204 )


{-| -}
darkTurquoise : Colour
darkTurquoise =
    Colour.fromRGB ( 0, 206, 209 )


{-| -}
lightSeaGreen : Colour
lightSeaGreen =
    Colour.fromRGB ( 32, 178, 170 )


{-| -}
cadetBlue : Colour
cadetBlue =
    Colour.fromRGB ( 95, 158, 160 )


{-| -}
darkCyan : Colour
darkCyan =
    Colour.fromRGB ( 0, 139, 139 )


{-| -}
teal : Colour
teal =
    Colour.fromRGB ( 0, 128, 128 )



-- BLUES


{-| -}
lightSteelBlue : Colour
lightSteelBlue =
    Colour.fromRGB ( 176, 196, 222 )


{-| -}
powderBlue : Colour
powderBlue =
    Colour.fromRGB ( 176, 224, 230 )


{-| -}
lightBlue : Colour
lightBlue =
    Colour.fromRGB ( 173, 216, 230 )


{-| -}
skyBlue : Colour
skyBlue =
    Colour.fromRGB ( 135, 206, 235 )


{-| -}
lightSkyBlue : Colour
lightSkyBlue =
    Colour.fromRGB ( 135, 206, 250 )


{-| -}
deepSkyBlue : Colour
deepSkyBlue =
    Colour.fromRGB ( 0, 191, 255 )


{-| -}
dodgerBlue : Colour
dodgerBlue =
    Colour.fromRGB ( 30, 144, 255 )


{-| -}
cornflowerBlue : Colour
cornflowerBlue =
    Colour.fromRGB ( 100, 149, 237 )


{-| -}
steelBlue : Colour
steelBlue =
    Colour.fromRGB ( 70, 130, 180 )


{-| -}
royalBlue : Colour
royalBlue =
    Colour.fromRGB ( 65, 105, 225 )


{-| -}
blue : Colour
blue =
    Colour.fromRGB ( 0, 0, 255 )


{-| -}
mediumBlue : Colour
mediumBlue =
    Colour.fromRGB ( 0, 0, 205 )


{-| -}
darkBlue : Colour
darkBlue =
    Colour.fromRGB ( 0, 0, 139 )


{-| -}
navy : Colour
navy =
    Colour.fromRGB ( 0, 0, 128 )


{-| -}
midnightBlue : Colour
midnightBlue =
    Colour.fromRGB ( 25, 25, 112 )



-- PURPLES


{-| -}
lavender : Colour
lavender =
    Colour.fromRGB ( 230, 230, 250 )


{-| -}
thistle : Colour
thistle =
    Colour.fromRGB ( 216, 191, 216 )


{-| -}
plum : Colour
plum =
    Colour.fromRGB ( 221, 160, 221 )


{-| -}
violet : Colour
violet =
    Colour.fromRGB ( 238, 130, 238 )


{-| -}
orchid : Colour
orchid =
    Colour.fromRGB ( 218, 112, 214 )


{-| -}
fuchsia : Colour
fuchsia =
    Colour.fromRGB ( 255, 0, 255 )


{-| -}
magenta : Colour
magenta =
    Colour.fromRGB ( 255, 0, 255 )


{-| -}
mediumOrchid : Colour
mediumOrchid =
    Colour.fromRGB ( 186, 85, 211 )


{-| -}
mediumPurple : Colour
mediumPurple =
    Colour.fromRGB ( 147, 112, 219 )


{-| -}
blueViolet : Colour
blueViolet =
    Colour.fromRGB ( 138, 43, 226 )


{-| -}
darkViolet : Colour
darkViolet =
    Colour.fromRGB ( 148, 0, 211 )


{-| -}
darkOrchid : Colour
darkOrchid =
    Colour.fromRGB ( 153, 50, 204 )


{-| -}
darkMagenta : Colour
darkMagenta =
    Colour.fromRGB ( 139, 0, 139 )


{-| -}
purple : Colour
purple =
    Colour.fromRGB ( 128, 0, 128 )


{-| -}
indigo : Colour
indigo =
    Colour.fromRGB ( 75, 0, 130 )


{-| -}
darkSlateBlue : Colour
darkSlateBlue =
    Colour.fromRGB ( 72, 61, 139 )


{-| -}
slateBlue : Colour
slateBlue =
    Colour.fromRGB ( 106, 90, 205 )


{-| -}
mediumSlateBlue : Colour
mediumSlateBlue =
    Colour.fromRGB ( 123, 104, 238 )



-- WHITES


{-| -}
white : Colour
white =
    Colour.fromRGB ( 255, 255, 255 )


{-| -}
snow : Colour
snow =
    Colour.fromRGB ( 255, 250, 250 )


{-| -}
honeydew : Colour
honeydew =
    Colour.fromRGB ( 240, 255, 240 )


{-| -}
mintCream : Colour
mintCream =
    Colour.fromRGB ( 245, 255, 250 )


{-| -}
azure : Colour
azure =
    Colour.fromRGB ( 240, 255, 255 )


{-| -}
aliceBlue : Colour
aliceBlue =
    Colour.fromRGB ( 240, 248, 255 )


{-| -}
ghostWhite : Colour
ghostWhite =
    Colour.fromRGB ( 248, 248, 255 )


{-| -}
whiteSmoke : Colour
whiteSmoke =
    Colour.fromRGB ( 245, 245, 245 )


{-| -}
seashell : Colour
seashell =
    Colour.fromRGB ( 255, 245, 238 )


{-| -}
beige : Colour
beige =
    Colour.fromRGB ( 245, 245, 220 )


{-| -}
oldLace : Colour
oldLace =
    Colour.fromRGB ( 253, 245, 230 )


{-| -}
floralWhite : Colour
floralWhite =
    Colour.fromRGB ( 255, 250, 240 )


{-| -}
ivory : Colour
ivory =
    Colour.fromRGB ( 255, 255, 240 )


{-| -}
antiqueWhite : Colour
antiqueWhite =
    Colour.fromRGB ( 250, 235, 215 )


{-| -}
linen : Colour
linen =
    Colour.fromRGB ( 250, 240, 230 )


{-| -}
lavenderBlush : Colour
lavenderBlush =
    Colour.fromRGB ( 255, 240, 245 )


{-| -}
mistyRose : Colour
mistyRose =
    Colour.fromRGB ( 255, 228, 225 )



-- GRAYS AND BLACKS


{-| -}
gainsboro : Colour
gainsboro =
    Colour.fromRGB ( 220, 220, 220 )


{-| -}
lightGray : Colour
lightGray =
    Colour.fromRGB ( 211, 211, 211 )


{-| -}
silver : Colour
silver =
    Colour.fromRGB ( 192, 192, 192 )


{-| -}
darkGray : Colour
darkGray =
    Colour.fromRGB ( 169, 169, 169 )


{-| -}
gray : Colour
gray =
    Colour.fromRGB ( 128, 128, 128 )


{-| -}
dimGray : Colour
dimGray =
    Colour.fromRGB ( 105, 105, 105 )


{-| -}
lightSlateGray : Colour
lightSlateGray =
    Colour.fromRGB ( 119, 136, 153 )


{-| -}
slateGray : Colour
slateGray =
    Colour.fromRGB ( 112, 128, 144 )


{-| -}
darkSlateGray : Colour
darkSlateGray =
    Colour.fromRGB ( 47, 79, 79 )


{-| -}
black : Colour
black =
    Colour.fromRGB ( 0, 0, 0 )

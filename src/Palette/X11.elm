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

{-| [X11 colors](https://en.wikipedia.org/wiki/Web_colors#X11_color_names).
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

import Color exposing (Color)



--PINKS


{-| -}
pink : Color
pink =
    Color.fromRGB ( 255, 192, 203 )


{-| -}
lightPink : Color
lightPink =
    Color.fromRGB ( 255, 182, 193 )


{-| -}
hotPink : Color
hotPink =
    Color.fromRGB ( 255, 105, 180 )


{-| -}
deepPink : Color
deepPink =
    Color.fromRGB ( 255, 20, 147 )


{-| -}
paleVioletRed : Color
paleVioletRed =
    Color.fromRGB ( 219, 112, 147 )


{-| -}
mediumVioletRed : Color
mediumVioletRed =
    Color.fromRGB ( 199, 21, 133 )



-- REDS


{-| -}
lightSalmon : Color
lightSalmon =
    Color.fromRGB ( 255, 160, 122 )


{-| -}
salmon : Color
salmon =
    Color.fromRGB ( 250, 128, 114 )


{-| -}
darkSalmon : Color
darkSalmon =
    Color.fromRGB ( 233, 150, 122 )


{-| -}
lightCoral : Color
lightCoral =
    Color.fromRGB ( 240, 128, 128 )


{-| -}
indianRed : Color
indianRed =
    Color.fromRGB ( 205, 92, 92 )


{-| -}
crimson : Color
crimson =
    Color.fromRGB ( 220, 20, 60 )


{-| -}
firebrick : Color
firebrick =
    Color.fromRGB ( 178, 34, 34 )


{-| -}
darkRed : Color
darkRed =
    Color.fromRGB ( 139, 0, 0 )


{-| -}
red : Color
red =
    Color.fromRGB ( 255, 0, 0 )



-- ORANGE REDS


{-| -}
orangeRed : Color
orangeRed =
    Color.fromRGB ( 255, 69, 0 )


{-| -}
tomato : Color
tomato =
    Color.fromRGB ( 255, 99, 71 )


{-| -}
coral : Color
coral =
    Color.fromRGB ( 255, 127, 80 )


{-| -}
darkOrange : Color
darkOrange =
    Color.fromRGB ( 255, 140, 0 )


{-| -}
orange : Color
orange =
    Color.fromRGB ( 255, 165, 0 )



-- YELLOWS


{-| -}
yellow : Color
yellow =
    Color.fromRGB ( 255, 255, 0 )


{-| -}
lightYellow : Color
lightYellow =
    Color.fromRGB ( 255, 255, 224 )


{-| -}
lemonChiffon : Color
lemonChiffon =
    Color.fromRGB ( 255, 250, 205 )


{-| -}
lightGoldenrodYellow : Color
lightGoldenrodYellow =
    Color.fromRGB ( 250, 250, 210 )


{-| -}
papayaWhip : Color
papayaWhip =
    Color.fromRGB ( 255, 239, 213 )


{-| -}
moccasin : Color
moccasin =
    Color.fromRGB ( 255, 228, 181 )


{-| -}
peachPuff : Color
peachPuff =
    Color.fromRGB ( 255, 218, 185 )


{-| -}
paleGoldenrod : Color
paleGoldenrod =
    Color.fromRGB ( 238, 232, 170 )


{-| -}
khaki : Color
khaki =
    Color.fromRGB ( 240, 230, 140 )


{-| -}
darkKhaki : Color
darkKhaki =
    Color.fromRGB ( 189, 183, 107 )


{-| -}
gold : Color
gold =
    Color.fromRGB ( 255, 215, 0 )



-- BROWNS


{-| -}
cornsilk : Color
cornsilk =
    Color.fromRGB ( 255, 248, 220 )


{-| -}
blanchedAlmond : Color
blanchedAlmond =
    Color.fromRGB ( 255, 235, 205 )


{-| -}
bisque : Color
bisque =
    Color.fromRGB ( 255, 228, 196 )


{-| -}
navajoWhite : Color
navajoWhite =
    Color.fromRGB ( 255, 222, 173 )


{-| -}
wheat : Color
wheat =
    Color.fromRGB ( 245, 222, 179 )


{-| -}
burlywood : Color
burlywood =
    Color.fromRGB ( 222, 184, 135 )


{-| -}
tan : Color
tan =
    Color.fromRGB ( 210, 180, 140 )


{-| -}
rosyBrown : Color
rosyBrown =
    Color.fromRGB ( 188, 143, 143 )


{-| -}
sandyBrown : Color
sandyBrown =
    Color.fromRGB ( 244, 164, 96 )


{-| -}
goldenrod : Color
goldenrod =
    Color.fromRGB ( 218, 165, 32 )


{-| -}
darkGoldenrod : Color
darkGoldenrod =
    Color.fromRGB ( 184, 134, 11 )


{-| -}
peru : Color
peru =
    Color.fromRGB ( 205, 133, 63 )


{-| -}
chocolate : Color
chocolate =
    Color.fromRGB ( 210, 105, 30 )


{-| -}
saddleBrown : Color
saddleBrown =
    Color.fromRGB ( 139, 69, 19 )


{-| -}
sienna : Color
sienna =
    Color.fromRGB ( 160, 82, 45 )


{-| -}
brown : Color
brown =
    Color.fromRGB ( 165, 42, 42 )


{-| -}
maroon : Color
maroon =
    Color.fromRGB ( 128, 0, 0 )



-- GREENS


{-| -}
darkOliveGreen : Color
darkOliveGreen =
    Color.fromRGB ( 85, 107, 47 )


{-| -}
olive : Color
olive =
    Color.fromRGB ( 128, 128, 0 )


{-| -}
oliveDrab : Color
oliveDrab =
    Color.fromRGB ( 107, 142, 35 )


{-| -}
yellowGreen : Color
yellowGreen =
    Color.fromRGB ( 154, 205, 50 )


{-| -}
limeGreen : Color
limeGreen =
    Color.fromRGB ( 50, 205, 50 )


{-| -}
lime : Color
lime =
    Color.fromRGB ( 0, 255, 0 )


{-| -}
lawnGreen : Color
lawnGreen =
    Color.fromRGB ( 124, 252, 0 )


{-| -}
chartreuse : Color
chartreuse =
    Color.fromRGB ( 127, 255, 0 )


{-| -}
greenYellow : Color
greenYellow =
    Color.fromRGB ( 173, 255, 47 )


{-| -}
springGreen : Color
springGreen =
    Color.fromRGB ( 0, 255, 127 )


{-| -}
mediumSpringGreen : Color
mediumSpringGreen =
    Color.fromRGB ( 0, 250, 154 )


{-| -}
lightGreen : Color
lightGreen =
    Color.fromRGB ( 144, 238, 144 )


{-| -}
paleGreen : Color
paleGreen =
    Color.fromRGB ( 152, 251, 152 )


{-| -}
darkSeaGreen : Color
darkSeaGreen =
    Color.fromRGB ( 143, 188, 143 )


{-| -}
mediumAquamarine : Color
mediumAquamarine =
    Color.fromRGB ( 102, 205, 170 )


{-| -}
mediumSeaGreen : Color
mediumSeaGreen =
    Color.fromRGB ( 60, 179, 113 )


{-| -}
seaGreen : Color
seaGreen =
    Color.fromRGB ( 46, 139, 87 )


{-| -}
forestGreen : Color
forestGreen =
    Color.fromRGB ( 34, 139, 34 )


{-| -}
green : Color
green =
    Color.fromRGB ( 0, 128, 0 )


{-| -}
darkGreen : Color
darkGreen =
    Color.fromRGB ( 0, 100, 0 )



-- CYANS


{-| -}
aqua : Color
aqua =
    Color.fromRGB ( 0, 255, 255 )


{-| -}
cyan : Color
cyan =
    Color.fromRGB ( 0, 255, 255 )


{-| -}
lightCyan : Color
lightCyan =
    Color.fromRGB ( 224, 255, 255 )


{-| -}
paleTurquoise : Color
paleTurquoise =
    Color.fromRGB ( 175, 238, 238 )


{-| -}
aquamarine : Color
aquamarine =
    Color.fromRGB ( 127, 255, 212 )


{-| -}
turquoise : Color
turquoise =
    Color.fromRGB ( 64, 224, 208 )


{-| -}
mediumTurquoise : Color
mediumTurquoise =
    Color.fromRGB ( 72, 209, 204 )


{-| -}
darkTurquoise : Color
darkTurquoise =
    Color.fromRGB ( 0, 206, 209 )


{-| -}
lightSeaGreen : Color
lightSeaGreen =
    Color.fromRGB ( 32, 178, 170 )


{-| -}
cadetBlue : Color
cadetBlue =
    Color.fromRGB ( 95, 158, 160 )


{-| -}
darkCyan : Color
darkCyan =
    Color.fromRGB ( 0, 139, 139 )


{-| -}
teal : Color
teal =
    Color.fromRGB ( 0, 128, 128 )



-- BLUES


{-| -}
lightSteelBlue : Color
lightSteelBlue =
    Color.fromRGB ( 176, 196, 222 )


{-| -}
powderBlue : Color
powderBlue =
    Color.fromRGB ( 176, 224, 230 )


{-| -}
lightBlue : Color
lightBlue =
    Color.fromRGB ( 173, 216, 230 )


{-| -}
skyBlue : Color
skyBlue =
    Color.fromRGB ( 135, 206, 235 )


{-| -}
lightSkyBlue : Color
lightSkyBlue =
    Color.fromRGB ( 135, 206, 250 )


{-| -}
deepSkyBlue : Color
deepSkyBlue =
    Color.fromRGB ( 0, 191, 255 )


{-| -}
dodgerBlue : Color
dodgerBlue =
    Color.fromRGB ( 30, 144, 255 )


{-| -}
cornflowerBlue : Color
cornflowerBlue =
    Color.fromRGB ( 100, 149, 237 )


{-| -}
steelBlue : Color
steelBlue =
    Color.fromRGB ( 70, 130, 180 )


{-| -}
royalBlue : Color
royalBlue =
    Color.fromRGB ( 65, 105, 225 )


{-| -}
blue : Color
blue =
    Color.fromRGB ( 0, 0, 255 )


{-| -}
mediumBlue : Color
mediumBlue =
    Color.fromRGB ( 0, 0, 205 )


{-| -}
darkBlue : Color
darkBlue =
    Color.fromRGB ( 0, 0, 139 )


{-| -}
navy : Color
navy =
    Color.fromRGB ( 0, 0, 128 )


{-| -}
midnightBlue : Color
midnightBlue =
    Color.fromRGB ( 25, 25, 112 )



-- PURPLES


{-| -}
lavender : Color
lavender =
    Color.fromRGB ( 230, 230, 250 )


{-| -}
thistle : Color
thistle =
    Color.fromRGB ( 216, 191, 216 )


{-| -}
plum : Color
plum =
    Color.fromRGB ( 221, 160, 221 )


{-| -}
violet : Color
violet =
    Color.fromRGB ( 238, 130, 238 )


{-| -}
orchid : Color
orchid =
    Color.fromRGB ( 218, 112, 214 )


{-| -}
fuchsia : Color
fuchsia =
    Color.fromRGB ( 255, 0, 255 )


{-| -}
magenta : Color
magenta =
    Color.fromRGB ( 255, 0, 255 )


{-| -}
mediumOrchid : Color
mediumOrchid =
    Color.fromRGB ( 186, 85, 211 )


{-| -}
mediumPurple : Color
mediumPurple =
    Color.fromRGB ( 147, 112, 219 )


{-| -}
blueViolet : Color
blueViolet =
    Color.fromRGB ( 138, 43, 226 )


{-| -}
darkViolet : Color
darkViolet =
    Color.fromRGB ( 148, 0, 211 )


{-| -}
darkOrchid : Color
darkOrchid =
    Color.fromRGB ( 153, 50, 204 )


{-| -}
darkMagenta : Color
darkMagenta =
    Color.fromRGB ( 139, 0, 139 )


{-| -}
purple : Color
purple =
    Color.fromRGB ( 128, 0, 128 )


{-| -}
indigo : Color
indigo =
    Color.fromRGB ( 75, 0, 130 )


{-| -}
darkSlateBlue : Color
darkSlateBlue =
    Color.fromRGB ( 72, 61, 139 )


{-| -}
slateBlue : Color
slateBlue =
    Color.fromRGB ( 106, 90, 205 )


{-| -}
mediumSlateBlue : Color
mediumSlateBlue =
    Color.fromRGB ( 123, 104, 238 )



-- WHITES


{-| -}
white : Color
white =
    Color.fromRGB ( 255, 255, 255 )


{-| -}
snow : Color
snow =
    Color.fromRGB ( 255, 250, 250 )


{-| -}
honeydew : Color
honeydew =
    Color.fromRGB ( 240, 255, 240 )


{-| -}
mintCream : Color
mintCream =
    Color.fromRGB ( 245, 255, 250 )


{-| -}
azure : Color
azure =
    Color.fromRGB ( 240, 255, 255 )


{-| -}
aliceBlue : Color
aliceBlue =
    Color.fromRGB ( 240, 248, 255 )


{-| -}
ghostWhite : Color
ghostWhite =
    Color.fromRGB ( 248, 248, 255 )


{-| -}
whiteSmoke : Color
whiteSmoke =
    Color.fromRGB ( 245, 245, 245 )


{-| -}
seashell : Color
seashell =
    Color.fromRGB ( 255, 245, 238 )


{-| -}
beige : Color
beige =
    Color.fromRGB ( 245, 245, 220 )


{-| -}
oldLace : Color
oldLace =
    Color.fromRGB ( 253, 245, 230 )


{-| -}
floralWhite : Color
floralWhite =
    Color.fromRGB ( 255, 250, 240 )


{-| -}
ivory : Color
ivory =
    Color.fromRGB ( 255, 255, 240 )


{-| -}
antiqueWhite : Color
antiqueWhite =
    Color.fromRGB ( 250, 235, 215 )


{-| -}
linen : Color
linen =
    Color.fromRGB ( 250, 240, 230 )


{-| -}
lavenderBlush : Color
lavenderBlush =
    Color.fromRGB ( 255, 240, 245 )


{-| -}
mistyRose : Color
mistyRose =
    Color.fromRGB ( 255, 228, 225 )



-- GRAYS AND BLACKS


{-| -}
gainsboro : Color
gainsboro =
    Color.fromRGB ( 220, 220, 220 )


{-| -}
lightGray : Color
lightGray =
    Color.fromRGB ( 211, 211, 211 )


{-| -}
silver : Color
silver =
    Color.fromRGB ( 192, 192, 192 )


{-| -}
darkGray : Color
darkGray =
    Color.fromRGB ( 169, 169, 169 )


{-| -}
gray : Color
gray =
    Color.fromRGB ( 128, 128, 128 )


{-| -}
dimGray : Color
dimGray =
    Color.fromRGB ( 105, 105, 105 )


{-| -}
lightSlateGray : Color
lightSlateGray =
    Color.fromRGB ( 119, 136, 153 )


{-| -}
slateGray : Color
slateGray =
    Color.fromRGB ( 112, 128, 144 )


{-| -}
darkSlateGray : Color
darkSlateGray =
    Color.fromRGB ( 47, 79, 79 )


{-| -}
black : Color
black =
    Color.fromRGB ( 0, 0, 0 )

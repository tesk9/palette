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

import OpaqueColor exposing (OpaqueColor)



--PINKS


{-| -}
pink : OpaqueColor
pink =
    OpaqueColor.fromRGB ( 255, 192, 203 )


{-| -}
lightPink : OpaqueColor
lightPink =
    OpaqueColor.fromRGB ( 255, 182, 193 )


{-| -}
hotPink : OpaqueColor
hotPink =
    OpaqueColor.fromRGB ( 255, 105, 180 )


{-| -}
deepPink : OpaqueColor
deepPink =
    OpaqueColor.fromRGB ( 255, 20, 147 )


{-| -}
paleVioletRed : OpaqueColor
paleVioletRed =
    OpaqueColor.fromRGB ( 219, 112, 147 )


{-| -}
mediumVioletRed : OpaqueColor
mediumVioletRed =
    OpaqueColor.fromRGB ( 199, 21, 133 )



-- REDS


{-| -}
lightSalmon : OpaqueColor
lightSalmon =
    OpaqueColor.fromRGB ( 255, 160, 122 )


{-| -}
salmon : OpaqueColor
salmon =
    OpaqueColor.fromRGB ( 250, 128, 114 )


{-| -}
darkSalmon : OpaqueColor
darkSalmon =
    OpaqueColor.fromRGB ( 233, 150, 122 )


{-| -}
lightCoral : OpaqueColor
lightCoral =
    OpaqueColor.fromRGB ( 240, 128, 128 )


{-| -}
indianRed : OpaqueColor
indianRed =
    OpaqueColor.fromRGB ( 205, 92, 92 )


{-| -}
crimson : OpaqueColor
crimson =
    OpaqueColor.fromRGB ( 220, 20, 60 )


{-| -}
firebrick : OpaqueColor
firebrick =
    OpaqueColor.fromRGB ( 178, 34, 34 )


{-| -}
darkRed : OpaqueColor
darkRed =
    OpaqueColor.fromRGB ( 139, 0, 0 )


{-| -}
red : OpaqueColor
red =
    OpaqueColor.fromRGB ( 255, 0, 0 )



-- ORANGE REDS


{-| -}
orangeRed : OpaqueColor
orangeRed =
    OpaqueColor.fromRGB ( 255, 69, 0 )


{-| -}
tomato : OpaqueColor
tomato =
    OpaqueColor.fromRGB ( 255, 99, 71 )


{-| -}
coral : OpaqueColor
coral =
    OpaqueColor.fromRGB ( 255, 127, 80 )


{-| -}
darkOrange : OpaqueColor
darkOrange =
    OpaqueColor.fromRGB ( 255, 140, 0 )


{-| -}
orange : OpaqueColor
orange =
    OpaqueColor.fromRGB ( 255, 165, 0 )



-- YELLOWS


{-| -}
yellow : OpaqueColor
yellow =
    OpaqueColor.fromRGB ( 255, 255, 0 )


{-| -}
lightYellow : OpaqueColor
lightYellow =
    OpaqueColor.fromRGB ( 255, 255, 224 )


{-| -}
lemonChiffon : OpaqueColor
lemonChiffon =
    OpaqueColor.fromRGB ( 255, 250, 205 )


{-| -}
lightGoldenrodYellow : OpaqueColor
lightGoldenrodYellow =
    OpaqueColor.fromRGB ( 250, 250, 210 )


{-| -}
papayaWhip : OpaqueColor
papayaWhip =
    OpaqueColor.fromRGB ( 255, 239, 213 )


{-| -}
moccasin : OpaqueColor
moccasin =
    OpaqueColor.fromRGB ( 255, 228, 181 )


{-| -}
peachPuff : OpaqueColor
peachPuff =
    OpaqueColor.fromRGB ( 255, 218, 185 )


{-| -}
paleGoldenrod : OpaqueColor
paleGoldenrod =
    OpaqueColor.fromRGB ( 238, 232, 170 )


{-| -}
khaki : OpaqueColor
khaki =
    OpaqueColor.fromRGB ( 240, 230, 140 )


{-| -}
darkKhaki : OpaqueColor
darkKhaki =
    OpaqueColor.fromRGB ( 189, 183, 107 )


{-| -}
gold : OpaqueColor
gold =
    OpaqueColor.fromRGB ( 255, 215, 0 )



-- BROWNS


{-| -}
cornsilk : OpaqueColor
cornsilk =
    OpaqueColor.fromRGB ( 255, 248, 220 )


{-| -}
blanchedAlmond : OpaqueColor
blanchedAlmond =
    OpaqueColor.fromRGB ( 255, 235, 205 )


{-| -}
bisque : OpaqueColor
bisque =
    OpaqueColor.fromRGB ( 255, 228, 196 )


{-| -}
navajoWhite : OpaqueColor
navajoWhite =
    OpaqueColor.fromRGB ( 255, 222, 173 )


{-| -}
wheat : OpaqueColor
wheat =
    OpaqueColor.fromRGB ( 245, 222, 179 )


{-| -}
burlywood : OpaqueColor
burlywood =
    OpaqueColor.fromRGB ( 222, 184, 135 )


{-| -}
tan : OpaqueColor
tan =
    OpaqueColor.fromRGB ( 210, 180, 140 )


{-| -}
rosyBrown : OpaqueColor
rosyBrown =
    OpaqueColor.fromRGB ( 188, 143, 143 )


{-| -}
sandyBrown : OpaqueColor
sandyBrown =
    OpaqueColor.fromRGB ( 244, 164, 96 )


{-| -}
goldenrod : OpaqueColor
goldenrod =
    OpaqueColor.fromRGB ( 218, 165, 32 )


{-| -}
darkGoldenrod : OpaqueColor
darkGoldenrod =
    OpaqueColor.fromRGB ( 184, 134, 11 )


{-| -}
peru : OpaqueColor
peru =
    OpaqueColor.fromRGB ( 205, 133, 63 )


{-| -}
chocolate : OpaqueColor
chocolate =
    OpaqueColor.fromRGB ( 210, 105, 30 )


{-| -}
saddleBrown : OpaqueColor
saddleBrown =
    OpaqueColor.fromRGB ( 139, 69, 19 )


{-| -}
sienna : OpaqueColor
sienna =
    OpaqueColor.fromRGB ( 160, 82, 45 )


{-| -}
brown : OpaqueColor
brown =
    OpaqueColor.fromRGB ( 165, 42, 42 )


{-| -}
maroon : OpaqueColor
maroon =
    OpaqueColor.fromRGB ( 128, 0, 0 )



-- GREENS


{-| -}
darkOliveGreen : OpaqueColor
darkOliveGreen =
    OpaqueColor.fromRGB ( 85, 107, 47 )


{-| -}
olive : OpaqueColor
olive =
    OpaqueColor.fromRGB ( 128, 128, 0 )


{-| -}
oliveDrab : OpaqueColor
oliveDrab =
    OpaqueColor.fromRGB ( 107, 142, 35 )


{-| -}
yellowGreen : OpaqueColor
yellowGreen =
    OpaqueColor.fromRGB ( 154, 205, 50 )


{-| -}
limeGreen : OpaqueColor
limeGreen =
    OpaqueColor.fromRGB ( 50, 205, 50 )


{-| -}
lime : OpaqueColor
lime =
    OpaqueColor.fromRGB ( 0, 255, 0 )


{-| -}
lawnGreen : OpaqueColor
lawnGreen =
    OpaqueColor.fromRGB ( 124, 252, 0 )


{-| -}
chartreuse : OpaqueColor
chartreuse =
    OpaqueColor.fromRGB ( 127, 255, 0 )


{-| -}
greenYellow : OpaqueColor
greenYellow =
    OpaqueColor.fromRGB ( 173, 255, 47 )


{-| -}
springGreen : OpaqueColor
springGreen =
    OpaqueColor.fromRGB ( 0, 255, 127 )


{-| -}
mediumSpringGreen : OpaqueColor
mediumSpringGreen =
    OpaqueColor.fromRGB ( 0, 250, 154 )


{-| -}
lightGreen : OpaqueColor
lightGreen =
    OpaqueColor.fromRGB ( 144, 238, 144 )


{-| -}
paleGreen : OpaqueColor
paleGreen =
    OpaqueColor.fromRGB ( 152, 251, 152 )


{-| -}
darkSeaGreen : OpaqueColor
darkSeaGreen =
    OpaqueColor.fromRGB ( 143, 188, 143 )


{-| -}
mediumAquamarine : OpaqueColor
mediumAquamarine =
    OpaqueColor.fromRGB ( 102, 205, 170 )


{-| -}
mediumSeaGreen : OpaqueColor
mediumSeaGreen =
    OpaqueColor.fromRGB ( 60, 179, 113 )


{-| -}
seaGreen : OpaqueColor
seaGreen =
    OpaqueColor.fromRGB ( 46, 139, 87 )


{-| -}
forestGreen : OpaqueColor
forestGreen =
    OpaqueColor.fromRGB ( 34, 139, 34 )


{-| -}
green : OpaqueColor
green =
    OpaqueColor.fromRGB ( 0, 128, 0 )


{-| -}
darkGreen : OpaqueColor
darkGreen =
    OpaqueColor.fromRGB ( 0, 100, 0 )



-- CYANS


{-| -}
aqua : OpaqueColor
aqua =
    OpaqueColor.fromRGB ( 0, 255, 255 )


{-| -}
cyan : OpaqueColor
cyan =
    OpaqueColor.fromRGB ( 0, 255, 255 )


{-| -}
lightCyan : OpaqueColor
lightCyan =
    OpaqueColor.fromRGB ( 224, 255, 255 )


{-| -}
paleTurquoise : OpaqueColor
paleTurquoise =
    OpaqueColor.fromRGB ( 175, 238, 238 )


{-| -}
aquamarine : OpaqueColor
aquamarine =
    OpaqueColor.fromRGB ( 127, 255, 212 )


{-| -}
turquoise : OpaqueColor
turquoise =
    OpaqueColor.fromRGB ( 64, 224, 208 )


{-| -}
mediumTurquoise : OpaqueColor
mediumTurquoise =
    OpaqueColor.fromRGB ( 72, 209, 204 )


{-| -}
darkTurquoise : OpaqueColor
darkTurquoise =
    OpaqueColor.fromRGB ( 0, 206, 209 )


{-| -}
lightSeaGreen : OpaqueColor
lightSeaGreen =
    OpaqueColor.fromRGB ( 32, 178, 170 )


{-| -}
cadetBlue : OpaqueColor
cadetBlue =
    OpaqueColor.fromRGB ( 95, 158, 160 )


{-| -}
darkCyan : OpaqueColor
darkCyan =
    OpaqueColor.fromRGB ( 0, 139, 139 )


{-| -}
teal : OpaqueColor
teal =
    OpaqueColor.fromRGB ( 0, 128, 128 )



-- BLUES


{-| -}
lightSteelBlue : OpaqueColor
lightSteelBlue =
    OpaqueColor.fromRGB ( 176, 196, 222 )


{-| -}
powderBlue : OpaqueColor
powderBlue =
    OpaqueColor.fromRGB ( 176, 224, 230 )


{-| -}
lightBlue : OpaqueColor
lightBlue =
    OpaqueColor.fromRGB ( 173, 216, 230 )


{-| -}
skyBlue : OpaqueColor
skyBlue =
    OpaqueColor.fromRGB ( 135, 206, 235 )


{-| -}
lightSkyBlue : OpaqueColor
lightSkyBlue =
    OpaqueColor.fromRGB ( 135, 206, 250 )


{-| -}
deepSkyBlue : OpaqueColor
deepSkyBlue =
    OpaqueColor.fromRGB ( 0, 191, 255 )


{-| -}
dodgerBlue : OpaqueColor
dodgerBlue =
    OpaqueColor.fromRGB ( 30, 144, 255 )


{-| -}
cornflowerBlue : OpaqueColor
cornflowerBlue =
    OpaqueColor.fromRGB ( 100, 149, 237 )


{-| -}
steelBlue : OpaqueColor
steelBlue =
    OpaqueColor.fromRGB ( 70, 130, 180 )


{-| -}
royalBlue : OpaqueColor
royalBlue =
    OpaqueColor.fromRGB ( 65, 105, 225 )


{-| -}
blue : OpaqueColor
blue =
    OpaqueColor.fromRGB ( 0, 0, 255 )


{-| -}
mediumBlue : OpaqueColor
mediumBlue =
    OpaqueColor.fromRGB ( 0, 0, 205 )


{-| -}
darkBlue : OpaqueColor
darkBlue =
    OpaqueColor.fromRGB ( 0, 0, 139 )


{-| -}
navy : OpaqueColor
navy =
    OpaqueColor.fromRGB ( 0, 0, 128 )


{-| -}
midnightBlue : OpaqueColor
midnightBlue =
    OpaqueColor.fromRGB ( 25, 25, 112 )



-- PURPLES


{-| -}
lavender : OpaqueColor
lavender =
    OpaqueColor.fromRGB ( 230, 230, 250 )


{-| -}
thistle : OpaqueColor
thistle =
    OpaqueColor.fromRGB ( 216, 191, 216 )


{-| -}
plum : OpaqueColor
plum =
    OpaqueColor.fromRGB ( 221, 160, 221 )


{-| -}
violet : OpaqueColor
violet =
    OpaqueColor.fromRGB ( 238, 130, 238 )


{-| -}
orchid : OpaqueColor
orchid =
    OpaqueColor.fromRGB ( 218, 112, 214 )


{-| -}
fuchsia : OpaqueColor
fuchsia =
    OpaqueColor.fromRGB ( 255, 0, 255 )


{-| -}
magenta : OpaqueColor
magenta =
    OpaqueColor.fromRGB ( 255, 0, 255 )


{-| -}
mediumOrchid : OpaqueColor
mediumOrchid =
    OpaqueColor.fromRGB ( 186, 85, 211 )


{-| -}
mediumPurple : OpaqueColor
mediumPurple =
    OpaqueColor.fromRGB ( 147, 112, 219 )


{-| -}
blueViolet : OpaqueColor
blueViolet =
    OpaqueColor.fromRGB ( 138, 43, 226 )


{-| -}
darkViolet : OpaqueColor
darkViolet =
    OpaqueColor.fromRGB ( 148, 0, 211 )


{-| -}
darkOrchid : OpaqueColor
darkOrchid =
    OpaqueColor.fromRGB ( 153, 50, 204 )


{-| -}
darkMagenta : OpaqueColor
darkMagenta =
    OpaqueColor.fromRGB ( 139, 0, 139 )


{-| -}
purple : OpaqueColor
purple =
    OpaqueColor.fromRGB ( 128, 0, 128 )


{-| -}
indigo : OpaqueColor
indigo =
    OpaqueColor.fromRGB ( 75, 0, 130 )


{-| -}
darkSlateBlue : OpaqueColor
darkSlateBlue =
    OpaqueColor.fromRGB ( 72, 61, 139 )


{-| -}
slateBlue : OpaqueColor
slateBlue =
    OpaqueColor.fromRGB ( 106, 90, 205 )


{-| -}
mediumSlateBlue : OpaqueColor
mediumSlateBlue =
    OpaqueColor.fromRGB ( 123, 104, 238 )



-- WHITES


{-| -}
white : OpaqueColor
white =
    OpaqueColor.fromRGB ( 255, 255, 255 )


{-| -}
snow : OpaqueColor
snow =
    OpaqueColor.fromRGB ( 255, 250, 250 )


{-| -}
honeydew : OpaqueColor
honeydew =
    OpaqueColor.fromRGB ( 240, 255, 240 )


{-| -}
mintCream : OpaqueColor
mintCream =
    OpaqueColor.fromRGB ( 245, 255, 250 )


{-| -}
azure : OpaqueColor
azure =
    OpaqueColor.fromRGB ( 240, 255, 255 )


{-| -}
aliceBlue : OpaqueColor
aliceBlue =
    OpaqueColor.fromRGB ( 240, 248, 255 )


{-| -}
ghostWhite : OpaqueColor
ghostWhite =
    OpaqueColor.fromRGB ( 248, 248, 255 )


{-| -}
whiteSmoke : OpaqueColor
whiteSmoke =
    OpaqueColor.fromRGB ( 245, 245, 245 )


{-| -}
seashell : OpaqueColor
seashell =
    OpaqueColor.fromRGB ( 255, 245, 238 )


{-| -}
beige : OpaqueColor
beige =
    OpaqueColor.fromRGB ( 245, 245, 220 )


{-| -}
oldLace : OpaqueColor
oldLace =
    OpaqueColor.fromRGB ( 253, 245, 230 )


{-| -}
floralWhite : OpaqueColor
floralWhite =
    OpaqueColor.fromRGB ( 255, 250, 240 )


{-| -}
ivory : OpaqueColor
ivory =
    OpaqueColor.fromRGB ( 255, 255, 240 )


{-| -}
antiqueWhite : OpaqueColor
antiqueWhite =
    OpaqueColor.fromRGB ( 250, 235, 215 )


{-| -}
linen : OpaqueColor
linen =
    OpaqueColor.fromRGB ( 250, 240, 230 )


{-| -}
lavenderBlush : OpaqueColor
lavenderBlush =
    OpaqueColor.fromRGB ( 255, 240, 245 )


{-| -}
mistyRose : OpaqueColor
mistyRose =
    OpaqueColor.fromRGB ( 255, 228, 225 )



-- GRAYS AND BLACKS


{-| -}
gainsboro : OpaqueColor
gainsboro =
    OpaqueColor.fromRGB ( 220, 220, 220 )


{-| -}
lightGray : OpaqueColor
lightGray =
    OpaqueColor.fromRGB ( 211, 211, 211 )


{-| -}
silver : OpaqueColor
silver =
    OpaqueColor.fromRGB ( 192, 192, 192 )


{-| -}
darkGray : OpaqueColor
darkGray =
    OpaqueColor.fromRGB ( 169, 169, 169 )


{-| -}
gray : OpaqueColor
gray =
    OpaqueColor.fromRGB ( 128, 128, 128 )


{-| -}
dimGray : OpaqueColor
dimGray =
    OpaqueColor.fromRGB ( 105, 105, 105 )


{-| -}
lightSlateGray : OpaqueColor
lightSlateGray =
    OpaqueColor.fromRGB ( 119, 136, 153 )


{-| -}
slateGray : OpaqueColor
slateGray =
    OpaqueColor.fromRGB ( 112, 128, 144 )


{-| -}
darkSlateGray : OpaqueColor
darkSlateGray =
    OpaqueColor.fromRGB ( 47, 79, 79 )


{-| -}
black : OpaqueColor
black =
    OpaqueColor.fromRGB ( 0, 0, 0 )

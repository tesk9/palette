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

import SolidColor exposing (SolidColor)



--PINKS


{-| -}
pink : SolidColor
pink =
    SolidColor.fromRGB ( 255, 192, 203 )


{-| -}
lightPink : SolidColor
lightPink =
    SolidColor.fromRGB ( 255, 182, 193 )


{-| -}
hotPink : SolidColor
hotPink =
    SolidColor.fromRGB ( 255, 105, 180 )


{-| -}
deepPink : SolidColor
deepPink =
    SolidColor.fromRGB ( 255, 20, 147 )


{-| -}
paleVioletRed : SolidColor
paleVioletRed =
    SolidColor.fromRGB ( 219, 112, 147 )


{-| -}
mediumVioletRed : SolidColor
mediumVioletRed =
    SolidColor.fromRGB ( 199, 21, 133 )



-- REDS


{-| -}
lightSalmon : SolidColor
lightSalmon =
    SolidColor.fromRGB ( 255, 160, 122 )


{-| -}
salmon : SolidColor
salmon =
    SolidColor.fromRGB ( 250, 128, 114 )


{-| -}
darkSalmon : SolidColor
darkSalmon =
    SolidColor.fromRGB ( 233, 150, 122 )


{-| -}
lightCoral : SolidColor
lightCoral =
    SolidColor.fromRGB ( 240, 128, 128 )


{-| -}
indianRed : SolidColor
indianRed =
    SolidColor.fromRGB ( 205, 92, 92 )


{-| -}
crimson : SolidColor
crimson =
    SolidColor.fromRGB ( 220, 20, 60 )


{-| -}
firebrick : SolidColor
firebrick =
    SolidColor.fromRGB ( 178, 34, 34 )


{-| -}
darkRed : SolidColor
darkRed =
    SolidColor.fromRGB ( 139, 0, 0 )


{-| -}
red : SolidColor
red =
    SolidColor.fromRGB ( 255, 0, 0 )



-- ORANGE REDS


{-| -}
orangeRed : SolidColor
orangeRed =
    SolidColor.fromRGB ( 255, 69, 0 )


{-| -}
tomato : SolidColor
tomato =
    SolidColor.fromRGB ( 255, 99, 71 )


{-| -}
coral : SolidColor
coral =
    SolidColor.fromRGB ( 255, 127, 80 )


{-| -}
darkOrange : SolidColor
darkOrange =
    SolidColor.fromRGB ( 255, 140, 0 )


{-| -}
orange : SolidColor
orange =
    SolidColor.fromRGB ( 255, 165, 0 )



-- YELLOWS


{-| -}
yellow : SolidColor
yellow =
    SolidColor.fromRGB ( 255, 255, 0 )


{-| -}
lightYellow : SolidColor
lightYellow =
    SolidColor.fromRGB ( 255, 255, 224 )


{-| -}
lemonChiffon : SolidColor
lemonChiffon =
    SolidColor.fromRGB ( 255, 250, 205 )


{-| -}
lightGoldenrodYellow : SolidColor
lightGoldenrodYellow =
    SolidColor.fromRGB ( 250, 250, 210 )


{-| -}
papayaWhip : SolidColor
papayaWhip =
    SolidColor.fromRGB ( 255, 239, 213 )


{-| -}
moccasin : SolidColor
moccasin =
    SolidColor.fromRGB ( 255, 228, 181 )


{-| -}
peachPuff : SolidColor
peachPuff =
    SolidColor.fromRGB ( 255, 218, 185 )


{-| -}
paleGoldenrod : SolidColor
paleGoldenrod =
    SolidColor.fromRGB ( 238, 232, 170 )


{-| -}
khaki : SolidColor
khaki =
    SolidColor.fromRGB ( 240, 230, 140 )


{-| -}
darkKhaki : SolidColor
darkKhaki =
    SolidColor.fromRGB ( 189, 183, 107 )


{-| -}
gold : SolidColor
gold =
    SolidColor.fromRGB ( 255, 215, 0 )



-- BROWNS


{-| -}
cornsilk : SolidColor
cornsilk =
    SolidColor.fromRGB ( 255, 248, 220 )


{-| -}
blanchedAlmond : SolidColor
blanchedAlmond =
    SolidColor.fromRGB ( 255, 235, 205 )


{-| -}
bisque : SolidColor
bisque =
    SolidColor.fromRGB ( 255, 228, 196 )


{-| -}
navajoWhite : SolidColor
navajoWhite =
    SolidColor.fromRGB ( 255, 222, 173 )


{-| -}
wheat : SolidColor
wheat =
    SolidColor.fromRGB ( 245, 222, 179 )


{-| -}
burlywood : SolidColor
burlywood =
    SolidColor.fromRGB ( 222, 184, 135 )


{-| -}
tan : SolidColor
tan =
    SolidColor.fromRGB ( 210, 180, 140 )


{-| -}
rosyBrown : SolidColor
rosyBrown =
    SolidColor.fromRGB ( 188, 143, 143 )


{-| -}
sandyBrown : SolidColor
sandyBrown =
    SolidColor.fromRGB ( 244, 164, 96 )


{-| -}
goldenrod : SolidColor
goldenrod =
    SolidColor.fromRGB ( 218, 165, 32 )


{-| -}
darkGoldenrod : SolidColor
darkGoldenrod =
    SolidColor.fromRGB ( 184, 134, 11 )


{-| -}
peru : SolidColor
peru =
    SolidColor.fromRGB ( 205, 133, 63 )


{-| -}
chocolate : SolidColor
chocolate =
    SolidColor.fromRGB ( 210, 105, 30 )


{-| -}
saddleBrown : SolidColor
saddleBrown =
    SolidColor.fromRGB ( 139, 69, 19 )


{-| -}
sienna : SolidColor
sienna =
    SolidColor.fromRGB ( 160, 82, 45 )


{-| -}
brown : SolidColor
brown =
    SolidColor.fromRGB ( 165, 42, 42 )


{-| -}
maroon : SolidColor
maroon =
    SolidColor.fromRGB ( 128, 0, 0 )



-- GREENS


{-| -}
darkOliveGreen : SolidColor
darkOliveGreen =
    SolidColor.fromRGB ( 85, 107, 47 )


{-| -}
olive : SolidColor
olive =
    SolidColor.fromRGB ( 128, 128, 0 )


{-| -}
oliveDrab : SolidColor
oliveDrab =
    SolidColor.fromRGB ( 107, 142, 35 )


{-| -}
yellowGreen : SolidColor
yellowGreen =
    SolidColor.fromRGB ( 154, 205, 50 )


{-| -}
limeGreen : SolidColor
limeGreen =
    SolidColor.fromRGB ( 50, 205, 50 )


{-| -}
lime : SolidColor
lime =
    SolidColor.fromRGB ( 0, 255, 0 )


{-| -}
lawnGreen : SolidColor
lawnGreen =
    SolidColor.fromRGB ( 124, 252, 0 )


{-| -}
chartreuse : SolidColor
chartreuse =
    SolidColor.fromRGB ( 127, 255, 0 )


{-| -}
greenYellow : SolidColor
greenYellow =
    SolidColor.fromRGB ( 173, 255, 47 )


{-| -}
springGreen : SolidColor
springGreen =
    SolidColor.fromRGB ( 0, 255, 127 )


{-| -}
mediumSpringGreen : SolidColor
mediumSpringGreen =
    SolidColor.fromRGB ( 0, 250, 154 )


{-| -}
lightGreen : SolidColor
lightGreen =
    SolidColor.fromRGB ( 144, 238, 144 )


{-| -}
paleGreen : SolidColor
paleGreen =
    SolidColor.fromRGB ( 152, 251, 152 )


{-| -}
darkSeaGreen : SolidColor
darkSeaGreen =
    SolidColor.fromRGB ( 143, 188, 143 )


{-| -}
mediumAquamarine : SolidColor
mediumAquamarine =
    SolidColor.fromRGB ( 102, 205, 170 )


{-| -}
mediumSeaGreen : SolidColor
mediumSeaGreen =
    SolidColor.fromRGB ( 60, 179, 113 )


{-| -}
seaGreen : SolidColor
seaGreen =
    SolidColor.fromRGB ( 46, 139, 87 )


{-| -}
forestGreen : SolidColor
forestGreen =
    SolidColor.fromRGB ( 34, 139, 34 )


{-| -}
green : SolidColor
green =
    SolidColor.fromRGB ( 0, 128, 0 )


{-| -}
darkGreen : SolidColor
darkGreen =
    SolidColor.fromRGB ( 0, 100, 0 )



-- CYANS


{-| -}
aqua : SolidColor
aqua =
    SolidColor.fromRGB ( 0, 255, 255 )


{-| -}
cyan : SolidColor
cyan =
    SolidColor.fromRGB ( 0, 255, 255 )


{-| -}
lightCyan : SolidColor
lightCyan =
    SolidColor.fromRGB ( 224, 255, 255 )


{-| -}
paleTurquoise : SolidColor
paleTurquoise =
    SolidColor.fromRGB ( 175, 238, 238 )


{-| -}
aquamarine : SolidColor
aquamarine =
    SolidColor.fromRGB ( 127, 255, 212 )


{-| -}
turquoise : SolidColor
turquoise =
    SolidColor.fromRGB ( 64, 224, 208 )


{-| -}
mediumTurquoise : SolidColor
mediumTurquoise =
    SolidColor.fromRGB ( 72, 209, 204 )


{-| -}
darkTurquoise : SolidColor
darkTurquoise =
    SolidColor.fromRGB ( 0, 206, 209 )


{-| -}
lightSeaGreen : SolidColor
lightSeaGreen =
    SolidColor.fromRGB ( 32, 178, 170 )


{-| -}
cadetBlue : SolidColor
cadetBlue =
    SolidColor.fromRGB ( 95, 158, 160 )


{-| -}
darkCyan : SolidColor
darkCyan =
    SolidColor.fromRGB ( 0, 139, 139 )


{-| -}
teal : SolidColor
teal =
    SolidColor.fromRGB ( 0, 128, 128 )



-- BLUES


{-| -}
lightSteelBlue : SolidColor
lightSteelBlue =
    SolidColor.fromRGB ( 176, 196, 222 )


{-| -}
powderBlue : SolidColor
powderBlue =
    SolidColor.fromRGB ( 176, 224, 230 )


{-| -}
lightBlue : SolidColor
lightBlue =
    SolidColor.fromRGB ( 173, 216, 230 )


{-| -}
skyBlue : SolidColor
skyBlue =
    SolidColor.fromRGB ( 135, 206, 235 )


{-| -}
lightSkyBlue : SolidColor
lightSkyBlue =
    SolidColor.fromRGB ( 135, 206, 250 )


{-| -}
deepSkyBlue : SolidColor
deepSkyBlue =
    SolidColor.fromRGB ( 0, 191, 255 )


{-| -}
dodgerBlue : SolidColor
dodgerBlue =
    SolidColor.fromRGB ( 30, 144, 255 )


{-| -}
cornflowerBlue : SolidColor
cornflowerBlue =
    SolidColor.fromRGB ( 100, 149, 237 )


{-| -}
steelBlue : SolidColor
steelBlue =
    SolidColor.fromRGB ( 70, 130, 180 )


{-| -}
royalBlue : SolidColor
royalBlue =
    SolidColor.fromRGB ( 65, 105, 225 )


{-| -}
blue : SolidColor
blue =
    SolidColor.fromRGB ( 0, 0, 255 )


{-| -}
mediumBlue : SolidColor
mediumBlue =
    SolidColor.fromRGB ( 0, 0, 205 )


{-| -}
darkBlue : SolidColor
darkBlue =
    SolidColor.fromRGB ( 0, 0, 139 )


{-| -}
navy : SolidColor
navy =
    SolidColor.fromRGB ( 0, 0, 128 )


{-| -}
midnightBlue : SolidColor
midnightBlue =
    SolidColor.fromRGB ( 25, 25, 112 )



-- PURPLES


{-| -}
lavender : SolidColor
lavender =
    SolidColor.fromRGB ( 230, 230, 250 )


{-| -}
thistle : SolidColor
thistle =
    SolidColor.fromRGB ( 216, 191, 216 )


{-| -}
plum : SolidColor
plum =
    SolidColor.fromRGB ( 221, 160, 221 )


{-| -}
violet : SolidColor
violet =
    SolidColor.fromRGB ( 238, 130, 238 )


{-| -}
orchid : SolidColor
orchid =
    SolidColor.fromRGB ( 218, 112, 214 )


{-| -}
fuchsia : SolidColor
fuchsia =
    SolidColor.fromRGB ( 255, 0, 255 )


{-| -}
magenta : SolidColor
magenta =
    SolidColor.fromRGB ( 255, 0, 255 )


{-| -}
mediumOrchid : SolidColor
mediumOrchid =
    SolidColor.fromRGB ( 186, 85, 211 )


{-| -}
mediumPurple : SolidColor
mediumPurple =
    SolidColor.fromRGB ( 147, 112, 219 )


{-| -}
blueViolet : SolidColor
blueViolet =
    SolidColor.fromRGB ( 138, 43, 226 )


{-| -}
darkViolet : SolidColor
darkViolet =
    SolidColor.fromRGB ( 148, 0, 211 )


{-| -}
darkOrchid : SolidColor
darkOrchid =
    SolidColor.fromRGB ( 153, 50, 204 )


{-| -}
darkMagenta : SolidColor
darkMagenta =
    SolidColor.fromRGB ( 139, 0, 139 )


{-| -}
purple : SolidColor
purple =
    SolidColor.fromRGB ( 128, 0, 128 )


{-| -}
indigo : SolidColor
indigo =
    SolidColor.fromRGB ( 75, 0, 130 )


{-| -}
darkSlateBlue : SolidColor
darkSlateBlue =
    SolidColor.fromRGB ( 72, 61, 139 )


{-| -}
slateBlue : SolidColor
slateBlue =
    SolidColor.fromRGB ( 106, 90, 205 )


{-| -}
mediumSlateBlue : SolidColor
mediumSlateBlue =
    SolidColor.fromRGB ( 123, 104, 238 )



-- WHITES


{-| -}
white : SolidColor
white =
    SolidColor.fromRGB ( 255, 255, 255 )


{-| -}
snow : SolidColor
snow =
    SolidColor.fromRGB ( 255, 250, 250 )


{-| -}
honeydew : SolidColor
honeydew =
    SolidColor.fromRGB ( 240, 255, 240 )


{-| -}
mintCream : SolidColor
mintCream =
    SolidColor.fromRGB ( 245, 255, 250 )


{-| -}
azure : SolidColor
azure =
    SolidColor.fromRGB ( 240, 255, 255 )


{-| -}
aliceBlue : SolidColor
aliceBlue =
    SolidColor.fromRGB ( 240, 248, 255 )


{-| -}
ghostWhite : SolidColor
ghostWhite =
    SolidColor.fromRGB ( 248, 248, 255 )


{-| -}
whiteSmoke : SolidColor
whiteSmoke =
    SolidColor.fromRGB ( 245, 245, 245 )


{-| -}
seashell : SolidColor
seashell =
    SolidColor.fromRGB ( 255, 245, 238 )


{-| -}
beige : SolidColor
beige =
    SolidColor.fromRGB ( 245, 245, 220 )


{-| -}
oldLace : SolidColor
oldLace =
    SolidColor.fromRGB ( 253, 245, 230 )


{-| -}
floralWhite : SolidColor
floralWhite =
    SolidColor.fromRGB ( 255, 250, 240 )


{-| -}
ivory : SolidColor
ivory =
    SolidColor.fromRGB ( 255, 255, 240 )


{-| -}
antiqueWhite : SolidColor
antiqueWhite =
    SolidColor.fromRGB ( 250, 235, 215 )


{-| -}
linen : SolidColor
linen =
    SolidColor.fromRGB ( 250, 240, 230 )


{-| -}
lavenderBlush : SolidColor
lavenderBlush =
    SolidColor.fromRGB ( 255, 240, 245 )


{-| -}
mistyRose : SolidColor
mistyRose =
    SolidColor.fromRGB ( 255, 228, 225 )



-- GRAYS AND BLACKS


{-| -}
gainsboro : SolidColor
gainsboro =
    SolidColor.fromRGB ( 220, 220, 220 )


{-| -}
lightGray : SolidColor
lightGray =
    SolidColor.fromRGB ( 211, 211, 211 )


{-| -}
silver : SolidColor
silver =
    SolidColor.fromRGB ( 192, 192, 192 )


{-| -}
darkGray : SolidColor
darkGray =
    SolidColor.fromRGB ( 169, 169, 169 )


{-| -}
gray : SolidColor
gray =
    SolidColor.fromRGB ( 128, 128, 128 )


{-| -}
dimGray : SolidColor
dimGray =
    SolidColor.fromRGB ( 105, 105, 105 )


{-| -}
lightSlateGray : SolidColor
lightSlateGray =
    SolidColor.fromRGB ( 119, 136, 153 )


{-| -}
slateGray : SolidColor
slateGray =
    SolidColor.fromRGB ( 112, 128, 144 )


{-| -}
darkSlateGray : SolidColor
darkSlateGray =
    SolidColor.fromRGB ( 47, 79, 79 )


{-| -}
black : SolidColor
black =
    SolidColor.fromRGB ( 0, 0, 0 )

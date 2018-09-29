module Fixtures exposing
    ( black
    , blackHSL
    , grey
    , greyHSL
    , red
    , redHSL
    , white
    , whiteHSL
    )

import Color exposing (Color)


white : Color
white =
    Color.fromRGB ( 255, 255, 255 )


whiteHSL : Color
whiteHSL =
    Color.fromHSL ( 0, 0, 100 )


grey : Color
grey =
    Color.fromRGB ( 118, 118, 118 )


greyHSL : Color
greyHSL =
    Color.fromHSL ( 0, 0, 46 )


blackHSL : Color
blackHSL =
    Color.fromHSL ( 0, 0, 0 )


black : Color
black =
    Color.fromRGB ( 0, 0, 0 )


red : Color
red =
    Color.fromRGB ( 255, 0, 0 )


redHSL : Color
redHSL =
    Color.fromHSL ( 0, 100, 50 )

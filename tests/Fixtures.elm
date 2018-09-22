module Fixtures exposing (black, grey, white)

import Color exposing (Color)


white : Color
white =
    Color.fromRGB ( 255, 255, 255 )


grey : Color
grey =
    Color.fromRGB ( 118, 118, 118 )


black : Color
black =
    Color.fromRGB ( 0, 0, 0 )

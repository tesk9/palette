[![Build Status](https://travis-ci.org/tesk9/palette.svg?branch=master)](https://travis-ci.org/tesk9/palette)

Work with colours safely  and accessibly.

## Creating colours

Create colours from RGB, HSL, and hex values.

```
import Colour exposing (Colour)


myOrangeyRed : Colour
myOrangeyRed =
    Colour.fromRGB ( 255, 80, 0 )


myTurquoiseIsh : Colour
myTurquoiseIsh =
    Colour.fromHSL (127, 50, 50)


myHex : Result String Colour
myHex =
    Colour.fromHex "#ff9800"

```

## Accessibility

Use helpers like `contrast` and `sufficientContrast` to verify that your font size, boldness, and colours meet accessibility standards.

```
import Colour exposing (Colour)
import Colour.Accessibility exposing (Rating, meetsAAA)

validFontColour : Colour -> Bool
validFontColour fontColour =
    checkContrast { fontSize = 12, fontWeight = 700 }
        (Colour.fromRGB ( 255, 255, 255 ))
        fontColour
        |> meetsAAA
```

## Use static palettes

Use [X11](https://en.wikipedia.org/wiki/X11_color_names) and [Tango](http://tango.freedesktop.org/Tango_Icon_Theme_Guidelines#Color_Palette) colours by name:

```
import Colour exposing (Colour)
import Palette.X11 as X11 exposing (orangeRed, tomato, coral, darkOrange, orange)
import Palette.Tango as Tango exposing (butter1, butter2, butter3)

orangyReds : List Colour
orangyReds =
    [ orangeRed, tomato, coral, darkOrange, orange ]


allTheButter : List Colour
allTheButter =
    [ butter1, butter2, butter3 ]
```

## Generate palettes

Generate a customized cubehelix colour scheme using `Palette.Cubehelix` and `Palette.Generative`.

`Palette.Cubehelix` is a good choice for charts & graphs because the produced colours have quite even visual intensity.

Designers often approach colour not by picking one colour at a time, but by describing the relationships between
the colours, e.g., "I want 4 colours that are equally spaced on the colour wheel," or, "I want 10 colours that
are all of the same hue but with different lightnesses."

If you approach colour like this, then you'll be interested in using `Palette.Generative`, which has
helpers like `square` (generates 4 evenly-spaced colours) and `monochromatic` (generates lovely
single-hue lists of colours).


## Mixing colours together

If you've used Photoshop, you may be familiar with colour blending with functions
like `multiply`. If not, I recommend taking a look at the examples & playing until
you get a feel for what the functions do.


## Transparent colours

Work with alpha channel values/transparency/opacity.

```
import Colour.Transparent
```

## Developing & Contributing

Contributions welcome!
https://github.com/tesk9/palette

### Examples

```
cd examples
elm reactor
open http://localhost:8000/src/Main.elm
```

### Running tests

```
npm install
npm test
```

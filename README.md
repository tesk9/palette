[![Build Status](https://travis-ci.org/tesk9/palette.svg?branch=master)](https://travis-ci.org/tesk9/palette)

Work with colors safely  and accessibly.

## Creating colors

Create colors from RGB, HSL, and hex values.

```
import SolidColor exposing (SolidColor)


myOrangeyRed : SolidColor
myOrangeyRed =
    SolidColor.fromRGB ( 255, 80, 0 )


myTurquoiseIsh : SolidColor
myTurquoiseIsh =
    SolidColor.fromHSL (127, 50, 50)


myHex : Result String SolidColor
myHex =
    SolidColor.fromHex "#ff9800"

```

## Accessibility

Use helpers like `contrast` and `sufficientContrast` to verify that your font size, boldness, and colors meet accessibility standards.

```
import SolidColor exposing (SolidColor)
import SolidColor.Accessibility exposing (Rating, meetsAAA)

validFontColor : SolidColor -> Bool
validFontColor fontColor =
    checkContrast { fontSize = 12, fontWeight = 700 }
        (SolidColor.fromRGB ( 255, 255, 255 ))
        fontColor
        |> meetsAAA
```

## Use static palettes

Use [X11](https://en.wikipedia.org/wiki/X11_color_names) and [Tango](http://tango.freedesktop.org/Tango_Icon_Theme_Guidelines#Color_Palette) colors by name:

```
import SolidColor exposing (SolidColor)
import Palette.X11 as X11 exposing (orangeRed, tomato, coral, darkOrange, orange)
import Palette.Tango as Tango exposing (butter1, butter2, butter3)

orangyReds : List SolidColor
orangyReds =
    [ orangeRed, tomato, coral, darkOrange, orange ]


allTheButter : List SolidColor
allTheButter =
    [ butter1, butter2, butter3 ]
```

## Generate palettes

Generate a customized cubehelix color scheme using `Palette.Cubehelix` and `Palette.Generative`.

`Palette.Cubehelix` is a good choice for charts & graphs because the produced colors have quite even visual intensity.

Designers often approach color not by picking one color at a time, but by describing the relationships between
the colors, e.g., "I want 4 colors that are equally spaced on the color wheel," or, "I want 10 colors that
are all of the same hue but with different lightnesses."

If you approach color like this, then you'll be interested in using `Palette.Generative`, which has
helpers like `square` (generates 4 evenly-spaced colors) and `monochromatic` (generates lovely
single-hue lists of colors).


## Mixing colors together

If you've used Photoshop, you may be familiar with color blending with functions
like `multiply`. If not, I recommend taking a look at the examples & playing until
you get a feel for what the functions do.


## Transparent colors

Work with alpha channel values/transparency/opacity.

```
import TransparentColor
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

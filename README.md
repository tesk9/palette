[![Build Status](https://travis-ci.org/tesk9/palette.svg?branch=master)](https://travis-ci.org/tesk9/palette)

Work with colors safely  and accessibly.

- Calculate color contrasts
- Use common web-color palettes
- Generate beautiful palettes programmatically.
- Blend and transform colors
- Use RGB, HSL, and hex colors interchangeably
- Modify opacity

## Getting started

### Creating colors

Create colors from RGB, HSL, and hex values.

```
import Color exposing (Color)


myOrangeyRed : Color
myOrangeyRed =
    Color.fromRGB ( 255, 80, 0 )


myTurquoiseIsh : Color
myTurquoiseIsh =
    Color.fromHSL (127, 50, 50)


myHex : Result String Color
myHex =
    Color.fromHexString "#ff9800"

```

### Accessibility

Use `Color.Contrast` to verify that your font size, boldness, and colors meet accessibility standards.

### Use static palettes

Use [X11](https://en.wikipedia.org/wiki/X11_color_names) and [Tango](http://tango.freedesktop.org/Tango_Icon_Theme_Guidelines#Color_Palette) colors by name:

```
import Color exposing (Color)
import Palette.X11 as X11 exposing (orangeRed, tomato, coral, darkOrange, orange)
import Palette.Tango as Tango exposing (butter1, butter2, butter3)

orangyReds : List Color
orangyReds =
    [ orangeRed, tomato, coral, darkOrange, orange ]


allTheButter : List Color
allTheButter =
    [ butter1, butter2, butter3 ]
```

### Generate palettes

Generate a customized cubehelix color scheme using `Palette.Cubehelix`.
These schemes are a good choice for charts & graphs because the produced colors have quite even visual intensity.

Alternatively, generate a palette with colors that pop:

Designers often approach color not by picking one color at a time, but by describing the relationships between
the colors, e.g., "I want 4 colors that are equally spaced on the color wheel," or, "I want 10 colors that
are all of the same hue but with different lightnesses."

If you approach color like this, then you'll be interested in using `Color.Generator`, which has
helpers like `square` (generates 4 evenly-spaced colors) and `monochromatic` (generates lovely
single-hue lists of colors).


### Mixing colors together

If you've used Photoshop, you may be familiar with color blending with functions
like `multiply`. If not, I recommend taking a lot at the examples & playing until
you get a feel for what the functions do.


### Transparent colors

Work with alpha channel values/transparency/opacity.

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

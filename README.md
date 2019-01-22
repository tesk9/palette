[![Build Status](https://travis-ci.org/tesk9/palette.svg?branch=master)](https://travis-ci.org/tesk9/palette)

Work with Colors in Elm.

This package makes working with RGB, HSL, and Hex colors easy, accessible, and safe.
Easily convert from one color system to another, blend and transform colors, and generate
beautiful palettes programmatically. Use named colors from common web color palettes, like X11 and Tango.

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

Use `Color.Contrast.sufficientContrast` to see if two colors can be used together given the accessibility standards
your project aims to meet and the font size and weight of your text.

Use `Color.Contrast.contrast` to calculate color contrast in general.

### Using palettes

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

You can also generate a customized cubehelix color scheme using `Palette.Cubehelix`, or by using `Color.Generator` helpers.

### Generating a palette

Designers often approach color not by picking one color at a time, but by describing the relationships between
the colors, e.g., "I want 4 colors that are equally spaced on the color wheel," or, "I want 10 colors that
are all of the same hue but with different lightnesses."

If you approach color like this, then you'll be interested in using the helpers in `Color.Generator`, which has
helpers like `square` (which generates 4 evenly-spaced colors) and `monochromatic` (which generates lovely
single-hue lists of colors).


### Mixing colors together

If you've used Photoshop, you may be familiar with color blending with functions
like `multiply`. If not, I recommend taking a lot at the examples & playing until
you get a feel for what the functions do.

### Working with contrast

Use `Color.Contrast` functions to verify that your font size, boldness, and color
meet accessibility standards.

## Developing & Contributing

Currently, `tesk9/palette` does not provide first-class alpha channel support (transparency).

Long term, I'm interested in exploring generating accessible palettes and validating
the accessibility of existing palettes.

Issues, bugs, and enhancement suggestions very welcome on the github repo.


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

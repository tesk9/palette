[![Build Status](https://travis-ci.org/tesk9/palette.svg?branch=master)](https://travis-ci.org/tesk9/palette)

Work with Colors in Elm.

This package makes working with RGB, HSL, and Hex colors easy, convenient, and safe.
Easily convert from one color system to another, blend and transform colors, and generate
beautiful palettes programmatically. Use named colors from common web color palettes, like X11.

Currently, `palette` does not provide first-class alpha channel support (transparency).

Long term, I'm interested in exploring generating accessible palettes and validating
the accessibility of existing palettes. Check out the `Color.Contrast` for more on accessibility.

Issues, bugs, and enhancement suggestions very welcome on the github repo.

## Getting started

You can view named colors in the `Palette` namespace, but sometimes you'll want to make your own
custom or user defined colors.

The library currently supports creating `Color`s from RGB values, HSL values, and hex values.

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

### Generating a palette

Suppose you want to use a three-color palette, and you know you want one of the colors to be red.
Maybe you want the palette to be comprised of evenly-spaced colors on the color wheel.

```
import Color exposing (Color)
import Color.Generator
import Palette.X11 exposing (red)

myPalette : (Color, Color, Color)
myPalette =
    let
        (color2, color3) =
            triadic red
    in
    (red, color2, color3)

```

Or maybe we want a monochromatic color scheme -- the various tints and lightnesses
available from a starting hue.

```
import Color exposing (Color)
import Color.Generator
import Palette.X11 exposing (red)


myPalette : List Color
myPalette =
    let
        stepSize =
            -- how many degrees of lightness apart each step should be
            10

    in
        Color.Generator.monochromatic stepSize red
```

### Mixing colors together

If you've used Photoshop, you may be familiar with color blending with functions
like `multiply`. If not, I recommend taking a lot at the examples & playing until
you get a feel for what the functions do.

### Working with contrast

Use `Color.Contrast` functions to verify that your font size, boldness, and color
meet accessibility standards.

## Developing & Contributing

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

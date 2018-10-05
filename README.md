Exploratory package (read: API very subject to change & breakage) for playing with different approaches to modeling and working with Color.

I'm interested in exploring generative accessible palettes, in addition to playing with validating accessibility of existing palettes.

## Getting started

Suppose you want to build a palette.

You might be thinking in terms of the color
wheel, and in terms of colors relationship to each other on that wheel.
Suppose we want to find 2 colors that are evenly spaced from each other on the color wheel.

```
import Color exposing (Color)
import Color.Generator

myPalette : (Color, Color, Color)
myPalette =
    let
        red =
            Color.fromHSL 0 100 50

        (color1, color2) =
            Color.triadic red
    in
        (red, color1, color2)
```

Or maybe we want a monochromatic color scheme -- the various tints and lightnesses
available from a starting hue.

```
import Color exposing (Color)
import Color.Generator

myPalette : List Color
myPalette =
    let
        red =
            Color.fromRGB ( 255, 0, 0 )

        stepSize =
            -- how many degrees of lightness apart each step should be
            10

    in
        Color.Generator.monochromatic stepSize red
```


## Developing

### Examples

```
cd examples
elm reactor
open http://localhost:8000/src/Main.elm
```

### Running tests

I couldn't get the tests working on travis ci properly :( But there are tests!

```
npm install
npm test
```

### Maybe TODOs

- What other common web palettes would be helpful to have available? are there others?
- Transparency -- rgba and hsla. worth adding?
- API -- other color formats & conversions?

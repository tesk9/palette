module Color.Contrast exposing (WCAGLevel(..), sufficientContrast, contrast)

{-| Use this module to determine whether colors may be used together.

@docs WCAGLevel, sufficientContrast, contrast

-}

import Color exposing (Color)


{-| Read more about levels of conformance at [WCAG](https://www.w3.org/TR/UNDERSTANDING-WCAG20/conformance.html#uc-levels-head).
-}
type WCAGLevel
    = AA
    | AAA


{-| For a given WCAG level, calculate whether two colors have enough contrast
with each other to be used together (e.g., as a background and text color combination).

To meet AA level sufficiently, [follow these standards](https://www.w3.org/WAI/WCAG21/quickref/?versions=2.0&showtechniques=143%2C146#contrast-minimum).
To meet AAA level sufficiently, [follow these standards](https://www.w3.org/WAI/WCAG21/quickref/?versions=2.0&showtechniques=143%2C146#contrast-enhanced).

TODO (consider this a headsup on likely API changes!):

  - Use named fontweights rather than numbers
  - Wrap fontsize with some constructors
  - Cassowary constraint solving..?

-}
sufficientContrast : WCAGLevel -> { fontSize : Float, fontWeight : Int } -> Color -> Color -> Bool
sufficientContrast wcagLevel { fontSize, fontWeight } color1 color2 =
    let
        colorContrast =
            contrast color1 color2
    in
    case wcagLevel of
        AA ->
            if (fontSize > 14 && fontWeight >= 700) || fontSize > 18 then
                colorContrast >= 3

            else
                colorContrast >= 4.5

        AAA ->
            if (fontSize > 14 && fontWeight >= 700) || fontSize > 18 then
                colorContrast >= 4.5

            else
                colorContrast >= 7


{-| Calculate the contrast between two colors.
-}
contrast : Color -> Color -> Float
contrast color1 color2 =
    let
        luminance1 =
            Color.luminance color1

        luminance2 =
            Color.luminance color2
    in
    if luminance1 > luminance2 then
        (luminance1 + 0.05) / (luminance2 + 0.05)

    else
        (luminance2 + 0.05) / (luminance1 + 0.05)

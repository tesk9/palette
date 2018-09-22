module Contrast exposing (WCAGLevel(..), sufficientContrast, contrast)

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

-}
sufficientContrast : WCAGLevel -> Float -> Int -> Color -> Color -> Bool
sufficientContrast wcagLevel fontSize fontWeight color1 color2 =
    case wcagLevel of
        AA ->
            if fontSize > 18 && fontWeight < 700 then
                contrast color1 color2
                    |> meetsOrExceedsRatio 3 1

            else
                contrast color1 color2
                    |> meetsOrExceedsRatio 4.5 1

        AAA ->
            if fontSize > 18 && fontWeight < 700 then
                contrast color1 color2
                    |> meetsOrExceedsRatio 4.5 1

            else
                contrast color1 color2
                    |> meetsOrExceedsRatio 7 1


meetsOrExceedsRatio : Float -> Float -> Float -> Bool
meetsOrExceedsRatio contrastValue int base =
    contrastValue >= (int / base)


{-| Calculate the contrast between two colors.
-}
contrast : Color -> Color -> Float
contrast color1 color2 =
    let
        luminance1 =
            luminance color1

        luminance2 =
            luminance color2
    in
    if luminance1 > luminance2 then
        (luminance1 + 0.05) / (luminance2 + 0.05)

    else
        (luminance2 + 0.05) / (luminance1 + 0.05)


{-| Luminance calculation adopted from <https://www.w3.org/TR/WCAG20-TECHS/G17.html>
-}
luminance : Color -> Float
luminance color =
    let
        ( rRaw, gRaw, bRaw ) =
            Color.toRGB color

        fromRGBValue raw =
            if (raw / 255) <= 0.03928 then
                (raw / 255) / 12.92

            else
                (((raw / 255) + 0.055) / 1.055) ^ 2.4
    in
    0.2126 * fromRGBValue rRaw + 0.7152 * fromRGBValue gRaw + 0.0722 * fromRGBValue bRaw

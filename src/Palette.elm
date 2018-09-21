module Palette exposing (Palette)

{-| Notes on color modeling:

<http://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/>
<http://changingminds.org/explanations/perception/visual/hsl.htm>


# HSL -- Hue, Saturation, Lightness/Luminosity/Luminance

Hue is degree on then color wheel:

  - 0 is red
  - 120 is green
  - 240 is blue
    Saturation is a percentage value; 100% is the full colour.
    Lightness/Luminosity/Luminance is also a percentage; 0% is dark (black), 100% is light (white), and 50% is the average.

Brightness is the perception of luminance.


# RGB luminance calculation

luminance = (0.2126 × red) + (0.7152 × green) + (0.0722 × blue)

Level AA (regular sized text) requires a minimum ratio of 4.5:1
Level AA (large sized text) requires a minimum ratio of 3:1
Level AAA (regular sized text) requires a minimum ratio of 7:1
Level AAA (large sized text) requires a minimum ratio of 4.5:1

-}


type Palette
    = Palette


type WCAGLevel
    = AA
    | AAA


sufficientContrast : WCAGLevel -> Float -> Int -> Float -> Float -> Bool
sufficientContrast wcagLevel fontSize fontWeight luminance1 luminance2 =
    case wcagLevel of
        AA ->
            if fontSize > 18 && fontWeight < 700 then
                contrast luminance1 luminance2
                    |> meetsOrExceedsRatio 3 1

            else
                contrast luminance1 luminance2
                    |> meetsOrExceedsRatio 4.5 1

        AAA ->
            if fontSize > 18 && fontWeight < 700 then
                contrast luminance1 luminance2
                    |> meetsOrExceedsRatio 4.5 1

            else
                contrast luminance1 luminance2
                    |> meetsOrExceedsRatio 7 1


meetsOrExceedsRatio : Float -> Float -> Float -> Bool
meetsOrExceedsRatio contrastValue int base =
    contrastValue >= (int / base)


{-| Luminance calculation adopted from <https://www.w3.org/TR/WCAG20-TECHS/G17.html>
-}
luminance : Float -> Float -> Float -> Float
luminance rRaw gRaw bRaw =
    let
        fromRGBValue raw =
            if (raw / 255) <= 0.03928 then
                (raw / 255) / 12.92

            else
                (((raw / 255) + 0.055) / 1.055) ^ 2.4
    in
    0.2126 * fromRGBValue rRaw + 0.7152 * fromRGBValue gRaw + 0.0722 * fromRGBValue bRaw


{-| luminance1 is the relative luminance of the lighter of the foreground or background colors,
and luminance2 is the relative luminance of the darker of the foreground or background colors.
-}
contrast : Float -> Float -> Float
contrast luminance1 luminance2 =
    (luminance1 + 0.05) / (luminance2 + 0.05)

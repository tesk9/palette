module SolidColor.Accessibility exposing
    ( Rating(..), meetsAA, meetsAAA
    , checkContrast
    , contrast
    )

{-|

@docs Rating, meetsAA, meetsAAA
@docs checkContrast
@docs contrast

[Ellie example](https://ellie-app.com/9jPV682wPLYa1)

-}

import SolidColor exposing (SolidColor)


{-| Read more about levels of conformance at [WCAG](https://www.w3.org/TR/UNDERSTANDING-WCAG20/conformance.html#uc-levels-head).
-}
type Rating
    = Inaccessible
    | AA
    | AAA


{-| -}
meetsAA : Rating -> Bool
meetsAA rating =
    case rating of
        Inaccessible ->
            False

        AA ->
            True

        AAA ->
            True


{-| -}
meetsAAA : Rating -> Bool
meetsAAA rating =
    case rating of
        Inaccessible ->
            False

        AA ->
            False

        AAA ->
            True


{-| Checks whether two colors have enough contrast with each other to be used together
(e.g., as a background and text color combination). Returns the WCAG Rating level.

To meet AA level sufficiently, [follow these standards](https://www.w3.org/WAI/WCAG21/quickref/?versions=2.0&showtechniques=143%2C146#contrast-minimum).
To meet AAA level sufficiently, [follow these standards](https://www.w3.org/WAI/WCAG21/quickref/?versions=2.0&showtechniques=143%2C146#contrast-enhanced).

-}
checkContrast :
    { fontSize : Float, fontWeight : Int }
    -> SolidColor
    -> SolidColor
    -> Rating
checkContrast font color1 color2 =
    if sufficientContrast AAA_ font color1 color2 then
        AAA

    else if sufficientContrast AA_ font color1 color2 then
        AA

    else
        Inaccessible


type WCAGLevel
    = AA_
    | AAA_


{-| -}
sufficientContrast : WCAGLevel -> { fontSize : Float, fontWeight : Int } -> SolidColor -> SolidColor -> Bool
sufficientContrast wcagLevel { fontSize, fontWeight } color1 color2 =
    let
        colorContrast =
            contrast color1 color2
    in
    case wcagLevel of
        AA_ ->
            if (fontSize > 14 && fontWeight >= 700) || fontSize > 18 then
                colorContrast >= 3

            else
                colorContrast >= 4.5

        AAA_ ->
            if (fontSize > 14 && fontWeight >= 700) || fontSize > 18 then
                colorContrast >= 4.5

            else
                colorContrast >= 7


{-| Calculate the contrast between two colors.
-}
contrast : SolidColor -> SolidColor -> Float
contrast color1 color2 =
    let
        luminance1 =
            SolidColor.luminance color1

        luminance2 =
            SolidColor.luminance color2
    in
    if luminance1 > luminance2 then
        (luminance1 + 0.05) / (luminance2 + 0.05)

    else
        (luminance2 + 0.05) / (luminance1 + 0.05)

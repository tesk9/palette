module Colour.Accessibility exposing
    ( Rating(..), meetsAA, meetsAAA
    , checkContrast
    , contrast
    )

{-|

@docs Rating, meetsAA, meetsAAA
@docs checkContrast
@docs contrast

-}

import Colour exposing (Colour)


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


{-| Checks whether two colours have enough contrast with each other to be used together
(e.g., as a background and text colour combination). Returns the WCAG Rating level.

To meet AA level sufficiently, [follow these standards](https://www.w3.org/WAI/WCAG21/quickref/?versions=2.0&showtechniques=143%2C146#contrast-minimum).
To meet AAA level sufficiently, [follow these standards](https://www.w3.org/WAI/WCAG21/quickref/?versions=2.0&showtechniques=143%2C146#contrast-enhanced).

-}
checkContrast :
    { fontSize : Float, fontWeight : Int }
    -> Colour
    -> Colour
    -> Rating
checkContrast font colour1 colour2 =
    if sufficientContrast AAA_ font colour1 colour2 then
        AAA

    else if sufficientContrast AA_ font colour1 colour2 then
        AA

    else
        Inaccessible


type WCAGLevel
    = AA_
    | AAA_


{-| -}
sufficientContrast : WCAGLevel -> { fontSize : Float, fontWeight : Int } -> Colour -> Colour -> Bool
sufficientContrast wcagLevel { fontSize, fontWeight } colour1 colour2 =
    let
        colourContrast =
            contrast colour1 colour2
    in
    case wcagLevel of
        AA_ ->
            if (fontSize > 14 && fontWeight >= 700) || fontSize > 18 then
                colourContrast >= 3

            else
                colourContrast >= 4.5

        AAA_ ->
            if (fontSize > 14 && fontWeight >= 700) || fontSize > 18 then
                colourContrast >= 4.5

            else
                colourContrast >= 7


{-| Calculate the contrast between two colours.
-}
contrast : Colour -> Colour -> Float
contrast colour1 colour2 =
    let
        luminance1 =
            Colour.luminance colour1

        luminance2 =
            Colour.luminance colour2
    in
    if luminance1 > luminance2 then
        (luminance1 + 0.05) / (luminance2 + 0.05)

    else
        (luminance2 + 0.05) / (luminance1 + 0.05)

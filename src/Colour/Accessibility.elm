module Colour.Accessibility exposing
    ( WCAGLevel(..)
    , Rating(..), meetsAA, meetsAAA
    , checkContrast
    , contrast
    )

{-|

@docs WCAGLevel

@docs Rating, meetsAA, meetsAAA
@docs checkContrast
@docs contrast

-}

import OpaqueColor exposing (OpaqueColor)


type WCAGLevel
    = AA_
    | AAA_


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
    -> OpaqueColor
    -> OpaqueColor
    -> Rating
checkContrast font color1 color2 =
    if sufficientContrast AAA_ font color1 color2 then
        AAA

    else if sufficientContrast AA_ font color1 color2 then
        AA

    else
        Inaccessible


{-| For a given WCAG level, calculate whether two colors have enough contrast
with each other to be used together (e.g., as a background and text color combination).

To meet AA level sufficiently, [follow these standards](https://www.w3.org/WAI/WCAG21/quickref/?versions=2.0&showtechniques=143%2C146#contrast-minimum).
To meet AAA level sufficiently, [follow these standards](https://www.w3.org/WAI/WCAG21/quickref/?versions=2.0&showtechniques=143%2C146#contrast-enhanced).

TODO (consider this a headsup on likely API changes!):

  - Use named fontweights rather than numbers
  - Wrap fontsize with some constructors
  - Cassowary constraint solving..?

See an example here: <https://ellie-app.com/3CgJZNMyxw3a1>.

-}
sufficientContrast : WCAGLevel -> { fontSize : Float, fontWeight : Int } -> OpaqueColor -> OpaqueColor -> Bool
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

See an example here: <https://ellie-app.com/3CgJZNMyxw3a1>.

-}
contrast : OpaqueColor -> OpaqueColor -> Float
contrast color1 color2 =
    let
        luminance1 =
            OpaqueColor.luminance color1

        luminance2 =
            OpaqueColor.luminance color2
    in
    if luminance1 > luminance2 then
        (luminance1 + 0.05) / (luminance2 + 0.05)

    else
        (luminance2 + 0.05) / (luminance1 + 0.05)

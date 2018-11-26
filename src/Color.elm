module Color exposing
    ( Color
    , fromHSL, toHSL, toHSLString
    , fromRGB, toRGB, toRGBString
    , fromHexString, toHexString
    , luminance
    )

{-|

@docs Color


## HSL values

HSL is short for hue, saturation, and lightness (or luminosity, or random other
L words depending on who you ask. Think "brightness", and you'll be on the right track).

You may be intuitively familiar with HSL color modeling if you've worked with a
color wheel before. It also may be a great place to start working with color if
you enjoyed playing with unit circles and polar coordinates in trigonometry.

![Representation of HSL values on a cylinder](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/HSL_color_solid_cylinder_saturation_gray.png/320px-HSL_color_solid_cylinder_saturation_gray.png)
(Image can be seen in context on the [HSL and HSV arcticle on Wikipedia](https://en.wikipedia.org/wiki/HSL_and_HSV). By HSL\_color\_solid\_cylinder.png: SharkDderivative work: SharkD  Talk - HSL\_color\_solid\_cylinder.png, CC BY-SA 3.0, <https://commons.wikimedia.org/w/index.php?curid=9801661>)

HSL models **hue** as a value on a circle. We can pick a hue by providing a degree.
We start at red -- meaning that we can get to red by saying that our hue is 0 degrees or
by saying that our hue is at 360 degrees. Green is at 90, teal is at 180, and
there's a lovely purple at 270.

**Saturation** is how much of the hue is present. When you see a hue of 0 degrees,
a saturation of 100%, and lightness of 50%, your reaction is going to be "Schnickeys! that's red!"
If you change the saturation to 0%, you'll see gray.

**Lightness** is brightness -- 100% is white and 0% is black.

@docs fromHSL, toHSL, toHSLString


### RGB values

RGB is short for red-green-blue. This representation of color specifies how much
red, green, and blue are in the color.

I found [this chart](https://en.wikipedia.org/wiki/HSL_and_HSV#/media/File:HSV-RGB-comparison.svg) really
helpful when thinking about how RGB colors work -- it shows red, green, and blue values as piecewise functions
against Hue values. The chart is actually aimed at describing the HSV color space, which is a little
different than the HSL color space, but it may be helpful for your brain too.

As you work with RGB colors, it may also be helpful to know that this color space is **additive**.

This means that if you add red, green, and blue together, you'll end up with white. The more
colors you add, the brighter the result.

This is different than what you may remember from painting in elementary school.
Paint, where you're mixing pigments together, is a **subtractive**
color space. Printing (CMYK color space) is also subtractive.

@docs fromRGB, toRGB, toRGBString


## Hex values

Hexadecimal colors actually use the same color space as RGB colors. The difference
between the two systems is in the base: RGB colors are base 10 and hex colors are base 16.
Hex colors are also additive and can also be thought of as a piecewise function.

You will need to use hex colors if you're working with an
[HTML input of type color](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color).

@docs fromHexString, toHexString


## Color properties

@docs luminance

-}

import Dict


{-| -}
type
    Color
    -- TODO: other models! conversions! as necessary.
    = HSL HSLValue
    | RGB RGBValue


{-| Internal representation of HSL used to enforce type safety.
-}
type HSLValue
    = HSLValue Float Float Float


{-| Internal representation of RGB used to enforce type safety.
-}
type RGBValue
    = RGBValue Float Float Float


{-| Build a new color based on HSL values.

    import Color exposing (Color)

    red : Color
    red =
        Color.fromHSL ( 0, 100, 50 )

The hue is specified in degrees, and uses modular arithmetic such that whether you
pass in `0`, `360`, or `-360`, you'll still end up with a red hue.

Saturation is a percentage value. It's clamped between 0 and 100 (inclusive).
Lightness is a percentage value. It's clamped between 0 and 100 (inclusive).

-}
fromHSL : ( Float, Float, Float ) -> Color
fromHSL ( hue, s, l ) =
    let
        hueInt =
            floor hue

        floatingHueValues =
            hue - toFloat hueInt

        hue360 =
            toFloat (modBy 360 hueInt)
    in
    HSL (HSLValue (hue360 + floatingHueValues) (clamp 0 100 s) (clamp 0 100 l))


{-| Extract the hue, saturation, and lightness values from an existing Color.
-}
toHSL : Color -> ( Float, Float, Float )
toHSL color =
    case color of
        HSL (HSLValue h s l) ->
            ( h, s, l )

        RGB rgbValues ->
            convertRGBToHSL rgbValues
                |> toHSL


{-| Get the HSL representation of a color as a `String`.

    import Color exposing (toHSLString)
    import Html exposing (p, text)
    import Html.Attributes exposing (style)
    import Palette.X11 exposing (red)

    view =
        p [ style "color" (toHSLString red) ]
            [ text "Wow! This sure looks red!" ]

-}
toHSLString : Color -> String
toHSLString color =
    let
        ( h, s, l ) =
            toHSL color
    in
    "hsl(" ++ String.fromFloat h ++ "," ++ String.fromFloat s ++ "%," ++ String.fromFloat l ++ "%)"


{-| Build a new color based on RGB values.

    import Color exposing (Color)

    red : Color
    red =
        Color.fromRGB ( 255, 0, 0 )

    green : Color
    green =
        Color.fromRGB ( 0, 255, 0 )

    blue : Color
    blue =
        Color.fromRGB ( 0, 0, 255 )

This function clamps each rgb value between 0 and 255 (inclusive).

-}
fromRGB : ( Float, Float, Float ) -> Color
fromRGB ( r, g, b ) =
    RGB (RGBValue (clamp 0 255 r) (clamp 0 255 g) (clamp 0 255 b))


{-| Extract the red, green, blue values from an existing Color.
-}
toRGB : Color -> ( Float, Float, Float )
toRGB color =
    case color of
        RGB (RGBValue r g b) ->
            ( r, g, b )

        HSL hslValues ->
            convertHSLToRGB hslValues
                |> toRGB


{-| Get the RGB representation of a color as a `String`.

    import Color exposing (toRGBString)
    import Html exposing (p, text)
    import Html.Attributes exposing (style)
    import Palette.X11 exposing (red)

    view =
        p [ style "color" (toRGBString red) ]
            [ text "Wow! This sure looks red!" ]

-}
toRGBString : Color -> String
toRGBString color =
    let
        ( r, g, b ) =
            toRGB color
    in
    "rgb(" ++ String.fromFloat r ++ "," ++ String.fromFloat g ++ "," ++ String.fromFloat b ++ ")"


{-| Build a new color from a hex string. Supports lowercase or uppercase strings.

    (Color.fromHexString "#FFDD00" == Color.fromHexString "#FD0")
        && (Color.fromHexString "#FFDD00" == Color.fromHexString "#ffdd00")

-}
fromHexString : String -> Result String Color
fromHexString colorString =
    let
        colorList =
            String.dropLeft 1 colorString
                |> String.toList
                |> List.filterMap fromHexSymbol
    in
    case colorList of
        r1 :: r0 :: g1 :: g0 :: b1 :: b0 :: [] ->
            ( r1 * 16 + r0 |> toFloat
            , g1 * 16 + g0 |> toFloat
            , b1 * 16 + b0 |> toFloat
            )
                |> fromRGB
                |> Ok

        r :: g :: b :: [] ->
            ( r * 16 + r |> toFloat
            , g * 16 + g |> toFloat
            , b * 16 + b |> toFloat
            )
                |> fromRGB
                |> Ok

        _ ->
            Err ("fromHexString could not convert " ++ colorString ++ " to a Color.")


{-| Get the Hex representation of a color as a `String`.

    import Color exposing (toHexString)
    import Html exposing (p, text)
    import Html.Attributes exposing (type_, value)
    import Palette.X11 exposing (red)

    view =
        Html.input
            [ type_ "color"
            , value (toHexString red)
            ]
            []

Note: this function will always return a string in the form "#RRGGBB". It will
not return shortened values (e.g., "#RGB").

If you want or need this functionality, please make an issue for it on the
github repo for this library.

-}
toHexString : Color -> String
toHexString color =
    let
        ( r, g, b ) =
            toRGB color
    in
    "#" ++ decToHex r ++ decToHex g ++ decToHex b


{-| Luminance calculation adopted from <https://www.w3.org/TR/WCAG20-TECHS/G17.html>

Luminance describes the perceived brightness of a color. You're unlikely to need
to use this function directly. Maybe something in `Color.Contrast` or `Color.Generator`
meets your needs instead?

-}
luminance : Color -> Float
luminance color =
    let
        ( rRaw, gRaw, bRaw ) =
            toRGB color

        red =
            rRaw
                |> toSRBG
                |> fromSRGB

        green =
            gRaw
                |> toSRBG
                |> fromSRGB

        blue =
            bRaw
                |> toSRBG
                |> fromSRGB

        toSRBG rgb8bit =
            rgb8bit / 255

        fromSRGB srgb =
            if srgb <= 0.03928 then
                srgb / 12.92

            else
                ((srgb + 0.055) / 1.055) ^ 2.4
    in
    (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)



-- CONVERSIONS


{-| -}
convertRGBToHSL : RGBValue -> Color
convertRGBToHSL (RGBValue r255 g255 b255) =
    let
        ( r, g, b ) =
            ( r255 / 255, g255 / 255, b255 / 255 )

        maximum =
            max (max r g) b

        minimum =
            min (min r g) b

        chroma =
            maximum - minimum

        hue =
            if chroma == 0 then
                --Actually undefined, but this is a typical representation
                0

            else if maximum == r then
                60 * (g - b) / chroma

            else if maximum == g then
                60 * ((b - r) / chroma + 2)

            else
                60 * ((r - g) / chroma + 4)

        lightness =
            (minimum + maximum) / 2

        saturation =
            if lightness == 1 || lightness == 0 then
                0

            else
                chroma / (1 - abs (2 * lightness - 1))
    in
    fromHSL
        ( hue
        , saturation * 100
        , lightness * 100
        )


convertHSLToRGB : HSLValue -> Color
convertHSLToRGB (HSLValue hue360 saturationPercent lightnessPercent) =
    let
        saturation =
            saturationPercent / 100

        lightness =
            lightnessPercent / 100

        chroma =
            (1 - abs (2 * lightness - 1)) * saturation

        hueIsBetween lowerBound upperBound =
            lowerBound <= hue360 && hue360 <= upperBound

        zigUp xIntercept =
            chroma * (hue360 - xIntercept) / 60

        zigDown xIntercept =
            -1 * zigUp xIntercept

        ( r, g, b ) =
            if hueIsBetween 0 60 then
                ( chroma, zigUp 0, 0 )

            else if hueIsBetween 60 120 then
                ( zigDown 120, chroma, 0 )

            else if hueIsBetween 120 180 then
                ( 0, chroma, zigUp 120 )

            else if hueIsBetween 180 240 then
                ( 0, zigDown 240, chroma )

            else if hueIsBetween 240 300 then
                ( zigUp 240, 0, chroma )

            else
                ( chroma, 0, zigDown 360 )

        lightnessModifier =
            lightness - chroma / 2
    in
    fromRGB
        ( (r + lightnessModifier) * 255
        , (g + lightnessModifier) * 255
        , (b + lightnessModifier) * 255
        )



{- Hex/Dec lookup tables -}


decToHex : Float -> String
decToHex c =
    let
        nextValue ( dec, hex ) =
            if dec == 0 then
                hex

            else
                nextValue
                    ( dec // 16
                    , getHexSymbol (remainderBy 16 dec) ++ hex
                    )
    in
    String.padLeft 2 '0' (nextValue ( round c, "" ))


fromHexSymbol : Char -> Maybe Int
fromHexSymbol m =
    let
        decValues =
            Dict.fromList
                [ ( '0', 0 )
                , ( '1', 1 )
                , ( '2', 2 )
                , ( '3', 3 )
                , ( '4', 4 )
                , ( '5', 5 )
                , ( '6', 6 )
                , ( '7', 7 )
                , ( '8', 8 )
                , ( '9', 9 )
                , ( 'A', 10 )
                , ( 'B', 11 )
                , ( 'C', 12 )
                , ( 'D', 13 )
                , ( 'E', 14 )
                , ( 'F', 15 )
                ]
    in
    Dict.get (Char.toUpper m) decValues


getHexSymbol : Int -> String
getHexSymbol m =
    let
        hexValues =
            Dict.fromList
                [ ( 0, "0" )
                , ( 1, "1" )
                , ( 2, "2" )
                , ( 3, "3" )
                , ( 4, "4" )
                , ( 5, "5" )
                , ( 6, "6" )
                , ( 7, "7" )
                , ( 8, "8" )
                , ( 9, "9" )
                , ( 10, "A" )
                , ( 11, "B" )
                , ( 12, "C" )
                , ( 13, "D" )
                , ( 14, "E" )
                , ( 15, "F" )
                ]
    in
    Dict.get m hexValues
        |> Maybe.withDefault "0"

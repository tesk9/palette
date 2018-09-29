module Color exposing
    ( Color
    , fromHSL, toHSL, toHSLString
    , fromRGB, toRGB, toRGBString
    , luminance
    )

{-|

@docs Color


## Working with `Color`s


### HSL values

HSL is short for hue, saturation, and lightness (or luminosity, or random other
L words depending on who you ask. Think "brightness", and you'll be on the right track).

You may be intuitively familiar with HSL color modeling if you've worked with a
color wheel before. It also may be a great place to start working with color if
you enjoyed playing with unit circles and polar coordinates in trigonometry.

HSL models hues as values on a circle. We can pick a hue by providing a degree.
We start at red -- meaning that we can get to red by saying that our hue is 0 degrees or
by saying that our hue is at 360 degrees. Green is at 90, teal is at 180, and
there's a lovely purple is at 270.

Saturation is how much of the hue is present. If the saturation is 100% (and the lightness is
a middling value) then you'll recognize the hue immediately. When you see a hue of 0 degrees,
a saturation of 100%, and lightness of 50%, your reaction is going to be "Schnickeys! that's red!"
If the saturation where to change to 0%, you'd see gray.

Lightness is brightness -- 100% is white and 0% is black, no matter the hue or saturation.

@docs fromHSL, toHSL, toHSLString


### RGB values

RGB is short for red-green-blue. This representation of color specifies how much
red, green, and blue are in the color.

@docs fromRGB, toRGB, toRGBString


## Color properties

@docs luminance

-}


type
    Color
    -- TODO: other models! conversions! as necessary.
    = HSL Float Float Float
    | RGB Float Float Float


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
    --TODO: fix the modular arithmetic here
    HSL hue (clamp 0 100 s) (clamp 0 100 l)


{-| Extract the hue, saturation, and lightness values from an existing Color.
-}
toHSL : Color -> ( Float, Float, Float )
toHSL color =
    case color of
        RGB r g b ->
            --TODO: implementation!
            ( 0, 0, 0 )

        HSL h s l ->
            ( h, s, l )


{-| Get the HSL representation of a color as a `String`.
-}
toHSLString : Color -> String
toHSLString color =
    let
        ( h, s, l ) =
            toHSL color
    in
    "hsl(" ++ String.fromFloat h ++ "," ++ String.fromFloat s ++ "," ++ String.fromFloat l ++ ")"


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
    RGB (clamp 0 255 r) (clamp 0 255 g) (clamp 0 255 b)


{-| Extract the red, green, blue values from an existing Color.
-}
toRGB : Color -> ( Float, Float, Float )
toRGB color =
    case color of
        RGB r g b ->
            ( r, g, b )

        HSL h s l ->
            --TODO: implementation
            ( 0, 0, 0 )


{-| Get the RGB representation of a color as a `String`.
-}
toRGBString : Color -> String
toRGBString color =
    let
        ( r, g, b ) =
            toRGB color
    in
    "rgb(" ++ String.fromFloat r ++ "," ++ String.fromFloat g ++ "," ++ String.fromFloat b ++ ")"


{-| Luminance calculation adopted from <https://www.w3.org/TR/WCAG20-TECHS/G17.html>
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

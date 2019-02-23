module Internal.Color exposing
    ( Color
    , fromHSL, toHSL
    , fromRGB, toRGB
    , fromHexString, toHex
    )

{-|

@docs Color
@docs fromHSL, toHSL
@docs fromRGB, toRGB
@docs fromHexString, toHex

-}

import Dict


type Color
    = HSL HSLValue
    | RGB RGBValue


type HSLValue
    = HSLValue Float Float Float


type RGBValue
    = RGBValue Float Float Float


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


toHSL : Color -> ( Float, Float, Float )
toHSL color =
    case color of
        HSL (HSLValue h s l) ->
            ( h, s, l )

        RGB rgbValues ->
            convertRGBToHSL rgbValues
                |> toHSL


fromRGB : ( Float, Float, Float ) -> Color
fromRGB ( r, g, b ) =
    RGB (RGBValue (clamp 0 255 r) (clamp 0 255 g) (clamp 0 255 b))


toRGB : Color -> ( Float, Float, Float )
toRGB color =
    case color of
        RGB (RGBValue r g b) ->
            ( r, g, b )

        HSL hslValues ->
            convertHSLToRGB hslValues
                |> toRGB



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


fromHexString : String -> Maybe Color
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
                |> Just

        r :: g :: b :: [] ->
            ( r * 16 + r |> toFloat
            , g * 16 + g |> toFloat
            , b * 16 + b |> toFloat
            )
                |> fromRGB
                |> Just

        _ ->
            Nothing


toHex : Color -> ( String, String, String )
toHex color =
    let
        ( r, g, b ) =
            toRGB color
    in
    ( decToHex r, decToHex g, decToHex b )



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

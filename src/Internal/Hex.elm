module Internal.Hex exposing (fromString, toString)

import Dict


type alias Channels =
    { red : Float, green : Float, blue : Float, alpha : Float }


fromString : String -> Maybe Channels
fromString colorString =
    let
        colorList =
            colorString
                |> String.toList
                |> List.filterMap fromHexSymbol
    in
    case colorList of
        r1 :: r0 :: g1 :: g0 :: b1 :: b0 :: a1 :: a0 :: [] ->
            hexWithAlpha ( r1, r0 ) ( g1, g0 ) ( b1, b0 ) (Just ( a1, a0 ))
                |> Just

        r1 :: r0 :: g1 :: g0 :: b1 :: b0 :: [] ->
            hexWithAlpha ( r1, r0 ) ( g1, g0 ) ( b1, b0 ) Nothing
                |> Just

        r :: g :: b :: a :: [] ->
            hexWithAlpha ( r, r ) ( g, g ) ( b, b ) (Just ( a, a ))
                |> Just

        r :: g :: b :: [] ->
            hexWithAlpha ( r, r ) ( g, g ) ( b, b ) Nothing
                |> Just

        _ ->
            Nothing


hexWithAlpha :
    ( Int, Int )
    -> ( Int, Int )
    -> ( Int, Int )
    -> Maybe ( Int, Int )
    -> Channels
hexWithAlpha rs gs bs aa =
    let
        fromHex : ( Int, Int ) -> Float
        fromHex ( a, b ) =
            toFloat (a * 16 + b)
    in
    { red = fromHex rs
    , green = fromHex gs
    , blue = fromHex bs
    , alpha =
        -- Default to opaque
        Maybe.map fromHex aa |> Maybe.withDefault 1.0
    }


toString : Channels -> String
toString ({ alpha } as values) =
    if 1.0 == alpha then
        toStringWithoutOpacity values

    else
        toStringWithOpacity values


toStringWithoutOpacity : Channels -> String
toStringWithoutOpacity { red, green, blue } =
    "#" ++ decToHex red ++ decToHex green ++ decToHex blue


toStringWithOpacity : Channels -> String
toStringWithOpacity { red, green, blue, alpha } =
    "#" ++ decToHex red ++ decToHex green ++ decToHex blue ++ decToHex (alpha * 255)



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

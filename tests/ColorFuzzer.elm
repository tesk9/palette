module ColorFuzzer exposing
    ( hexStringOfLength
    , hslColor
    , hslValues
    , rgbColor
    , rgbValues
    )

import Dict exposing (Dict)
import Fuzz exposing (Fuzzer)
import Random exposing (Generator)
import Shrink
import SolidColor exposing (SolidColor)


rgbColor : Fuzzer SolidColor
rgbColor =
    Fuzz.map SolidColor.fromRGB rgbValues


rgbValues : Fuzzer ( Float, Float, Float )
rgbValues =
    triple (Fuzz.intRange 0 255) (Fuzz.intRange 0 255) (Fuzz.intRange 0 255)


hslColor : Fuzzer SolidColor
hslColor =
    Fuzz.map SolidColor.fromHSL hslValues


hslValues : Fuzzer ( Float, Float, Float )
hslValues =
    triple (Fuzz.intRange 0 359) (Fuzz.intRange 0 100) (Fuzz.intRange 0 100)


triple : Fuzzer Int -> Fuzzer Int -> Fuzzer Int -> Fuzzer ( Float, Float, Float )
triple =
    Fuzz.map3 (\a b c -> ( toFloat a, toFloat b, toFloat c ))


hexStringOfLength : Int -> Fuzzer String
hexStringOfLength listLength =
    let
        getChar : Int -> Maybe Char
        getChar index =
            Dict.get index hexChars

        asString : List Int -> String
        asString =
            List.filterMap getChar
                >> List.map String.fromChar
                >> String.join ""
    in
    Fuzz.custom
        (Random.list listLength (Random.int 0 15)
            |> Random.map (\l -> "#" ++ asString l)
        )
        Shrink.noShrink


hexChars : Dict Int Char
hexChars =
    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' ]
        |> List.indexedMap (\i v -> ( i, v ))
        |> Dict.fromList

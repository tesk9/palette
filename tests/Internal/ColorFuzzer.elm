module Internal.ColorFuzzer exposing (hexStringOfLength, hslValues)

import Dict exposing (Dict)
import Fuzz exposing (Fuzzer)
import Internal.Color exposing (Color)
import Random exposing (Generator)
import Shrink


hslValues : Fuzzer ( Float, Float, Float )
hslValues =
    -- This fuzzer doesn't include all possible values for the saturation
    -- and lightness. This is because things get slightly funky with black
    -- and white.
    -- E.g., HSL(0,0,0) and HSL(230,0,0) will both be identically black.
    -- Converted to rgb, they're both (0,0,0)
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

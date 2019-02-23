module Internal.ColorFuzzer exposing (hexStringOfLength)

import Dict exposing (Dict)
import Fuzz exposing (Fuzzer)
import Internal.Color exposing (Color)
import Random exposing (Generator)
import Shrink


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

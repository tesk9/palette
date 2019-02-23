module Internal.ColorFuzzer exposing (hexString, hexStringOfLength)

import Dict exposing (Dict)
import Fuzz exposing (Fuzzer)
import Internal.Color exposing (Color)
import Random exposing (Generator)
import Shrink


hexString : Fuzzer String
hexString =
    Fuzz.oneOf
        [ hexStringOfLength 3
        , hexStringOfLength 6
        ]


hexStringOfLength : Int -> Fuzzer String
hexStringOfLength l =
    Fuzz.custom (hexGenerator l) Shrink.noShrink


hexGenerator : Int -> Generator String
hexGenerator listLength =
    Random.list listLength (Random.int 0 15)
        |> Random.map
            (\l ->
                "#" ++ String.join "" (List.filterMap getCharString l)
            )


hexCharFuzzer : Fuzzer Char
hexCharFuzzer =
    Dict.values hexChars
        |> List.map Fuzz.constant
        |> Fuzz.oneOf


getCharString : Int -> Maybe String
getCharString index =
    Maybe.map String.fromChar (Dict.get index hexChars)


hexChars : Dict Int Char
hexChars =
    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' ]
        |> List.indexedMap (\i v -> ( i, v ))
        |> Dict.fromList

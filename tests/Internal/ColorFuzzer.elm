module Internal.ColorFuzzer exposing (hexStringFuzzer)

import Fuzz exposing (Fuzzer)


hexStringFuzzer : Fuzzer String
hexStringFuzzer =
    Fuzz.list hexCharFuzzer
        |> Fuzz.map (\charList -> "#" ++ String.fromList charList)


hexCharFuzzer : Fuzzer Char
hexCharFuzzer =
    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' ]
        |> List.map Fuzz.constant
        |> Fuzz.oneOf

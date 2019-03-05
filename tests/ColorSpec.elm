module ColorSpec exposing (colorSpec, conversionsSpec, luminanceSuite)

import Color exposing (Color)
import Color.Generator
import ColorFuzzer as ColorFuzz exposing (hexStringOfLength)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Opacity
import Palette.X11 exposing (..)
import Test exposing (..)


colorSpec : Test
colorSpec =
    describe "Color"
        [ describe "to and from a Color"
            [ test "from RGB to RGB" <|
                \_ ->
                    Color.fromRGB ( -10, 123, 300 )
                        |> expectRGB ( 0, 123, 255 )
            , test "from HSL to HSL" <|
                \_ ->
                    Color.fromHSL ( -10, 123, -10 )
                        |> expectHSL ( 350, 100, 0 )
            , describe "Hex"
                [ test "from Hex with bad values" <|
                    \_ ->
                        Color.fromHexString "#FFDG00"
                            |> Expect.err
                , test "from lowercase Hex to Hex" <|
                    \_ ->
                        Color.fromHexString "#d3e700"
                            |> expectHex "#D3E700"
                , test "from Hex to Hex" <|
                    \_ ->
                        Color.fromHexString "#FFD700"
                            |> expectHex "#FFD700"
                , fuzz (hexStringOfLength 4) "Short hex with transparency" <|
                    \hex ->
                        Expect.ok (Color.fromHexString hex)
                , fuzz (hexStringOfLength 8) "Long hex with transparency" <|
                    \hex ->
                        Expect.ok (Color.fromHexString hex)
                , fuzz (hexStringOfLength 3) "Short hex and long hex match" <|
                    \hex ->
                        let
                            fullLengthHexString =
                                String.toList hex
                                    |> List.concatMap (\v -> [ v, v ])
                                    |> String.fromList
                                    |> String.dropLeft 1
                        in
                        Color.fromHexString hex
                            |> expectHex fullLengthHexString
                , fuzz (hexStringOfLength 6) "Long hex succeeds" <|
                    \hex ->
                        Color.fromHexString hex
                            |> expectHex hex
                ]
            ]
        , describe "to a String" <|
            let
                transparentPink =
                    Color.fromRGB ( 255, 0, 255 )
            in
            [ test "toRGBString" <|
                \_ ->
                    transparentPink
                        |> Color.toRGBString
                        |> Expect.equal "rgb(255,0,255)"
            , test "toHSLString" <|
                \_ ->
                    transparentPink
                        |> Color.toHSLString
                        |> Expect.equal "hsl(300,100%,50%)"
            , test "toHexString" <|
                \_ ->
                    transparentPink
                        |> Color.toHexString
                        |> Expect.equal "#FF00FF"
            ]
        , describe "equality and equivalence"
            [ test "(==) does not properly compare color values across color spaces" <|
                \_ ->
                    Color.fromRGB ( 255, 0, 0 )
                        == Color.fromHSL ( 0, 100, 50 )
                        |> Expect.false "(==) compared color values unexpectedly"
            , test "(==) does not properly compare repeated modelings of the same color" <|
                \_ ->
                    -- Both results are black! however (==) won't compare them properly.
                    Color.fromHSL ( 3, 50, 0 )
                        == Color.fromHSL ( 45, 50, 0 )
                        |> Expect.false "(==) compared color values unexpectedly"
            , describe "equals"
                [ test "when colors are identical, return true" <|
                    \_ ->
                        Color.fromHSL ( 0, 100, 50 )
                            |> Color.equals (Color.fromRGB ( 255, 0, 0 ))
                            |> Expect.true "Calling `equals` on identical colors failed"
                , test "when colors are not identical, return false" <|
                    \_ ->
                        Color.fromHSL ( 0, 100, 51 )
                            |> Color.equals (Color.fromRGB ( 255, 0, 0 ))
                            |> Expect.false "Calling `equals` on disparate colors failed"
                ]
            ]
        ]


luminanceSuite : Test
luminanceSuite =
    describe "luminance"
        [ test "white is very bright" <|
            \_ ->
                white
                    |> Color.luminance
                    |> floatEqual 1
        , test "gray is middlingly bright" <|
            \_ ->
                gray
                    |> Color.luminance
                    |> floatEqual 0.215
        , test "black is not very bright" <|
            \_ ->
                black
                    |> Color.luminance
                    |> floatEqual 0
        ]


floatEqual : Float -> Float -> Expectation
floatEqual =
    Expect.within (Expect.Absolute 0.01)


{-| This exists mostly to make float equality checks nicer.
-}
expectRGB : ( Int, Int, Int ) -> Color -> Expectation
expectRGB expected color =
    let
        ( r, g, b ) =
            Color.toRGB color
    in
    Expect.equal ( round r, round g, round b ) expected


{-| This exists mostly to make float equality checks nicer.
-}
expectHSL : ( Int, Int, Int ) -> Color -> Expectation
expectHSL expected color =
    let
        ( r, g, b ) =
            Color.toHSL color
    in
    Expect.equal ( round r, round g, round b ) expected


expectHex : String -> Result String Color -> Expectation
expectHex expected colorResult =
    case colorResult of
        Ok got ->
            Expect.equal expected (Color.toHexString got)

        Err err ->
            Expect.fail ("Could not parse color string: \n" ++ err)


conversionsSpec : Test
conversionsSpec =
    describe "Conversions & channel values"
        [ describe "toHSL"
            [ describe "from RGB color"
                [ test "black" <|
                    \_ ->
                        Color.fromRGB ( 0, 0, 0 )
                            |> Color.toHSL
                            |> expectTripleEquals ( 0, 0, 0 )
                , test "white" <|
                    \_ ->
                        Color.fromRGB ( 255, 255, 255 )
                            |> Color.toHSL
                            |> expectTripleEquals ( 0, 0, 100 )
                , test "red" <|
                    \_ ->
                        Color.fromRGB ( 255, 0, 0 )
                            |> Color.toHSL
                            |> expectTripleEquals ( 0, 100, 50 )
                , test "green" <|
                    \_ ->
                        Color.fromRGB ( 0, 128, 0 )
                            |> Color.toHSL
                            |> expectTripleEquals ( 120, 100, 25 )
                ]
            , describe "from HSL color"
                [ test "black" <|
                    \_ ->
                        Color.fromHSL ( 0, 0, 0 )
                            |> Color.toHSL
                            |> expectTripleEquals ( 0, 0, 0 )
                ]
            ]
        , describe "toRGB"
            [ describe "from RGB color"
                [ test "black" <|
                    \_ ->
                        Color.fromRGB ( 0, 0, 0 )
                            |> Color.toRGB
                            |> expectTripleEquals ( 0, 0, 0 )
                ]
            , describe "from HSL color"
                [ test "black" <|
                    \_ ->
                        Color.fromHSL ( 0, 0, 0 )
                            |> Color.toRGB
                            |> expectTripleEquals ( 0, 0, 0 )
                , test "white" <|
                    \_ ->
                        Color.fromHSL ( 0, 0, 100 )
                            |> Color.toRGB
                            |> expectTripleEquals ( 255, 255, 255 )
                , test "red" <|
                    \_ ->
                        Color.fromHSL ( 0, 100, 50 )
                            |> Color.toRGB
                            |> expectTripleEquals ( 255, 0, 0 )
                , test "green" <|
                    \_ ->
                        Color.fromHSL ( 120, 100, 25 )
                            |> Color.toRGB
                            |> expectTripleEquals ( 0, 128, 0 )
                ]
            ]
        , fuzz ColorFuzz.rgbValues "from RGB to HSL and back to RGB again" <|
            \color ->
                let
                    operations =
                        Color.fromRGB
                            >> Color.toHSL
                            >> Color.fromHSL
                            >> Color.toRGB

                    rgbName =
                        Color.toRGBString (Color.fromRGB color)
                in
                expectTripleEquals color (operations color)
        , fuzz ColorFuzz.hslValues "from HSL to RGB and back to HSL again" <|
            \(( _, s, l ) as color) ->
                let
                    operations =
                        Color.fromHSL
                            >> Color.toRGB
                            >> Color.fromRGB
                            >> Color.toHSL

                    hslName =
                        Color.toHSLString (Color.fromHSL color)
                in
                if l == 0 then
                    -- This is black, which has more representations in HSL space
                    -- than in RGB space.
                    expectTripleEquals ( 0, 0, 0 ) (operations color)

                else if l == 100 then
                    -- This is white, which has more representations in HSL space
                    -- than in RGB space.
                    expectTripleEquals ( 0, 0, 100 ) (operations color)

                else if s == 0 then
                    -- This is a fully-desaturated gray. It also has more representations
                    -- in HSL space than in RGB space.
                    expectTripleEquals ( 0, 0, l ) (operations color)

                else
                    expectTripleEquals color (operations color)
        , fuzz (ColorFuzz.hexStringOfLength 6) "from Hex to RGB and back to Hex again" <|
            \c ->
                Color.fromHexString c
                    |> Result.map Color.toRGB
                    |> Result.map (Color.fromRGB >> Color.toHexString)
                    |> Expect.equal (Ok c)
        ]


expectTripleEquals : ( Float, Float, Float ) -> ( Float, Float, Float ) -> Expectation
expectTripleEquals expected actual =
    Expect.equal (roundTriple actual) (roundTriple expected)


roundTriple : ( Float, Float, Float ) -> ( Int, Int, Int )
roundTriple ( a, b, c ) =
    ( round a, round b, round c )

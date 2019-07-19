module ColorSpec exposing
    ( colorSpec
    , conversionsSpec
    , highContrastSuite
    , invertSuite
    , luminanceSuite
    )

import Color exposing (Color)
import Color.Accessibility
import ColorFuzzer exposing (hexStringOfLength)
import Expect exposing (Expectation)
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
                        Color.fromHex "#FFDG00"
                            |> Expect.err
                , test "from lowercase Hex to Hex" <|
                    \_ ->
                        Color.fromHex "#d3e700"
                            |> expectHex "#D3E700"
                , test "from Hex to Hex" <|
                    \_ ->
                        Color.fromHex "#FFD700"
                            |> expectHex "#FFD700"
                , fuzz (hexStringOfLength 4) "Short hex with transparency" <|
                    \hex ->
                        Expect.ok (Color.fromHex hex)
                , fuzz (hexStringOfLength 8) "Long hex with transparency" <|
                    \hex ->
                        Expect.ok (Color.fromHex hex)
                , fuzz (hexStringOfLength 3) "Short hex and long hex match" <|
                    \hex ->
                        let
                            fullLengthHexString =
                                String.toList hex
                                    |> List.concatMap (\v -> [ v, v ])
                                    |> String.fromList
                                    |> String.dropLeft 1
                        in
                        Color.fromHex hex
                            |> expectHex fullLengthHexString
                , fuzz (hexStringOfLength 6) "Long hex succeeds" <|
                    \hex ->
                        Color.fromHex hex
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
            , test "toHex" <|
                \_ ->
                    transparentPink
                        |> Color.toHex
                        |> Expect.equal "#FF00FF"
            ]
        ]


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
        , fuzz ColorFuzzer.rgbValues "from RGB to HSL and back to RGB again" <|
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
        , fuzz ColorFuzzer.hslValues "from HSL to RGB and back to HSL again" <|
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
        , fuzz (ColorFuzzer.hexStringOfLength 6) "from Hex to RGB and back to Hex again" <|
            \c ->
                Color.fromHex c
                    |> Result.map Color.toRGB
                    |> Result.map (Color.fromRGB >> Color.toHex)
                    |> Expect.equal (Ok c)
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


highContrastSuite : Test
highContrastSuite =
    let
        grays : List ( Color, String )
        grays =
            [ ( gainsboro, "gainsboro" )
            , ( lightGray, "lightGray" )
            , ( silver, "silver" )
            , ( darkGray, "darkGray" )
            , ( gray, "gray" )
            , ( dimGray, "dimGray" )
            , ( lightSlateGray, "lightSlateGray" )
            , ( slateGray, "slateGray" )
            , ( darkSlateGray, "darkSlateGray" )
            , ( black, "black" )
            ]
    in
    describe "highContrast"
        [ describe "black and white"
            [ test "highContrast black == white" <|
                \_ ->
                    expectColorsEqual (Color.highContrast black) white
            , test "highContrast white == black" <|
                \_ ->
                    expectColorsEqual (Color.highContrast white) black
            , describe "highContrast grays"
                (List.map
                    (\( color, name ) ->
                        test name <|
                            \_ ->
                                color
                                    |> Color.highContrast
                                    |> Color.Accessibility.contrast color
                                    |> Expect.greaterThan 4.5
                    )
                    grays
                )
            ]
        ]


invertSuite : Test
invertSuite =
    describe "invert"
        [ describe "black and white"
            [ test "invert black == white" <|
                \_ ->
                    expectColorsEqual (Color.invert black) white
            , test "invert white == black" <|
                \_ ->
                    expectColorsEqual (Color.invert white) black
            ]
        ]



--Test helpers


floatEqual : Float -> Float -> Expectation
floatEqual =
    Expect.within (Expect.Absolute 0.1)


gray : Color
gray =
    Color.fromRGB ( 118, 118, 118 )


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
            Expect.equal expected (Color.toHex got)

        Err err ->
            Expect.fail ("Could not parse color string: \n" ++ err)


expectColorsEqual : Color -> Color -> Expectation
expectColorsEqual a b =
    Expect.equal (Color.toRGBString a) (Color.toRGBString b)


expectTripleEquals : ( Float, Float, Float ) -> ( Float, Float, Float ) -> Expectation
expectTripleEquals expected actual =
    Expect.equal (roundTriple actual) (roundTriple expected)


roundTriple : ( Float, Float, Float ) -> ( Int, Int, Int )
roundTriple ( a, b, c ) =
    ( round a, round b, round c )

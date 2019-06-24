module ColourSpec exposing
    ( colourSpec
    , conversionsSpec
    , highContrastSuite
    , invertSuite
    , luminanceSuite
    )

import Colour exposing (Colour)
import Colour.Accessibility
import ColourFuzzer exposing (hexStringOfLength)
import Expect exposing (Expectation)
import Palette.X11 exposing (..)
import Test exposing (..)


colourSpec : Test
colourSpec =
    describe "Colour"
        [ describe "to and from a Colour"
            [ test "from RGB to RGB" <|
                \_ ->
                    Colour.fromRGB ( -10, 123, 300 )
                        |> expectRGB ( 0, 123, 255 )
            , test "from HSL to HSL" <|
                \_ ->
                    Colour.fromHSL ( -10, 123, -10 )
                        |> expectHSL ( 350, 100, 0 )
            , describe "Hex"
                [ test "from Hex with bad values" <|
                    \_ ->
                        Colour.fromHex "#FFDG00"
                            |> Expect.err
                , test "from lowercase Hex to Hex" <|
                    \_ ->
                        Colour.fromHex "#d3e700"
                            |> expectHex "#D3E700"
                , test "from Hex to Hex" <|
                    \_ ->
                        Colour.fromHex "#FFD700"
                            |> expectHex "#FFD700"
                , fuzz (hexStringOfLength 4) "Short hex with transparency" <|
                    \hex ->
                        Expect.ok (Colour.fromHex hex)
                , fuzz (hexStringOfLength 8) "Long hex with transparency" <|
                    \hex ->
                        Expect.ok (Colour.fromHex hex)
                , fuzz (hexStringOfLength 3) "Short hex and long hex match" <|
                    \hex ->
                        let
                            fullLengthHexString =
                                String.toList hex
                                    |> List.concatMap (\v -> [ v, v ])
                                    |> String.fromList
                                    |> String.dropLeft 1
                        in
                        Colour.fromHex hex
                            |> expectHex fullLengthHexString
                , fuzz (hexStringOfLength 6) "Long hex succeeds" <|
                    \hex ->
                        Colour.fromHex hex
                            |> expectHex hex
                ]
            ]
        , describe "to a String" <|
            let
                transparentPink =
                    Colour.fromRGB ( 255, 0, 255 )
            in
            [ test "toRGBString" <|
                \_ ->
                    transparentPink
                        |> Colour.toRGBString
                        |> Expect.equal "rgb(255,0,255)"
            , test "toHSLString" <|
                \_ ->
                    transparentPink
                        |> Colour.toHSLString
                        |> Expect.equal "hsl(300,100%,50%)"
            , test "toHex" <|
                \_ ->
                    transparentPink
                        |> Colour.toHex
                        |> Expect.equal "#FF00FF"
            ]
        ]


conversionsSpec : Test
conversionsSpec =
    describe "Conversions & channel values"
        [ describe "toHSL"
            [ describe "from RGB colour"
                [ test "black" <|
                    \_ ->
                        Colour.fromRGB ( 0, 0, 0 )
                            |> Colour.toHSL
                            |> expectTripleEquals ( 0, 0, 0 )
                , test "white" <|
                    \_ ->
                        Colour.fromRGB ( 255, 255, 255 )
                            |> Colour.toHSL
                            |> expectTripleEquals ( 0, 0, 100 )
                , test "red" <|
                    \_ ->
                        Colour.fromRGB ( 255, 0, 0 )
                            |> Colour.toHSL
                            |> expectTripleEquals ( 0, 100, 50 )
                , test "green" <|
                    \_ ->
                        Colour.fromRGB ( 0, 128, 0 )
                            |> Colour.toHSL
                            |> expectTripleEquals ( 120, 100, 25 )
                ]
            , describe "from HSL colour"
                [ test "black" <|
                    \_ ->
                        Colour.fromHSL ( 0, 0, 0 )
                            |> Colour.toHSL
                            |> expectTripleEquals ( 0, 0, 0 )
                ]
            ]
        , describe "toRGB"
            [ describe "from RGB colour"
                [ test "black" <|
                    \_ ->
                        Colour.fromRGB ( 0, 0, 0 )
                            |> Colour.toRGB
                            |> expectTripleEquals ( 0, 0, 0 )
                ]
            , describe "from HSL colour"
                [ test "black" <|
                    \_ ->
                        Colour.fromHSL ( 0, 0, 0 )
                            |> Colour.toRGB
                            |> expectTripleEquals ( 0, 0, 0 )
                , test "white" <|
                    \_ ->
                        Colour.fromHSL ( 0, 0, 100 )
                            |> Colour.toRGB
                            |> expectTripleEquals ( 255, 255, 255 )
                , test "red" <|
                    \_ ->
                        Colour.fromHSL ( 0, 100, 50 )
                            |> Colour.toRGB
                            |> expectTripleEquals ( 255, 0, 0 )
                , test "green" <|
                    \_ ->
                        Colour.fromHSL ( 120, 100, 25 )
                            |> Colour.toRGB
                            |> expectTripleEquals ( 0, 128, 0 )
                ]
            ]
        , fuzz ColourFuzzer.rgbValues "from RGB to HSL and back to RGB again" <|
            \colour ->
                let
                    operations =
                        Colour.fromRGB
                            >> Colour.toHSL
                            >> Colour.fromHSL
                            >> Colour.toRGB

                    rgbName =
                        Colour.toRGBString (Colour.fromRGB colour)
                in
                expectTripleEquals colour (operations colour)
        , fuzz ColourFuzzer.hslValues "from HSL to RGB and back to HSL again" <|
            \(( _, s, l ) as colour) ->
                let
                    operations =
                        Colour.fromHSL
                            >> Colour.toRGB
                            >> Colour.fromRGB
                            >> Colour.toHSL

                    hslName =
                        Colour.toHSLString (Colour.fromHSL colour)
                in
                if l == 0 then
                    -- This is black, which has more representations in HSL space
                    -- than in RGB space.
                    expectTripleEquals ( 0, 0, 0 ) (operations colour)

                else if l == 100 then
                    -- This is white, which has more representations in HSL space
                    -- than in RGB space.
                    expectTripleEquals ( 0, 0, 100 ) (operations colour)

                else if s == 0 then
                    -- This is a fully-desaturated gray. It also has more representations
                    -- in HSL space than in RGB space.
                    expectTripleEquals ( 0, 0, l ) (operations colour)

                else
                    expectTripleEquals colour (operations colour)
        , fuzz (ColourFuzzer.hexStringOfLength 6) "from Hex to RGB and back to Hex again" <|
            \c ->
                Colour.fromHex c
                    |> Result.map Colour.toRGB
                    |> Result.map (Colour.fromRGB >> Colour.toHex)
                    |> Expect.equal (Ok c)
        ]


luminanceSuite : Test
luminanceSuite =
    describe "luminance"
        [ test "white is very bright" <|
            \_ ->
                white
                    |> Colour.luminance
                    |> floatEqual 1
        , test "gray is middlingly bright" <|
            \_ ->
                gray
                    |> Colour.luminance
                    |> floatEqual 0.215
        , test "black is not very bright" <|
            \_ ->
                black
                    |> Colour.luminance
                    |> floatEqual 0
        ]


highContrastSuite : Test
highContrastSuite =
    let
        grays : List ( Colour, String )
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
                    expectColoursEqual (Colour.highContrast black) white
            , test "highContrast white == black" <|
                \_ ->
                    expectColoursEqual (Colour.highContrast white) black
            , describe "highContrast grays"
                (List.map
                    (\( colour, name ) ->
                        test name <|
                            \_ ->
                                colour
                                    |> Colour.highContrast
                                    |> Colour.Accessibility.contrast colour
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
                    expectColoursEqual (Colour.invert black) white
            , test "invert white == black" <|
                \_ ->
                    expectColoursEqual (Colour.invert white) black
            ]
        ]



--Test helpers


floatEqual : Float -> Float -> Expectation
floatEqual =
    Expect.within (Expect.Absolute 0.1)


gray : Colour
gray =
    Colour.fromRGB ( 118, 118, 118 )


{-| This exists mostly to make float equality checks nicer.
-}
expectRGB : ( Int, Int, Int ) -> Colour -> Expectation
expectRGB expected colour =
    let
        ( r, g, b ) =
            Colour.toRGB colour
    in
    Expect.equal ( round r, round g, round b ) expected


{-| This exists mostly to make float equality checks nicer.
-}
expectHSL : ( Int, Int, Int ) -> Colour -> Expectation
expectHSL expected colour =
    let
        ( r, g, b ) =
            Colour.toHSL colour
    in
    Expect.equal ( round r, round g, round b ) expected


expectHex : String -> Result String Colour -> Expectation
expectHex expected colourResult =
    case colourResult of
        Ok got ->
            Expect.equal expected (Colour.toHex got)

        Err err ->
            Expect.fail ("Could not parse colour string: \n" ++ err)


expectColoursEqual : Colour -> Colour -> Expectation
expectColoursEqual a b =
    Expect.equal (Colour.toRGBString a) (Colour.toRGBString b)


expectTripleEquals : ( Float, Float, Float ) -> ( Float, Float, Float ) -> Expectation
expectTripleEquals expected actual =
    Expect.equal (roundTriple actual) (roundTriple expected)


roundTriple : ( Float, Float, Float ) -> ( Int, Int, Int )
roundTriple ( a, b, c ) =
    ( round a, round b, round c )

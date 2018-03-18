module Framework.Color
    exposing
        ( Color(..)
        , color
        , colorToHex
        , introspection
        , lighten
        , maximumContrast
        , saturate
        )

{-| Colors generator

Check [Style Guide](https://lucamug.github.io/elm-style-framework/) to see usage examples.


# Functions

@docs Color, color, colorToHex, introspection, lighten, maximumContrast, saturate

-}

{- TODO
   Work directly with hue, saturation, lightness

   { hue, saturation, lightness } =
       baseColor
           |> Color.toHsl

   headingColor =
       Color.hsl hue saturation (lightness * 0.7)

   detailsColor =
       Color.hsl hue (saturation * 0.8) (lightness * 0.5 + 0.3)

   backgroundColor =
       Color.hsl hue (saturation * 1.2) (lightness * 0.05 + 0.93)
-}
--import Color.Convert

import Char
import Color
import Element
import Element.Background
import Element.Border
import Element.Font
import Framework.Configuration exposing (conf)
import Styleguide


{-| -}
lighten : Float -> Color.Color -> Color.Color
lighten quantity cl =
    let
        { hue, saturation, lightness } =
            Color.toHsl cl
    in
    Color.hsl hue saturation (lightness * quantity)


{-| -}
saturate : Float -> Color.Color -> Color.Color
saturate quantity cl =
    let
        { hue, saturation, lightness } =
            Color.toHsl cl
    in
    Color.hsl hue (saturation * quantity) lightness


{-| Used to generate the [Style Guide](https://lucamug.github.io/elm-style-framework/)
-}
introspection : Styleguide.Introspection msg
introspection =
    { name = "Color"
    , signature = "color : Color -> Color.Color"
    , description = "List of colors"
    , usage = "color ColorPrimary"
    , usageResult = usageWrapper Primary
    , boxed = True
    , types =
        [ ( "Sizes"
          , [ ( usageWrapper White, "color White" )
            , ( usageWrapper Black, "color Black" )
            , ( usageWrapper Light, "color Light" )
            , ( usageWrapper Dark, "color Dark" )
            , ( usageWrapper Primary, "color Primary" )
            , ( usageWrapper Link, "color Link" )
            , ( usageWrapper Info, "color Info" )
            , ( usageWrapper Success, "color Success" )
            , ( usageWrapper Warning, "color Warning" )
            , ( usageWrapper Danger, "color Danger" )
            , ( usageWrapper BlackBis, "color BlackBis" )
            , ( usageWrapper BlackTer, "color BlackTer" )
            , ( usageWrapper GreyDarker, "color GreyDarker" )
            , ( usageWrapper GreyDark, "color GreyDark" )
            , ( usageWrapper Grey, "color Grey" )
            , ( usageWrapper GreyLight, "color GreyLight" )
            , ( usageWrapper GreyLighter, "color GreyLighter" )
            , ( usageWrapper WhiteTer, "color WhiteTer" )
            , ( usageWrapper WhiteBis, "color WhiteBis" )
            , ( usageWrapper Transparent, "color Transparent" )
            ]
          )
        ]
    }


usageWrapper : Color -> Element.Element msg
usageWrapper colorType =
    let
        cl =
            color colorType
    in
    Element.el
        [ Element.Background.color cl
        , Element.width <| Element.px 100
        , Element.height <| Element.px 100
        , Element.padding 10
        , Element.Border.rounded 5
        , Element.Font.color <| maximumContrast cl
        ]
    <|
        Element.text <|
            colorToHex cl


{-| Return one of the font color that has maximum contrast on a background color

    maximumContrast Color.black == color ColorFontBright

-}
maximumContrast : Color.Color -> Color.Color
maximumContrast c =
    let
        { hue, saturation, lightness } =
            c
                |> Color.toHsl
    in
    if lightness < 0.7 then
        color White
    else
        color Dark


{-| List of colors
-}
type Color
    = Black
    | Dark
    | Light
    | Primary
    | Info
    | Success
    | Warning
    | Danger
    | BlackBis
    | BlackTer
    | GreyDarker
    | GreyDark
    | Grey
    | GreyLight
    | GreyLighter
    | White
    | WhiteTer
    | WhiteBis
    | Link
    | Transparent


{-| -}
colorToHex : Color.Color -> String
colorToHex cl =
    let
        { red, green, blue } =
            Color.toRgb cl
    in
    List.map toHex [ red, green, blue ]
        |> (::) "#"
        |> String.join ""


toHex : Int -> String
toHex =
    toRadix >> String.padLeft 2 '0'


toRadix : Int -> String
toRadix n =
    let
        getChr c =
            if c < 10 then
                toString c
            else
                String.fromChar <| Char.fromCode (87 + c)
    in
    if n < 16 then
        getChr n
    else
        toRadix (n // 16) ++ getChr (n % 16)


{-| Convert a type of color to a Color

    color ColorPrimary == hexToColor "#00D1B2"

-}
color : Color -> Color.Color
color cl =
    case cl of
        -- https://bulma.io/documentation/modifiers/typography-helpers/
        Link ->
            conf.colors.link

        White ->
            conf.colors.white

        Black ->
            conf.colors.black

        Light ->
            conf.colors.light

        Dark ->
            conf.colors.dark

        Primary ->
            conf.colors.primary

        Info ->
            conf.colors.info

        Success ->
            conf.colors.success

        Warning ->
            conf.colors.warning

        Danger ->
            conf.colors.danger

        BlackBis ->
            conf.colors.blackBis

        BlackTer ->
            conf.colors.blackTer

        GreyDarker ->
            conf.colors.greyDarker

        GreyDark ->
            conf.colors.greyDark

        Grey ->
            conf.colors.grey

        GreyLight ->
            conf.colors.greyLight

        GreyLighter ->
            conf.colors.greyLighter

        WhiteTer ->
            conf.colors.whiteTer

        WhiteBis ->
            conf.colors.whiteBis

        Transparent ->
            Color.hsla 0 0 0 0

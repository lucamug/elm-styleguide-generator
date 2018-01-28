module Framework.Color
    exposing
        ( Color(..)
        , colorToHex
        , introspection
        , toColor
        )

import Color
import Color.Accessibility
import Color.Convert
import Element
import Element.Background
import Element.Border
import Element.Font
import Styleguide


introspection : Styleguide.Data msg
introspection =
    let
        buttonText =
            "Button"
    in
    { name = "Color"
    , signature = "toColor : Color -> Color.Color"
    , description = "List of colors"

    --
    , usage = "toColor ColorPrimary"
    , usageResult = usageWrapper ColorPrimary
    , boxed = True
    , types =
        [ ( "Sizes"
          , [ ( usageWrapper ColorDefault, "toColor ColorDefault" )
            , ( usageWrapper ColorPrimary, "toColor ColorPrimary" )
            , ( usageWrapper ColorLink, "toColor ColorLink" )
            , ( usageWrapper ColorInfo, "toColor ColorInfo" )
            , ( usageWrapper ColorSuccess, "toColor ColorSuccess" )
            , ( usageWrapper ColorWarning, "toColor ColorWarning" )
            , ( usageWrapper ColorDanger, "toColor ColorDanger" )
            , ( usageWrapper ColorFontBright, "toColor ColorFontBright" )
            , ( usageWrapper ColorFontDark, "toColor ColorFontDark" )
            , ( usageWrapper ColorBorderDefault, "toColor ColorBorderDefault" )
            ]
          )
        ]
    }


usageWrapper : Color -> Element.Element msg
usageWrapper colorType =
    let
        color =
            toColor colorType
    in
    Element.el
        [ Element.Background.color color
        , Element.width <| Element.px 100
        , Element.height <| Element.px 100
        , Element.padding 10
        , Element.Border.rounded 5
        , Element.Font.color <| Maybe.withDefault Color.black <| Color.Accessibility.maximumContrast color [ Color.white, Color.black ]
        ]
    <|
        Element.text <|
            Color.Convert.colorToHex color


maximumContrast : Color.Color -> Color.Color
maximumContrast c =
    Maybe.withDefault Color.black <| Color.Accessibility.maximumContrast c [ toColor ColorFontBright, toColor ColorFontDark ]


type Color
    = ColorDefault
    | ColorPrimary
    | ColorLink
    | ColorInfo
    | ColorSuccess
    | ColorWarning
    | ColorDanger
    | ColorFontBright
    | ColorFontDark
    | ColorBorderDefault


hexToColor : String -> Color.Color
hexToColor color =
    Result.withDefault Color.gray <| Color.Convert.hexToColor color


colorToHex : Color.Color -> String
colorToHex =
    Color.Convert.colorToHex


toColor : Color -> Color.Color
toColor color =
    case color of
        ColorDefault ->
            hexToColor "#ffffff"

        ColorPrimary ->
            hexToColor "#00D1B2"

        ColorLink ->
            hexToColor "#276CDA"

        ColorInfo ->
            hexToColor "#209CEE"

        ColorSuccess ->
            hexToColor "#23D160"

        ColorWarning ->
            hexToColor "#ffdd57"

        ColorDanger ->
            hexToColor "#FF3860"

        ColorFontBright ->
            hexToColor "#fff"

        ColorFontDark ->
            hexToColor "#363636"

        ColorBorderDefault ->
            hexToColor "#dbdbdb"

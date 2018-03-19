module Styleguide exposing (Introspection, Model, Msg, update, view, viewPage)

{-| This simple package generates a page with Style Guides.
It uses certain data structure that each section of the framework expose ([Example](https://lucamug.github.io/elm-styleguide-generator/), [Example source](https://github.com/lucamug/elm-styleguide-generator/blob/master/examples/Main.elm)).

The idea is to have a Living version of the Style Guide that always stays
updated with no maintenance.

For more info about the idea, see [this post](https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522).


# Functions

@docs Introspection, Model, Msg, update, view, viewPage

-}

--import Element.Input as Input

import Color exposing (gray, rgb)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Html
import Html.Attributes
import Window


version : String
version =
    "3.0.2"


mainPadding : Int
mainPadding =
    40


{-| This is the type that is required for Introspection

Example, inside Framework.Button:

    introspection : Styleguide.Introspection msg
    introspection =
        { name = "Button"
        , signature = "button : List Modifier -> Maybe msg -> String -> Element msg"
        , description = "Buttons accept a list of modifiers, a Maybe msg (for example: \"Just DoSomething\") and the text to display inside the button."
        , usage = "button [ Medium, Success, Outlined ] Nothing \"Button\""
        , usageResult = button [ Medium, Success, Outlined ] Nothing "Button"
        , boxed = False
        , variations =
            [ ( "Sizes"
              , [ ( button [ Small ] Nothing "Button", "button [ Small ] Nothing \"Button\"" )
                , ( button [ Medium ] Nothing "Button", "button [ Medium ] Nothing \"Button\"" )
                , ( button [ Large ] Nothing "Button", "button [ Large ] Nothing \"Button\"" )
                ]
              )
            ]
        }

-}
type alias Introspection =
    { name : String
    , signature : String
    , description : String
    , usage : String
    , usageResult : Element Msg
    , variations : List Variation
    , boxed : Bool
    }


type alias IntrospectionWithView =
    ( Introspection, Bool )


type alias Variation =
    ( String, List SubSection )


type alias SubSection =
    ( Element Msg, String )


{-| -}
type Msg
    = ToggleSection String
    | OpenAll
    | CloseAll
    | SelectThis ( Introspection, Variation )
    | GoTop


{-| -}
type alias Model =
    { selected : Maybe ( Introspection, Variation )
    , title : String
    , subTitle : String
    , version : String
    , introduction : Element Msg
    , introspections : List ( Introspection, Bool )
    }


{-| -}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoTop ->
            ( { model | selected = Nothing }, Cmd.none )

        SelectThis introspectionAndVariation ->
            ( { model | selected = Just introspectionAndVariation }, Cmd.none )

        OpenAll ->
            let
                introspections =
                    List.map (\( data, show ) -> ( data, True )) model.introspections
            in
            ( { model | introspections = introspections }, Cmd.none )

        CloseAll ->
            let
                introspections =
                    List.map (\( data, show ) -> ( data, False )) model.introspections
            in
            ( { model | introspections = introspections }, Cmd.none )

        ToggleSection dataName ->
            let
                toggle ( data, show ) =
                    if data.name == dataName then
                        ( data, not show )
                    else
                        ( data, show )

                introspections =
                    List.map toggle model.introspections
            in
            ( { model | introspections = introspections }, Cmd.none )


{-| This create the entire page of Html type.

Example, in your Style Guide page:

    main : Html.Html msg
    main =
        Styleguide.viewHtmlPage
            [ Framework.Button.introspection
            , Framework.Color.introspection
            ]

-}
view : Model -> Html.Html Msg
view model =
    layout
        layoutAttributes
    <|
        viewPage Nothing model


css : String
css =
    """
.elmStyleguideGenerator-open {
transition: all .8s;
ttransform: translateY(0);
max-height: 500px;
}
.elmStyleguideGenerator-close {
transition: all .1s;
ttransform: translateY(-100%);
max-height: 0;
}
"""


{-| This create the entire page of Element type. If you are working
with style-elements this is the way to go, so you can customize your page.

Example, in your Style Guide page:

    main : Html.Html msg
    main =
        layout layoutAttributes <|
            column []
                [ ...
                , Styleguide.page
                    [ Framework.Button.introspection
                    , Framework.Color.introspection
                    ]
                ...
                ]

-}
viewPage : Maybe Window.Size -> Model -> Element Msg
viewPage maybeWindowSize model =
    row
        [ height <|
            case maybeWindowSize of
                Just windowSize ->
                    px windowSize.height

                Nothing ->
                    fill
        , width fill
        ]
        [ html <| Html.node "style" [] [ Html.text css ]
        , el [ height <| fill, scrollbarY, clipX, width <| px 310 ] <| viewMenuColumn model
        , el [ height <| fill, scrollbarY, clipX, width <| fill ] <| viewContentColumn model
        ]


viewMenuColumn : Model -> Element Msg
viewMenuColumn model =
    column
        [ Background.color <| Color.rgb 0x33 0x33 0x33
        , Font.color <| Color.rgb 0xB6 0xB6 0xB6
        , width fill
        , height shrink
        , spacing 30
        , paddingXY mainPadding (mainPadding - 20)
        , height fill
        ]
        [ column [ height shrink ]
            [ viewLogo model.title model.subTitle model.version
            , row
                [ spacing 10
                , Font.size 14
                , Font.color <| rgb 0x82 0x82 0x82
                ]
                [ el [ pointer, Events.onClick OpenAll ] <| text "Expand All"
                , el [ pointer, Events.onClick CloseAll ] <| text "Close All"
                ]
            ]
        , column [ spacing 30, height shrink, alignTop ] <| List.map (\( data, show ) -> viewIntrospectionForMenu data show) model.introspections
        ]


viewContentColumn : Model -> Element Msg
viewContentColumn model =
    case model.selected of
        Just ( introspection, ( title, variations ) ) ->
            column
                []
                [ viewTitleAndSubTitle introspection.name (text introspection.description)

                --, el [ Font.size 18 ] <| text "Signature"
                --, paragraph codeAttributes [ text <| introspection.signature ]
                --, el [ Font.size 18 ] <| text "Code Example"
                --, paragraph codeAttributes [ text <| introspection.usage ]
                --, el [ Font.size 18 ] <| text "Result"
                --, paragraph [] [ introspection.usageResult ]
                , column
                    [ padding mainPadding
                    , spacing mainPadding
                    , Background.color <| Color.white
                    ]
                    [ el [ Font.size 28 ] (text <| title)
                    , column [ spacing 10 ] (List.map (\( part, name ) -> viewSubSection ( part, name ) False) variations)
                    ]
                ]

        Nothing ->
            el
                [ height fill
                , width fill
                , scrollbars
                ]
            <|
                column [ padding <| mainPadding + 100, spacing mainPadding ]
                    [ el [] <| viewLogo model.title model.subTitle model.version
                    , el [ Font.size 24 ] model.introduction
                    ]


viewLogo : String -> String -> String -> Element Msg
viewLogo title subTitle version =
    column [ Events.onClick GoTop, pointer, height shrink ]
        [ el [ Font.size 60, Font.bold, Events.onClick GoTop, pointer ] <| text title
        , el [ Font.size 16, Font.bold, Events.onClick GoTop, pointer, moveUp 3 ] <| text subTitle
        , el [ Font.size 16, Font.bold, Events.onClick GoTop, pointer, moveUp 9 ] <| text <| "v" ++ version
        ]



-- viewTitleAndSubTitle (model.title ++ " " ++ model.subTitle) model.introduction


{-| This function create a section of the page based on the input data.

Example:

    section Framework.Button.introspection

-}
viewIntrospectionForMenu : Introspection -> Bool -> Element Msg
viewIntrospectionForMenu introspection open =
    column
        [ Font.color <| rgb 0x82 0x82 0x82
        ]
        [ el
            [ pointer
            , Events.onClick <| ToggleSection introspection.name
            , width fill
            , Font.bold
            ]
          <|
            paragraph [ alignLeft ]
                [ el
                    [ padding 5
                    , rotate
                        (if open then
                            pi / 2
                         else
                            0
                        )
                    ]
                    (text <| "⟩ ")
                , el
                    [ Font.size 18
                    , Font.bold
                    ]
                  <|
                    text introspection.name
                ]
        , column
            ([ clip
             , height shrink
             , Font.size 16
             , Font.color <| rgb 0xD1 0xD1 0xD1
             , spacing 2
             , paddingEach { bottom = 0, left = 26, right = 0, top = 0 }
             ]
                ++ (if open then
                        [ htmlAttribute <| Html.Attributes.class "elmStyleguideGenerator-open" ]
                    else
                        [ htmlAttribute <| Html.Attributes.class "elmStyleguideGenerator-close" ]
                   )
            )
            (viewListVariationForMenu introspection introspection.variations)
        ]


viewListVariationForMenu : Introspection -> List Variation -> List (Element Msg)
viewListVariationForMenu introspection variations =
    List.map
        (\( title, variation ) ->
            el
                [ pointer
                , Events.onClick <| SelectThis ( introspection, ( title, variation ) )
                ]
            <|
                text title
        )
        variations



{-

   viewIntrospectionOLD : Introspection -> Bool -> Bool -> Element Msg
   viewIntrospectionOLD introspection open menuStyle =
       column
           [ Border.widthEach { top = 0, right = 0, bottom = 0, left = 0 }
           , Border.color gray
           , paddingEach { top = 0, right = 0, bottom = 0, left = 0 }
           , spacing 0
           , Font.color <| rgb 0x82 0x82 0x82
           , Font.bold
           ]
           [ el
               [ pointer
               , Events.onClick <| ToggleSection introspection.name
               , width fill
               ]
             <|
               paragraph [ alignLeft ]
                   [ el
                       [ padding 10
                       , rotate
                           (if open then
                               pi / 2
                            else
                               0
                           )
                       , Font.size 18
                       , Font.bold
                       ]
                       (text <|
                           "⟩ "
                       )
                   , text <| introspection.name
                   ]
           , el
               [ paddingXY 0 0
               , clip
               , height shrink
               ]
               (column
                   ([]
                       ++ (if open then
                               [ htmlAttribute <| Html.Attributes.class "elmStyleguideGenerator-open" ]
                           else
                               [ htmlAttribute <| Html.Attributes.class "elmStyleguideGenerator-close" ]
                          )
                   )
                   (if menuStyle then
                       [ viewListVariationForMenu introspection.variations ]
                    else
                       [ viewIntrospectionOverview introspection
                       , viewListVariation introspection.variations introspection.boxed
                       ]
                   )
               )
           ]
-}
{-

   viewListVariation : List Variation -> Bool -> Element Msg
   viewListVariation listVariations boxed =
       column []
           (List.map
               (\( title, variations ) ->
                   viewIntrospectionAndVariation ( title, variations ) boxed
               )
               listVariations
           )
-}


viewTitleAndSubTitle : String -> Element Msg -> Element Msg
viewTitleAndSubTitle title subTitle =
    column
        [ Background.color <| rgb 0xF7 0xF7 0xF7
        , padding mainPadding
        , spacing 10
        , height shrink
        ]
        [ el [ Font.size 32, Font.bold ] (text <| title)
        , paragraph [ Font.size 24, Font.extraLight ] [ subTitle ]
        ]


viewSubSection : SubSection -> Bool -> Element Msg
viewSubSection ( part, sourceCode ) boxed =
    row
        []
        ([ paragraph
            [ width fill
            , scrollbars
            ]
            [ part ]
         ]
            ++ (if sourceCode == "" then
                    [ el [ width fill ] empty ]
                else
                    [ paragraph
                        [ width fill
                        , scrollbars
                        , alignTop
                        , Font.color <| rgb 0x99 0x99 0x99
                        , Font.family [ Font.monospace ]
                        , Font.size 16
                        , Background.color <| Color.rgb 0x33 0x33 0x33
                        , padding 16
                        , Border.rounded 8
                        ]
                        [ text <| sourceCode ]
                    ]
               )
        )



-- INTERNAL


layoutAttributes : List (Attribute msg)
layoutAttributes =
    [ Font.family
        [ Font.external
            { name = "Noto Sans"
            , url = "https://fonts.googleapis.com/css?family=Noto+Sans"
            }
        , Font.typeface "Noto Sans"
        , Font.sansSerif
        ]
    , Font.size 16
    , Font.color <| Color.rgb 0x33 0x33 0x33
    , Background.color Color.white
    ]


codeAttributes : List (Attribute msg)
codeAttributes =
    [ Background.color <| rgb 0xEE 0xEE 0xEE
    , padding 10
    , Font.family [ Font.monospace ]
    , Font.size 14
    ]


generatedBy : Element msg
generatedBy =
    el [ paddingXY 0 10, alignLeft, Font.size 14, Font.color Color.darkGray ] <|
        paragraph []
            [ text "Generated by "
            , link [ Font.color Color.orange ]
                { url = "http://package.elm-lang.org/packages/lucamug/elm-styleguide-generator/latest"
                , label = text "elm-styleguide-generator"
                }
            , text <| " version " ++ version
            ]



-- SELF EXAMPLE


introspectionExample : String -> Introspection
introspectionExample id =
    { name = "Element " ++ id
    , signature = "Signature " ++ id
    , description = "Description " ++ id
    , usage = "Usage " ++ id
    , usageResult = text <| "Usage result " ++ id
    , boxed = True
    , variations =
        [ ( "Element " ++ id ++ " - Example A"
          , [ ( text <| "Element " ++ id ++ " - Example A - Case 1", "source A1" )
            , ( text <| "Element " ++ id ++ " - Example A - Case 2", "source A2" )
            ]
          )
        , ( "Element " ++ id ++ " - Example B"
          , [ ( text <| "Element " ++ id ++ " - Example B - Case 1", "source B1" )
            , ( text <| "Element " ++ id ++ " - Example B - Case 2", "source B2" )
            ]
          )
        ]
    }


init : ( Model, Cmd Msg )
init =
    ( { selected = Nothing
      , title = "Style"
      , subTitle = "FRAMEWORK"
      , version = "0.0.1"
      , introduction =
            paragraph []
                [ text "This is an example of "
                , link [ Font.color Color.lightBlue ] { label = text "Living Style Guide", url = "https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522" }
                , text " made using "
                , link [ Font.color Color.lightBlue ] { label = text "Elm", url = "http://elm-lang.org/" }
                , text ", "
                , link [ Font.color Color.lightBlue ] { label = text "style-elements", url = "http://package.elm-lang.org/packages/mdgriffith/stylish-elephants/5.0.0/" }
                , text ", "
                , link [ Font.color Color.lightBlue ] { label = text "elm-style-framework", url = "http://package.elm-lang.org/packages/lucamug/elm-style-framework/latest" }
                , text " and "
                , link [ Font.color Color.lightBlue ] { label = text "elm-styleguide-generator", url = "http://package.elm-lang.org/packages/lucamug/elm-styleguide-generator/latest" }
                , text "."
                ]
      , introspections =
            [ ( introspectionExample "A", True )
            , ( introspectionExample "B", True )
            , ( introspectionExample "C", True )
            ]
      }
    , Cmd.none
    )


viewExample : Model -> Html.Html Msg
viewExample model =
    layout layoutAttributes <|
        column []
            [ viewPage Nothing model
            ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

module Main exposing (main)

import Color
import Element exposing (..)
import Element.Font as Font
import Element.Region as Area
import Framework.Button
import Framework.Color
import Framework.Element
import Framework.Spinner
import Html
import Styleguide
import Task
import Window


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { modelStyleguide : Styleguide.Model
    , windowSize : Window.Size
    }


type Msg
    = StyleguideMsg Styleguide.Msg
    | WindowSize Window.Size


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StyleguideMsg msg ->
            let
                ( newModel, newCmd ) =
                    Styleguide.update msg model.modelStyleguide
            in
            ( { model | modelStyleguide = newModel }, Cmd.none )

        WindowSize windowSize ->
            ( { model | windowSize = windowSize }, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( { modelStyleguide =
            { selected = Nothing
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
                [ ( Framework.Element.introspection, False )
                , ( Framework.Button.introspection, False )
                , ( Framework.Spinner.introspection, False )
                , ( Framework.Color.introspection, False )
                ]
            }
      , windowSize = Window.Size 200 200
      }
    , Task.perform WindowSize Window.size
    )


view : Model -> Html.Html Msg
view model =
    layout layoutAttributes <|
        Element.map StyleguideMsg (Styleguide.viewPage (Just model.windowSize) model.modelStyleguide)


layoutAttributes : List (Attribute msg)
layoutAttributes =
    [ Font.family
        [ Font.external
            { name = "Source Sans Pro"
            , url = "https://fonts.googleapis.com/css?family=Source+Sans+Pro"
            }
        , Font.sansSerif
        ]
    , Font.size 16
    , Font.color <| Color.rgb 0x33 0x33 0x33
    ]


h1 : List (Element.Attribute msg)
h1 =
    [ Area.heading 1
    , Font.size 28
    , Font.bold
    , paddingEach { bottom = 40, left = 0, right = 0, top = 20 }
    ]

module Main exposing (..)

import Element exposing (..)
import Framework.Button
import Framework.Color
import Framework.Element
import Framework.Spinner
import Html
import Styleguide


type alias Model =
    { styleguide : Styleguide.Model
    }


type Msg
    = StyleguideMsg Styleguide.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StyleguideMsg msg ->
            let
                ( newModel, newCmd ) =
                    Styleguide.update msg model.styleguide
            in
            ( { model | styleguide = newModel }, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( { styleguide =
            { selectedVariation = Nothing
            , introspections =
                [ ( Framework.Element.introspection, False )
                , ( Framework.Button.introspection, False )
                , ( Framework.Spinner.introspection, False )
                , ( Framework.Color.introspection, False )
                ]
            }
      }
    , Cmd.none
    )


view : Model -> Html.Html Msg
view model =
    layout [] <|
        Element.map StyleguideMsg (Styleguide.viewPage model.styleguide)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

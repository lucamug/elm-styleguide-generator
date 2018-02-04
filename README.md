# Elm Style Guide Generator

## A simple tool to generate Style Guide automatically from Elm code.

This simple package generates a page with Style Guides.
It uses certain data structure (called "introspection") that each section of the framework expose. This data contain information about syntax of the section.

* [Example](https://lucamug.github.io/elm-styleguide-generator/), [Example source](https://github.com/lucamug/elm-styleguide-generator/blob/master/examples/Main.elm)
* [Stand-alone Example](https://lucamug.github.io/elm-styleguide-generator/styleguide.html)


The idea is to have a Living version of the Style Guide that always stays
updated with no maintenance.

For more info about the idea, see [this post](https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522).

For example let's suppose that we have a button module in our framework.
We can expose some internal data doing this :

```elm
module Framework.Button exposing (button, introspection)

import Styleguide

introspection : Styleguide.Introspection msg
introspection =
    { name = "Button"
    , signature = "button : List Modifier -> Maybe msg -> String -> Element msg"
    , description = "Buttons accept a list of modifiers, a Maybe msg (for example: \"Just DoSomething\") and the text to display inside the button."
    , usage = "button [ Medium, Success, Outlined ] Nothing \"Button\""
    , usageResult = button [ Medium, Success, Outlined ] Nothing "Button"
    , boxed = False
    , types =
        [ ( "Sizes"
          , [ ( button [ Small ] Nothing "Button", "button [ Small ] Nothing \"Button\"" )
            , ( button [ Medium ] Nothing "Button", "button [ Medium ] Nothing \"Button\"" )
            , ( button [ Large ] Nothing "Button", "button [ Large ] Nothing \"Button\"" )
            ]
          )
        ]
    }

button : List Modifier -> Maybe msg -> String -> Element msg
button modifiers onPress label =
    ...
    here goes the button code
    ...
```

then from the page where you want to render the Style Guide:

```elm
module Main exposing (..)

import Element exposing (..)
import Framework.Button
import Framework.Color
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
            [ ( Framework.Button.introspection, True )
            , ( Framework.Spinner.introspection, True )
            , ( Framework.Color.introspection, True )
            ]
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
```

* The demo of this code is at https://lucamug.github.io/elm-styleguide-generator/simple.html
* The code is at https://github.com/lucamug/elm-styleguide-generator/blob/master/examples/Simple.elm

This package use an [Experimental version of style-elements](http://package.elm-lang.org/packages/mdgriffith/stylish-elephants/4.0.0) so major changes may happen at any time to this Repo.

## Links

List of Style Guide Generators in other languages
https://github.com/davidhund/styleguide-generators

## Updates

* v.3.0.1 Added ["Simple"](https://github.com/lucamug/elm-styleguide-generator/blob/master/examples/Simple.elm) example and updated the README
* v.3.0.0
* v.2.0.1
* v.2.0.0 Transformed elm-styleguide-generator into a widget (with model/view/update) so that is possible to toggle sections (close/open)
* v.1.0.1
* v.1.0.0

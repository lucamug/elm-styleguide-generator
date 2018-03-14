## Examples of Style Guides

https://www.lightningdesignsystem.com/components/buttons/

## To generate the compiled file for the example

From the root
```
$ elm-live src/Styleguide.elm  --output docs/styleguide.js --dir=docs
```

From the example folder:
```
$ elm-live Main.elm  --output ../docs/main.js --dir=../docs
```
To run the example, from the example folder:
```
$ elm-reactor
```

To preview documentation:

http://package.elm-lang.org/help/docs-preview

$ elm-make --docs=documentation.json

https://becoming-functional.com/publishing-your-first-elm-package-13d984a1200a

$ git tag -a 1.0.0 -m "initial release"
$ git push --tags

$ elm-package publish

To analyze code

```
$ elm-package bump
```

To publish again

```
$ elm-package publish
```

## To test the package without installation

* Create a folder under elm-stuff/packages/lucamug/elm-styleguide-generator
* ln -s ~/elm-styleguide-generator/ ./elm-stuff/packages/lucamug/elm-styleguide-generator/1.0.0


## Writing wizard with Status

It is considered goor practice in Elm writing stateless reusable codes. But there are cases when you don't want to inflate your main update/model structure or when you would like to build something something reusable that have specific requirements.

I will use, as example, a Style Guide Generator. We want to be able to toggle section inside the Style Guide so we need to store the state inside the model and have an update function. This is the end result: http://guupa.com/elm-styleguide-generator/

This is the source code: https://github.com/lucamug/elm-styleguide-generator/tree/master/src

It is actually quite simple to create a state inside a section and then import it in a wider application.

The widget need to have these five things:

* type alias Model
* type Msg
* update
* init (or just initModel if no commands are needed, like in our case)
* view

Is not necessary to have the main function defined, but we can have that too if we want the widget to be able to run stand-alone.

Once there five things are ready, let's see what is necessary to do in the host (root) part of the app where the widget is included.

Let's assume that the widget is called "Styleguide". These are the steps

We import it

```
import Styleguide
```

We add its model inside the root model:

```
type alias Model =
    { styleguide : Styleguide.Model
      ...
    }
```

and in the init (here we can initialize the widget with some value if needed, like in this case)

```
init : ( Model, Cmd Msg )
init =
    ( { styleguide =
            [ ( Framework.Button.introspection, True )
            , ( Framework.Spinner.introspection, True )
            , ( Framework.Color.introspection, True )
            ]
        ...
      }
    , Cmd.none
    )
```

We add one entry in the messages List

```
type Msg = StyleguideMsg Styleguide.Msg
```

and in the update function

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StyleguideMsg msg ->
            let
                ( newModel, newCmd ) =
                    Styleguide.update msg model.styleguide
            in
            ( { model | styleguide = newModel }, Cmd.none )
        ...
```

Here we intercept all the messages from the root. If the message belong to the widget we simply send ot to the widget update (Styleguide.update) and we use the returned model to update the root model ({ model | styleguide = newModel }). We are ignoring commands here but it would be simpler to consider them too.

Last thing, we add the wizard view to the root view:

```elm
view : Model -> Html.Html Msg
view model =
    Html.div []
        [ EHtml.map StyleguideMsg (Styleguide.view model.styleguide)
        ...
        ]
```

and, in case we are using style-elements:

```elm
view : Model -> Html.Html Msg
view model =
    layout layoutAttributes <|
        column []
            [ Element.map StyleguideMsg (Styleguide.view model.styleguide)
            ...
            ]
```

Note how here how we use StyleguideMsg to convert the Styleguide.Msg into Msg, otherwise the compiler will complain that inside view there are section that return different types.

Out of curiosity let's open elm-repl and paste these commands:

```
> import Styleguide
> type Msg = StyleguideMsg Styleguide.Msg
> StyleguideMsg
<function> : Styleguide.Msg -> Repl.Msg
```

As we can see the signature of StyleguideMsg is

```
Styleguide.Msg -> Repl.Msg
```

Exactly what we needed in our view function (Repl would be our root)

If we add also the main function:

```
main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
```

We would be able to run a stand-alone version of the widget, like this:


This is all.

Thank you for reading.

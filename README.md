# Elm Style Guide Generator
----
## A simple tool to generate Style Guide automatically from Elm code.

This simple package generates a page with Style Guides.
It uses certain data structure that each section of the framework expose ([Demo](https://lucamug.github.io/elm-styleguide-generator/), [Source](https://github.com/lucamug/elm-styleguide-generator/blob/master/examples/Main.elm)).

The idea is to have a Living version of the Style Guide that always stays
updated with no maintenance.

For more info about the idea, see [this post](https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522).

For example let's suppose that we have a button module in our framework.
We can expose some internal data doing this :

```elm
module Framework.Button exposing (button, introspection)

import Styleguide

introspection : Styleguide.Data msg
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

then from the Style Guide page:

```elm
module StyleguidePage exposing (main)

import Element exposing (..)
import Html
import Styleguide


main : Html.Html msg
main =
    Styleguide.htmlPage
        [ Framework.Button.introspection
        , Framework.Color.introspection
        ]
```

Have a look at [lucamug/elm-styleguide-generator/examples](https://github.com/lucamug/elm-styleguide-generator/examples) for a detailed example.

This package use a [Experimental version of style-elements](http://package.elm-lang.org/packages/mdgriffith/stylish-elephants/4.0.0) so major changes may happen at any time to this Repo.

----
## Links

List of Style Guide Generators in other languages
https://github.com/davidhund/styleguide-generators

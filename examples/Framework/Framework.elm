module Framework.Framework
    exposing
        ( Conf
        , Modifier(..)
        , Size(..)
        , State(..)
        , toPx
        )

import Framework.Color as Color


-- TYPES


type Modifier
    = Primary
    | Link
    | Info
    | Success
    | Warning
    | Danger
    | Small
    | Medium
    | Large
    | Outlined
    | Loading
    | Disabled


type Size
    = SizeSmall
    | SizeDefault
    | SizeMedium
    | SizeLarge


type State
    = StateDefault
    | StateOutlined
    | StateLoading
    | StateDisabled


type alias Conf =
    { color : Color.Color
    , size : Size
    , state : State
    }


toPx : Size -> Int
toPx size =
    case size of
        SizeSmall ->
            12

        SizeDefault ->
            16

        SizeMedium ->
            20

        SizeLarge ->
            24

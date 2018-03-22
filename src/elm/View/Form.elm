module View.Forms exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


inform : List (Html message) -> Html message
inform body =
    label
        [ class "h6 italic green" ]
        body


warning : List (Html message) -> Html message
warning body =
    label
        [ class "h6 italic yellow" ]
        body


error : List (Html message) -> Html message
error body =
    label
        [ class "h6 italic red" ]
        body


type alias FormState =
    { value : String
    , attributes : List (Attributes message)
    , messageTop : List (Html message)
    , messageRight : List (Html message)
    , messageBottom : List (Html message)
    , messageLeft : List (Html message)
    }


initFormState : FormState
initFormState =
    { value = ""
    , attributes = []
    , messageTop = []
    , messageRight = []
    , messageBottom = []
    , messageLeft = []
    }


pretty : (Attributes message -> List (Html message) -> Html message) -> FormState -> Html message
pretty node state =
    div
        []
        [ p
            []
            state.messageTop
        , p
            []
            [ state.messageLeft
            , node
                state.attributes
                []
            , state.messageRight
            ]
        , p
            []
            state.messageBottom
        ]


textfield : Attributes message -> List (Html message) -> Html message
textfield attributes =
    input ([ type_ "text" ] ++ attributes)


dropfield : Attrs msg -> List (Html msg) -> Html msg
dropfield attributes children =
    div
        [ style
            [ ( "border", "2px dashed #ccc" )
            , ( "width", "80%" )
            , ( "min-height", "100px" )
            ]
        ]
        [ p
            [ class "gray center m4" ]
            [ text "drop file here" ]
        ]

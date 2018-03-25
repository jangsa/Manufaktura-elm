module View.Forms exposing (..)

import Json.Decode as Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


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


type alias FormState message =
    { value : String
    , attributes : List (Attribute message)
    , messageTop : List (Html message)
    , messageRight : List (Html message)
    , messageBottom : List (Html message)
    , messageLeft : List (Html message)
    }


initFormState : FormState message
initFormState =
    { value = ""
    , attributes = []
    , messageTop = []
    , messageRight = []
    , messageBottom = []
    , messageLeft = []
    }


pretty : (List (Attribute message) -> List (Html message) -> Html message) -> FormState message -> Html message
pretty node state =
    div
        []
        [ p
            []
            state.messageTop
        , p
            []
            (state.messageLeft
                ++ [ node
                        state.attributes
                        []
                   ]
                ++ state.messageRight
            )
        , p
            []
            state.messageBottom
        ]


textfield : List (Attribute message) -> List (Html message) -> Html message
textfield attributes =
    input ([ type_ "text" ] ++ attributes)



--type alias ExtendibleTextfieldState message =
--  List (String, Html message)
--               initExtendibleTextfieldState : ExtendibleTextfieldState
--              initExtendibleTextfieldState =[ ("", "")]
--extendibleTextfield : Int -> Int -> Int -> List (String, Html message)
--extendibleTextfield fixedColumn minRow maxRow =


dropfield : Attribute msg -> List (Html msg) -> Html msg
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


type alias OverlayState =
    Bool


overlay : message -> message -> List (Html message) -> Html message
overlay openMsg closeMsg children =
    div
        [ class "fixed img svg top-0 left-0 bottom-0 right-0 bg-darken-1"
        , onClick closeMsg
        ]
        [ div
            [ class "absolute bg-white border p2"
            , id "new_project_front"
            , onWithOptions
                "click"
                { preventDefault = True, stopPropagation = True }
                (Decode.succeed openMsg)
            , style
                [ ( "top", "50%" )
                , ( "left", "50%" )
                , ( "width", "50%" )
                , ( "height", "80%" )
                , ( "transform", "translate(-50%,-50%)" )
                , ( "-ms-transform", "translate(-50%,-50%)" )
                ]
            ]
            children
        ]

module Common.View.Form exposing (..)

import Json.Decode as Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


simpleButton : msg -> String -> Html msg
simpleButton onClickMsg buttonLabel =
    a
        [ class "btn btn-outline"
        , onClick onClickMsg
        ]
        [ text buttonLabel ]


dropfield : msg -> msg -> msg -> List (Attribute msg) -> List (Html msg) -> Html msg
dropfield dragoverMsg dragleaveMsg dropMsg attributes children =
    let
        dropfieldStyle =
            (style
                [ ( "border", "2px dashed #ccc" )
                , ( "width", "100%" )
                , ( "min-height", "100px" )
                ]
            )

        onDragover msg =
            onWithOptions
                "dragover"
                { preventDefault = True
                , stopPropagation = False
                }
                (Decode.succeed msg)

        onDragleave msg =
            onWithOptions
                "dragleave"
                { preventDefault = True
                , stopPropagation = False
                }
                (Decode.succeed msg)

        onDrop msg =
            onWithOptions
                "drop"
                { preventDefault = True
                , stopPropagation = False
                }
                (Decode.succeed msg)
    in
        div
            ([ dropfieldStyle
             , onDragover dragoverMsg
             , onDragleave dragleaveMsg
             , onDrop dropMsg
             ]
                ++ attributes
            )
            ((p
                [ class "gray center m4" ]
                [ text "drop file here" ]
             )
                :: children
            )


type alias OverlayState =
    Bool


overlay : message -> message -> List (Html message) -> Html message
overlay openMsg closeMsg children =
    div
        [ class "overflow-auto fixed img svg top-0 left-0 bottom-0 right-0 bg-darken-1"

        --, style [ ( "min-height", "min-content" ) ]
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
                , ( "width", "80%" )
                , ( "height", "80%" )
                , ( "transform", "translate(-50%,-50%)" )
                , ( "-ms-transform", "translate(-50%,-50%)" )
                ]
            ]
            children
        ]


console : (String -> msg) -> msg -> String -> String -> Html msg
console onInputMsg onClickMsg ph buttonLabel =
    div
        [ class "clearfix" ]
        [ div
            [ class "col col-10" ]
            [ input
                [ type_ "text"
                , class "input"
                , placeholder ph
                , onInput onInputMsg
                ]
                []
            ]
        , div
            [ class "col-right col-2 px1" ]
            [ simpleButton onClickMsg buttonLabel
            ]
        ]


singletonForm : (String -> msg) -> msg -> String -> String -> Html msg
singletonForm inputMsg clickMsg textfieldLabel buttonLabel =
    div
        [ class "clearfix" ]
        [ div
            [ class "col col-10" ]
            [ input
                [ type_ "text"
                , class "input"
                , placeholder textfieldLabel
                , onInput inputMsg
                ]
                []
            ]
        , div
            [ class "col-right col-2 pl3" ]
            [ a
                [ class "btn btn-outline"
                , onClick clickMsg
                ]
                [ text buttonLabel ]
            ]
        ]


extensibleForm : List (Html msg) -> List ( Int, a ) -> (Int -> msg) -> Html msg
extensibleForm fields seeds msgGen =
    div
        []
        [ ol
            []
            (List.map
                (\( i, _ ) ->
                    div
                        [ class "clearfix" ]
                        [ li
                            []
                            (fields
                                ++ [ div
                                        [ class "col sm-col-1" ]
                                        [ a
                                            [ class "btn btn-outline"
                                            , onClick <| msgGen i
                                            ]
                                            [ text "-" ]
                                        ]
                                   ]
                            )
                        ]
                )
                seeds
            )
        ]


extensibleDuo : (Int -> String -> msg) -> List (Attribute msg) -> (Int -> String -> msg) -> List (Attribute msg) -> List ( Int, a ) -> (Int -> msg) -> Html msg
extensibleDuo msg1 style1 msg2 style2 seeds msgGen =
    div
        []
        [ ol
            []
            (List.map
                (\( i, _ ) ->
                    div
                        [ class "clearfix" ]
                        [ li
                            []
                            ([ div
                                [ class "col sm-col-4" ]
                                [ input
                                    ([ type_ "text"
                                     , onInput (msg1 i)
                                     ]
                                        ++ style1
                                    )
                                    []
                                ]
                             , div
                                [ class "col sm-col-7" ]
                                [ input
                                    ([ type_ "text"
                                     , onInput (msg2 i)
                                     ]
                                        ++ style2
                                    )
                                    []
                                ]
                             , div
                                [ class "col sm-col-1" ]
                                [ a
                                    [ class "btn btn-outline"
                                    , onClick <| msgGen i
                                    ]
                                    [ text "-" ]
                                ]
                             ]
                            )
                        ]
                )
                seeds
            )
        ]


simpleFormFrame : List (Html msg) -> List (Html msg) -> List (Html msg)
simpleFormFrame title children =
    [ div
        [ class "container" ]
        (title
            ++ [ Html.form
                    []
                    children
               ]
        )
    ]


sectionHeader : String -> Html msg
sectionHeader s =
    label
        [ class "h4 italic" ]
        [ text s ]


simpleTextfield : (String -> msg) -> String -> String -> Html msg
simpleTextfield onChangeMsg fieldValue ph =
    div
        []
        [ div
            [ class "clearfix" ]
            [ div
                [ class "col sm-col-8" ]
                [ input
                    [ on "change" <| Decode.map onChangeMsg targetValue
                    , type_ "text"
                    , class "input"
                    , placeholder ph
                    , value fieldValue
                    ]
                    []
                ]
            ]
        ]

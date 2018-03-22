module View.Structures exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias NavigatorState =
    { sideMenu : Bool
    }


initNavigatorState : NavigatorState
initNavigatorState =
    { sideMenu = True
    }


frame : NavigatorState -> Html message -> List (Html message) -> List (Html message) -> Html message
frame state navigator mainContents sideContents =
    div
        [ class "flex flex-column", style [ ( "min-height", "100vh" ) ] ]
        [ header
            []
            [ navigator ]
        , div
            [ class "flex-auto sm-flex" ]
            [ main_
                [ class "flex-auto px2" ]
                mainContents
            , displayIf
                state.sideMenu
                (aside
                    [ class "bg-gray white border p2", style [ ( "width", "20%" ) ] ]
                    sideContents
                )
            ]
        , footer
            [ class "border gray" ]
            [ i
                []
                [ text "Copyright 2018 by "
                , a
                    [ href "https://github.com/jangsa/Manufaktura-elm" ]
                    [ text "Jangsa" ]
                ]
            ]
        ]


default : Html message
default =
    article
        []
        [ p
            [ class "h2 red" ]
            [ text "404 NOT FOUND" ]
        ]


displayIf : Bool -> Html msg -> Html msg
displayIf cond node =
    if cond then
        node
    else
        text ""

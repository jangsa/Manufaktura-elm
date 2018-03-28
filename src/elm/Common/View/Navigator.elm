module Common.View.Navigator exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Common.View.Util exposing (..)


navigator : String -> List (Html message) -> Html message
navigator title menuItems =
    nav [ class "clearfix white bg-black" ]
        [ section
            [ class "sm-col" ]
            [ a
                [ href "./#", class "btn h1 p2" ]
                [ text title ]
            ]
        , section
            [ class "sm-col-right px3" ]
            menuItems
        ]


simpleMenuItem : String -> String -> Html message
simpleMenuItem name pageName =
    a
        [ class "btn py2", href ("./#/" ++ pageName) ]
        [ text name ]


simpleMenuItems : List String -> List (Html.Html message)
simpleMenuItems items =
    List.map
        (\item -> simpleMenuItem item item)
        items


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

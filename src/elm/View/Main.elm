module View.Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


frame : Html message -> List (Html message) -> List (Html message) -> Html message
frame navigator mainContents sideContents =
    div
        [ class "flex flex-column", style [ ( "min-height", "100vh" ) ] ]
        [ header
            []
            [ navigator ]
        , div
            [ class "flex-auto sm-flex" ]
            [ main_
                [ class "flex-auto" ]
                mainContents
            , aside
                [ class "bg-gray white border", style [ ( "width", "20%" ) ] ]
                sideContents
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

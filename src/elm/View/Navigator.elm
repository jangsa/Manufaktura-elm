module View.Navigator exposing (navigator, simpleMenuItems)

import Html exposing (..)
import Html.Attributes exposing (..)


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


simpleMenuItems : List (Html.Html message)
simpleMenuItems =
    List.map
        (\item -> simpleMenuItem item item)
        [ "home", "project", "gitbucket" ]

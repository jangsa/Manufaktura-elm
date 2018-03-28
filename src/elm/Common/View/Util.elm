module Common.View.Util exposing (..)

import Html exposing (..)


displayIf : Bool -> Html msg -> Html msg
displayIf cond body =
    if cond then
        body
    else
        text ""

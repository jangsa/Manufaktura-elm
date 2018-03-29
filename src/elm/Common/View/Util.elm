module Common.View.Util exposing (..)

import Html exposing (..)


displayIf : Bool -> Html msg -> Html msg
displayIf cond body =
    if cond then
        body
    else
        text ""


displayTernary : Bool -> Html msg -> Html msg -> Html msg
displayTernary cond trueBody falseBody =
    if cond then
        trueBody
    else
        falseBody

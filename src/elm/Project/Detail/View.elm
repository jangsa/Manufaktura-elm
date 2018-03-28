module Project.Detail.View exposing (view)

import RemoteData exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Project.Detail.Model exposing (..)


view : Model -> Html msg
view model =
    case model.detailAsync of
        Success _ ->
            text ("detail" ++ model.detail.id)

        _ ->
            text ("loading or error")

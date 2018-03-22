module View.Events exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Utility.JsonDecode exposing (stringAt)


targetID : Decode.Decoder String
targetID =
    stringAt [ "target", "id" ]


onClickID : (String -> msg) -> Attribute msg
onClickID tagger =
    on "click" (Decode.map tagger targetID)


onChangeID : (String -> msg) -> Attribute msg
onChangeID tagger =
    on "change" (Decode.map tagger targetID)


dragover : Msg -> Attribute Msg
dragover message =
    onWithOptions
        "dragover"
        { preventDefault = True
        , stopPropagation = False
        }
        (Decode.succeed message)


ondrop : Msg -> Attribute Msg
ondrop message =
    onWithOptions
        "drop"
        { preventDefault = True
        , stopPropagation = False
        }
        (Decode.succeed message)

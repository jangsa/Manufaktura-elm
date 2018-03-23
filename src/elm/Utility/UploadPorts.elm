port module Utility.UploadPorts exposing (..)


type alias BinaryPortData =
    { base64body : String
    , filename : String
    }


port readFile : String -> Cmd msg


port receiveFile : (BinaryPortData -> msg) -> Sub msg

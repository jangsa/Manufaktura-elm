port module Project.Detail.Ports exposing (..)


type alias Base64File =
    { name : String
    , body : String
    }


type alias JobFilesUploadPacket =
    { index : String
    , base64files : List Base64File
    }


port fileDragged : String -> Cmd msg



--port fileLoaded : (LoadedFile -> msg) -> Sub msg


port fileLoaded : (JobFilesUploadPacket -> msg) -> Sub msg

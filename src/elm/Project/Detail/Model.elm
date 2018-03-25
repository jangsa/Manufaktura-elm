module Project.Detail.Model exposing (..)


type Page
    = NoSuchPage
    | UpdatePage String


type alias Job =
    { index : String
    , name : String
    , description : String
    , inputUrl : String
    , outputUrl : String
    }


type alias Base64File =
    { filename : String
    , base64body : String
    }


type alias ProjectDetail =
    { id : String
    , name : String
    , description : String
    , created : String
    , batch : List Job
    }


initProjectDetail : ProjectDetail
initProjectDetail =
    { id = ""
    , name = ""
    , description = ""
    , created = ""
    , batch = []
    }


type alias Model =
    { projectDetail : ProjectDetail
    }


initModel : Model
initModel =
    { projectDetail = initProjectDetail
    }

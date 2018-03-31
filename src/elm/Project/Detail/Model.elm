module Project.Detail.Model exposing (..)

import Dict exposing (..)
import UrlParser exposing (..)
import Navigation exposing (Location)
import RemoteData exposing (..)


type Page
    = DefaultPage
    | WorkbookPage String


matchList : List (Parser (Page -> a) a)
matchList =
    [ UrlParser.map WorkbookPage <| UrlParser.s "projects" </> string
    ]


matchers : Parser (Page -> a) a
matchers =
    oneOf
        matchList


parseLocation : Location -> Page
parseLocation location =
    Maybe.withDefault
        DefaultPage
        (UrlParser.parseHash matchers location)


type alias FileOnServer =
    { filename : String
    , url : String
    }


type alias Job =
    { index : Int
    , name : String
    , description : String
    , lastInputUrl : String
    , lastOutputUrl : String
    , inputUrls : List FileOnServer
    , outputUrls : List FileOnServer
    , zippedInputUrl : String
    , zippedOutputUrl : String
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


type alias JobState =
    { dragover : Bool
    , awaitingRemoteDone : Bool
    }


initJobState : JobState
initJobState =
    { dragover = False
    , awaitingRemoteDone = False
    }


dragoverJobState : JobState
dragoverJobState =
    { dragover = True
    , awaitingRemoteDone = False
    }


awaitingJobState : JobState
awaitingJobState =
    { dragover = False
    , awaitingRemoteDone = True
    }


type alias Model =
    { page : Page
    , detailAsync : WebData ProjectDetail
    , detail : ProjectDetail
    , jobStateDict : Dict Int JobState
    , loaded : Bool
    }


initModel : Model
initModel =
    { page = DefaultPage
    , detailAsync = NotAsked
    , detail = initProjectDetail
    , jobStateDict = empty
    , loaded = False
    }

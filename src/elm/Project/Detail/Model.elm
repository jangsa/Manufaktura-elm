module Project.Detail.Model exposing (..)

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


type alias Job =
    { index : Int
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
    { page : Page
    , detailAsync : WebData ProjectDetail
    , detail : ProjectDetail
    }


initModel : Model
initModel =
    { page = DefaultPage
    , detailAsync = NotAsked
    , detail = initProjectDetail
    }

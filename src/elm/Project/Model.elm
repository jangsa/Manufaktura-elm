module Project.Model exposing (..)

import RemoteData exposing (..)
import Navigation exposing (Location)
import UrlParser exposing (..)
import Common.View.Form exposing (OverlayState)
import Project.Detail.Model as DetailModel


type Page
    = DefaultPage
    | HomePage


matchList : List (Parser (Page -> a) a)
matchList =
    [ UrlParser.map HomePage <| UrlParser.s "projects"
    , UrlParser.map HomePage <| UrlParser.s "projects" </> top
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


type alias CreationState =
    { name : String
    , description : String
    , batch : List ( Int, ( String, String ) )
    }


initCreationState : CreationState
initCreationState =
    { name = ""
    , description = ""
    , batch =
        [ ( 1, ( "", "" ) ) ]
    }


type alias Model =
    { page : Page
    , projectsAsync : WebData (List DetailModel.ProjectDetail)
    , projects : List DetailModel.ProjectDetail
    , projectsFiltered : List DetailModel.ProjectDetail
    , overlayState : OverlayState
    , creationState : CreationState
    }


initModel : Model
initModel =
    { page = DefaultPage
    , projectsAsync = NotAsked
    , projects = []
    , projectsFiltered = []
    , overlayState = False
    , creationState = initCreationState
    }

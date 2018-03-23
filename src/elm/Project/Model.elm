module Project.Model exposing (..)

import RemoteData exposing (WebData, RemoteData(..))
import Project.Detail.Model as DetailModel


type Page
    = NoSuchPage
    | Home
    | Create
    | Delete


type alias Model =
    { projectsAsync : WebData (List DetailModel.ProjectDetail)
    , projects : List DetailModel.ProjectDetail
    , projectsFiltered : List DetailModel.ProjectDetail
    }


initModel : Model
initModel =
    { projectsAsync = NotAsked
    , projects = []
    , projectsFiltered = []
    }

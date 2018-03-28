module Model exposing (..)

import Project.Model as ProjectModel
import Project.Detail.Model as DetailModel


type Page
    = DefaultPage
    | HomePage
    | ProjectsPage ProjectModel.Page
    | ProjectDetailPage DetailModel.Page



--    | GitBucketPage


type alias Model =
    { page : Page
    , projectsState : ProjectModel.Model
    , projectDetailState : DetailModel.Model
    }


initModel : Page -> Model
initModel page =
    { page = page
    , projectsState = ProjectModel.initModel
    , projectDetailState = DetailModel.initModel
    }

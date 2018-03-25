module Project.Model exposing (..)

import RemoteData exposing (WebData, RemoteData(..))
import Project.Messages exposing (..)
import Project.Detail.Model as DetailModel
import View.Forms as Forms
import Array exposing (..)


type Page
    = NoSuchPage
    | Home
    | Create
    | Delete


type alias CreationFormState =
    { name : String
    , description : String
    , batch : Array ( Int, ( String, String ) )
    }


initCreationFormState : CreationFormState
initCreationFormState =
    { name = ""
    , description = ""
    , batch = fromList [ ( 1, ( "", "" ) ) ]
    }


type alias Model =
    { projectsAsync : WebData (List DetailModel.ProjectDetail)
    , projects : List DetailModel.ProjectDetail
    , projectsFiltered : List DetailModel.ProjectDetail
    , filterFormState : Forms.FormState Message
    , overlayState : Forms.OverlayState
    , creationFormState : CreationFormState
    }


initModel : Model
initModel =
    { projectsAsync = NotAsked
    , projects = []
    , projectsFiltered = []
    , filterFormState = Forms.initFormState
    , overlayState = False
    , creationFormState = initCreationFormState
    }

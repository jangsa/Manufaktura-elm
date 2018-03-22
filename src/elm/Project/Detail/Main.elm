module Project.Detail.Main exposing (..)

import Maybe exposing (withDefault)
import Html
import Navigation exposing (Location)
import UrlParser exposing (..)


type Page
    = NoSuchPage
    | UpdatePage String


matchList : List (Parser (Page -> a) a)
matchList =
    [ UrlParser.map UpdatePage <| (s "project" </> string)
    ]


matchers : Parser (Page -> a) a
matchers =
    oneOf
        matchList


parseLocation : Location -> Page
parseLocation location =
    withDefault
        NoSuchPage
        (UrlParser.parseHash matchers location)


type Message
    = NoMessage
    | LocationChangeMessage Location


type alias Job =
    { id : String
    , name : String
    , inputUrl : String
    , inputReady : Bool
    , outputUrl : String
    , outputReady : Bool
    }


type alias ProjectDetail =
    { id : String
    , name : String
    , created : String
    , batch : List Job
    }


initProjectDetail : ProjectDetail
initProjectDetail =
    { id = ""
    , name = ""
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


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        NoMessage ->
            ( model, Cmd.none )

        LocationChangeMessage location ->
            let
                newPage =
                    parseLocation location

                oldProjectDetail =
                    model.projectDetail

                newModel =
                    case newPage of
                        NoSuchPage ->
                            model

                        UpdatePage id ->
                            let
                                newProjectDetail =
                                    { oldProjectDetail | id = id }
                            in
                                { model | projectDetail = newProjectDetail }
            in
                ( newModel, Cmd.none )


view : Model -> Html.Html message
view model =
    Html.text <| "project@" ++ model.projectDetail.id

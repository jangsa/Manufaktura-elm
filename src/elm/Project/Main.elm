module Project.Main exposing (..)

import Html
import Navigation exposing (Location)
import UrlParser exposing (..)
import Project.Detail.Main


type Page
    = NoSuchPage
    | Home
    | Create
    | Delete


type Message
    = NoMessage
    | LocationChangeMessage Location
    | FilterMessage String
    | WillCreateMessage
    | DidCreateMessage
    | WillDeleteMessage String
    | DidDeleteMessage


type alias Model =
    { projects : List Project.Detail.Main.Model
    , projectsFiltered : List Project.Detail.Main.Model
    }


initModel : Model
initModel =
    { projects = []
    , projectsFiltered = []
    }


matchList : List (Parser (Page -> a) a)
matchList =
    [ UrlParser.map Home <| (s "project")
    , UrlParser.map Home <| (s "project" </> top)
    ]


matchers : Parser (Page -> a) a
matchers =
    oneOf
        matchList


update : Message -> Model -> ( Model, Cmd message )
update message model =
    case message of
        NoMessage ->
            ( model, Cmd.none )

        LocationChangeMessage location ->
            ( model, Cmd.none )

        FilterMessage keywords ->
            ( model, Cmd.none )

        WillCreateMessage ->
            ( model, Cmd.none )

        DidCreateMessage ->
            ( model, Cmd.none )

        WillDeleteMessage id ->
            ( model, Cmd.none )

        DidDeleteMessage ->
            ( model, Cmd.none )


view : Model -> Html.Html message
view model =
    Html.text "project detail home"

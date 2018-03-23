module Project.Detail.Main exposing (..)

import Maybe exposing (withDefault)
import Html
import Navigation exposing (Location)
import UrlParser exposing (..)
import Utility.UploadPorts as UploadPorts
import Project.Detail.Model exposing (..)
import Project.Detail.Messages exposing (Message(..))


matchList : List (Parser (Page -> a) a)
matchList =
    [ UrlParser.map UpdatePage <| (s "projects" </> string)
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

        DidFetchDetailMessage _ ->
            ( model, Cmd.none )

        DidFileUploadMessage _ ->
            ( model, Cmd.none )

        DidReceiveBase64BodyMessage _ ->
            ( model, Cmd.none )


view : Model -> Html.Html message
view model =
    Html.text <| "project@" ++ model.projectDetail.id


subscriptions : Model -> Sub Message
subscriptions model =
    UploadPorts.receiveFile DidReceiveBase64BodyMessage

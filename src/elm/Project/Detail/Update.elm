module Project.Detail.Update exposing (..)

import RemoteData exposing (..)
import Project.Detail.Model exposing (..)
import Project.Detail.Message exposing (..)
import Project.Detail.Network exposing (fetchProject)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoMsg ->
            ( model, Cmd.none )

        ChangeLocationMsg location ->
            let
                newPage =
                    parseLocation location

                newModel =
                    { model | page = newPage }
            in
                case newPage of
                    WorkbookPage id ->
                        ( newModel, fetchProject id )

                    _ ->
                        ( newModel, Cmd.none )

        FetchMsg id ->
            ( model, fetchProject id )

        FetchAfterMsg response ->
            case response of
                Success detail ->
                    ( { model | detailAsync = response, detail = detail }, Cmd.none )

                _ ->
                    ( { model | detailAsync = response }, Cmd.none )

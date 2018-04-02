module Project.Detail.Update exposing (..)

import Dict exposing (..)
import RemoteData exposing (..)
import Navigation exposing (load)
import Project.Detail.Model exposing (..)
import Project.Detail.Message exposing (..)
import Project.Detail.Network exposing (fetchProject, uploadFile)
import Project.Detail.Ports exposing (fileDragged, fileLoaded)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoMsg ->
            ( model, Cmd.none )

        ChangeLocationMsg location ->
            let
                newPage =
                    parseLocation location
            in
                case newPage of
                    WorkbookPage id ->
                        ( { initModel | page = newPage }, fetchProject id )

                    _ ->
                        ( { model | page = newPage }, Cmd.none )

        FetchMsg id ->
            ( model, fetchProject id )

        FetchAfterMsg response ->
            case response of
                Success detail ->
                    ( { model | detailAsync = response, detail = detail }, Cmd.none )

                _ ->
                    ( { model | detailAsync = response }, Cmd.none )

        DownloadInputFileMsg index ->
            let
                targetJob =
                    case
                        List.head
                            (List.filter
                                (\job -> job.index == index)
                                model.detail.batch
                            )
                    of
                        Just j ->
                            j

                        Nothing ->
                            Job -1 "" "" "" "" [] [] "" ""

                lastInputUrl =
                    targetJob.lastInputUrl
            in
                if lastInputUrl /= "" then
                    ( model, load lastInputUrl )
                else
                    ( model, Cmd.none )

        DragoverMsg index ->
            let
                attachListener jobState =
                    fileDragged

                oldJobState =
                    case Dict.get index model.jobStateDict of
                        Just jobState ->
                            jobState

                        Nothing ->
                            initJobState

                dragoverredJobState =
                    { oldJobState | dragover = True, loaded = True }

                newJobStateDict =
                    Dict.insert index dragoverredJobState model.jobStateDict

                newModel =
                    { model | jobStateDict = newJobStateDict }
            in
                if oldJobState.loaded then
                    ( newModel, Cmd.none )
                else
                    ( newModel, fileDragged (toString index) )

        DragleaveMsg index ->
            let
                -- todo: suppress messages while awaiting remote done
                newJobState =
                    case Dict.get index model.jobStateDict of
                        Just jobState ->
                            { jobState | dragover = False }

                        Nothing ->
                            initJobState

                newDict =
                    Dict.insert index newJobState model.jobStateDict
            in
                ( { model | jobStateDict = newDict }, Cmd.none )

        DropMsg index ->
            let
                newJobState =
                    case Dict.get index model.jobStateDict of
                        Just jobState ->
                            { jobState
                                | dragover = False
                                , awaitingRemoteDone = True
                            }

                        Nothing ->
                            initJobState

                newDict =
                    Dict.insert index newJobState model.jobStateDict
            in
                ( { model | jobStateDict = newDict }, Cmd.none )

        FileLoadedPortMsg packet ->
            let
                loadedFiles =
                    List.map
                        (\p -> Base64File p.name p.body)
                        packet.base64files
            in
                ( model, uploadFile loadedFiles )

        RemoteDoneMsg index ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    fileLoaded FileLoadedPortMsg

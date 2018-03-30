module Project.Detail.Update exposing (..)

import Dict exposing (..)
import RemoteData exposing (..)
import Navigation exposing (load)
import Common.Native.File exposing (subscribeFileDropOn)
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
                            Job -1 "" "" "" ""

                inputUrl =
                    targetJob.inputUrl
            in
                if inputUrl /= "" then
                    ( model, load inputUrl )
                else
                    ( model, Cmd.none )

        DragoverMsg index ->
            let
                newDict =
                    Dict.insert index dragoverJobState model.jobStateDict

                loop m jobs =
                    case jobs of
                        job :: jobsTail ->
                            let
                                m_ =
                                    subscribeFileDropOn
                                        ("dropfield-" ++ (toString job.index))
                                        { preventDefault = True
                                        , stopPropagation = False
                                        }
                                        m
                            in
                                loop m_ jobsTail

                        [] ->
                            m

                modelWithNewDict =
                    { model | jobStateDict = newDict }

                newModel =
                    loop modelWithNewDict modelWithNewDict.detail.batch
            in
                ( newModel, Cmd.none )

        DragleaveMsg index ->
            let
                -- todo: suppress messages while awaiting remote done
                newDict =
                    Dict.remove index model.jobStateDict
            in
                ( { model | jobStateDict = newDict }, Cmd.none )

        DropMsg index ->
            let
                newDict =
                    Dict.insert index awaitingJobState model.jobStateDict
            in
                ( { model | jobStateDict = newDict }, Cmd.none )

        RemoteDoneMsg index ->
            ( model, Cmd.none )

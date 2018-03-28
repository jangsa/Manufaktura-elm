module Project.Update exposing (update)

import RemoteData exposing (..)
import Project.Message exposing (..)
import Project.Model exposing (..)
import Project.Network exposing (..)


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
                    HomePage ->
                        ( newModel, fetchProjects )

                    _ ->
                        ( newModel, Cmd.none )

        FetchMsg ->
            ( model, fetchProjects )

        FetchAfterMsg response ->
            let
                newModel =
                    case response of
                        Success projects ->
                            { model
                                | projectsAsync = response
                                , projects = projects
                                , projectsFiltered = projects
                            }

                        _ ->
                            { model
                                | projectsAsync = response
                            }
            in
                ( newModel, Cmd.none )

        FilterMsg keywords ->
            ( { model
                | projectsFiltered =
                    filterProjects model.projectsFiltered keywords
              }
            , Cmd.none
            )

        OpenCreationMsg ->
            ( { model | overlayState = True }, Cmd.none )

        CloseCreationMsg ->
            ( { model | overlayState = False }, Cmd.none )

        ChangeNameMsg name ->
            let
                oldCreationState =
                    model.creationState

                newCreationState =
                    { oldCreationState | name = name }
            in
                ( { model | creationState = newCreationState }, Cmd.none )

        ChangeDescriptionMsg description ->
            let
                oldCreationState =
                    model.creationState

                newCreationState =
                    { oldCreationState | description = description }
            in
                ( { model | creationState = newCreationState }, Cmd.none )

        ChangeJobNameMsg index jobName ->
            let
                oldCreationState =
                    model.creationState

                oldBatch =
                    oldCreationState.batch

                newBatch =
                    List.map
                        (\( i, ( n, d ) ) ->
                            if i == index then
                                ( i, ( jobName, d ) )
                            else
                                ( i, ( n, d ) )
                        )
                        oldBatch

                newCreationState =
                    { oldCreationState | batch = newBatch }
            in
                ( { model | creationState = newCreationState }, Cmd.none )

        ChangeJobDescriptionMsg index jobDescription ->
            let
                oldCreationState =
                    model.creationState

                oldBatch =
                    oldCreationState.batch

                newBatch =
                    List.map
                        (\( i, ( n, d ) ) ->
                            if i == index then
                                ( i, ( n, jobDescription ) )
                            else
                                ( i, ( n, d ) )
                        )
                        oldBatch

                newCreationState =
                    { oldCreationState | batch = newBatch }
            in
                ( { model | creationState = newCreationState }, Cmd.none )

        AddJobMsg ->
            let
                oldCreationState =
                    model.creationState

                oldBatch =
                    oldCreationState.batch

                newBatch =
                    ( (List.length oldBatch) + 1, ( "", "" ) )
                        :: (List.reverse oldBatch)
                        |> List.reverse

                newCreationState =
                    { oldCreationState | batch = newBatch }
            in
                ( { model | creationState = newCreationState }, Cmd.none )

        RemoveJobMsg index ->
            let
                oldCreationState =
                    model.creationState

                oldBatch =
                    oldCreationState.batch

                newBatchNoIndex =
                    List.filter
                        (\( i, _ ) -> i /= index)
                        oldBatch
                        |> List.map (\( l, r ) -> r)

                newBatch =
                    List.indexedMap
                        (\a -> \b -> ( (a + 1), b ))
                        newBatchNoIndex

                newCreationState =
                    { oldCreationState | batch = newBatch }
            in
                ( { model | creationState = newCreationState }, Cmd.none )

        CreateMsg ->
            ( model, createProject model.creationState )

        CreateAfterMsg response ->
            let
                currentPage =
                    model.page

                initialized =
                    initModel

                newModel =
                    { initialized | page = currentPage }
            in
                ( newModel, fetchProjects )

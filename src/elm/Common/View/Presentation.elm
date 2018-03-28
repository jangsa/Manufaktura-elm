module Common.View.Presentation exposing (..)

import Tuple exposing (first, second)
import Html exposing (..)
import Html.Attributes exposing (..)


simpleTable : List ( List (Attribute message), List (Html message) ) -> List (List ( List (Attribute message), List (Html message) )) -> Html message
simpleTable theadRow tbodies =
    table
        [ class "table-light" ]
        [ thead
            []
            [ tr
                []
                (List.map
                    (\theadColumn ->
                        th []
                            [ label
                                (first theadColumn)
                                (second theadColumn)
                            ]
                    )
                    theadRow
                )
            ]
        , tbody
            []
            (List.map
                (\tbodyRow ->
                    tr
                        []
                        (List.map
                            (\tbodyColumn ->
                                td
                                    (first tbodyColumn)
                                    (second tbodyColumn)
                            )
                            tbodyRow
                        )
                )
                tbodies
            )
        ]

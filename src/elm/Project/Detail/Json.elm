module Project.Detail.Json exposing (..)

import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required, optional, decode)
import Project.Detail.Model exposing (..)


projectDecoder : Decode.Decoder ProjectDetail
projectDecoder =
    decode
        ProjectDetail
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "created" Decode.string
        |> required "batch" (Decode.list jobDecoder)


jobDecoder : Decode.Decoder Job
jobDecoder =
    decode
        Job
        |> required "index" Decode.string
        |> required "name" Decode.string
        |> required "inputUrl" Decode.string
        |> required "outputUrl" Decode.string


projectEncoder : ProjectDetail -> Encode.Value
projectEncoder detail =
    Encode.object
        [ ( "id", Encode.string detail.id )
        , ( "name", Encode.string detail.name )
        , ( "created", Encode.string detail.created )
        , ( "batch", Encode.list <| List.map (\job -> jobEncoder job) detail.batch )
        ]


jobEncoder : Job -> Encode.Value
jobEncoder job =
    Encode.object
        [ ( "index", Encode.string job.index )
        , ( "name", Encode.string job.name )
        , ( "inputUrl", Encode.string job.inputUrl )
        , ( "outputUrl", Encode.string job.outputUrl )
        ]

module Project.Detail.Json exposing (..)

import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required, optional, decode)
import Project.Detail.Model exposing (..)


fileOnServerDecoder : Decode.Decoder FileOnServer
fileOnServerDecoder =
    decode
        FileOnServer
        |> required "filename" Decode.string
        |> required "url" Decode.string


jobDecoder : Decode.Decoder Job
jobDecoder =
    decode
        Job
        |> required "index" Decode.int
        |> required "name" Decode.string
        |> required "description" Decode.string
        |> required "lastInputUrl" Decode.string
        |> required "lastOutputUrl" Decode.string
        |> required "inputUrls" (Decode.list fileOnServerDecoder)
        |> required "outputUrls" (Decode.list fileOnServerDecoder)
        |> required "zippedInputUrl" Decode.string
        |> required "zippedOutputUrl" Decode.string


projectDecoder : Decode.Decoder ProjectDetail
projectDecoder =
    decode
        ProjectDetail
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "description" Decode.string
        |> required "created" Decode.string
        |> required "batch" (Decode.list jobDecoder)


projectEncoderUpstream : ProjectDetail -> Encode.Value
projectEncoderUpstream detail =
    Encode.object
        [ ( "name", Encode.string detail.name )
        , ( "description", Encode.string detail.description )
        , ( "created", Encode.string detail.created )
        , ( "batch", Encode.list <| List.map (\job -> jobEncoder job) detail.batch )
        ]


fileOnServer : FileOnServer -> Encode.Value
fileOnServer fos =
    Encode.object
        [ ( "filename", Encode.string fos.filename )
        , ( "url", Encode.string fos.url )
        ]


jobEncoder : Job -> Encode.Value
jobEncoder job =
    Encode.object
        [ ( "index", Encode.int job.index )
        , ( "name", Encode.string job.name )
        , ( "description", Encode.string job.description )
        , ( "lastInputUrl", Encode.string job.lastInputUrl )
        , ( "lastOutputUrl", Encode.string job.lastOutputUrl )
        , ( "inputUrls", Encode.list <| List.map fileOnServer job.inputUrls )
        , ( "outputUrls", Encode.list <| List.map fileOnServer job.outputUrls )
        , ( "zippedInputUrl", Encode.string job.zippedInputUrl )
        , ( "zippedOutputUrl", Encode.string job.zippedOutputUrl )
        ]


projectEncoderDownstream : ProjectDetail -> Encode.Value
projectEncoderDownstream detail =
    Encode.object
        [ ( "id", Encode.string detail.id )
        , ( "name", Encode.string detail.name )
        , ( "description", Encode.string detail.description )
        , ( "created", Encode.string detail.created )
        , ( "batch", Encode.list <| List.map (\job -> jobEncoder job) detail.batch )
        ]

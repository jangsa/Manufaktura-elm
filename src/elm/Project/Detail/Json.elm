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
        |> required "description" Decode.string
        |> required "created" Decode.string
        |> required "batch" (Decode.list jobDecoder)


jobDecoder : Decode.Decoder Job
jobDecoder =
    decode
        Job
        |> required "index" Decode.int
        |> required "name" Decode.string
        |> required "description" Decode.string
        |> required "inputUrl" Decode.string
        |> required "outputUrl" Decode.string


projectEncoderForRegister : ProjectDetail -> Encode.Value
projectEncoderForRegister detail =
    Encode.object
        [ ( "name", Encode.string detail.name )
        , ( "description", Encode.string detail.description )
        , ( "created", Encode.string detail.created )
        , ( "batch", Encode.list <| List.map (\job -> jobEncoder job) detail.batch )
        ]


projectEncoder : ProjectDetail -> Encode.Value
projectEncoder detail =
    Encode.object
        [ ( "id", Encode.string detail.id )
        , ( "name", Encode.string detail.name )
        , ( "description", Encode.string detail.description )
        , ( "created", Encode.string detail.created )
        , ( "batch", Encode.list <| List.map (\job -> jobEncoder job) detail.batch )
        ]


jobEncoder : Job -> Encode.Value
jobEncoder job =
    Encode.object
        [ ( "index", Encode.int job.index )
        , ( "name", Encode.string job.name )
        , ( "description", Encode.string job.description )
        , ( "inputUrl", Encode.string job.inputUrl )
        , ( "outputUrl", Encode.string job.outputUrl )
        ]

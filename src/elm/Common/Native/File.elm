module Common.Native.File exposing (..)

import Html.Events exposing (Options)
import Native.FileSupporter


subscribeFileDropOn : String -> Options -> a -> a
subscribeFileDropOn =
    Native.FileSupporter.subscribeFileDropOn

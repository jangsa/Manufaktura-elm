module Utility.JsonDecode exposing (..)


stringAt : List String -> Decode.Decoder String
stringAt location =
    Decode.at location Decode.string


intAt : List String -> Decode.Decoder Int
intAt location =
    Decode.at location Decode.int

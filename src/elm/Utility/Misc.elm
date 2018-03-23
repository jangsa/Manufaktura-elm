module Utility.Misc exposing (..)


allInclusive : List String -> List String -> Bool
allInclusive keywords targets =
    List.map
        (\k ->
            List.map
                (\t ->
                    String.contains k t
                )
                targets
                |> List.foldr (||) False
        )
        keywords
        |> List.foldr (&&) True


whiteSplit : String -> List String
whiteSplit phrase =
    String.split " " phrase

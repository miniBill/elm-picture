module Html.Extra exposing (attributeMaybe)

import Html exposing (Attribute)
import Html.Attributes


attributeMaybe : (a -> Attribute msg) -> Maybe a -> Attribute msg
attributeMaybe toAttr value =
    case value of
        Nothing ->
            Html.Attributes.classList []

        Just v ->
            toAttr v

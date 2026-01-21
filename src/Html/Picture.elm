module Html.Picture exposing (picture)

{-|

@docs picture


## Sources

@docs source, Source

-}

import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Extra
import Html.Source as Source exposing (Source)


{-| Create a `picture` tag. The attributes will be placed on the inner `img` tag.
-}
picture :
    List (Attribute msg)
    ->
        { sources : List (Source kind msg)
        , src : String
        , alt : Maybe String
        }
    -> Html msg
picture attrs config =
    Html.node "picture"
        []
        (List.map Source.toHtml config.sources
            ++ [ Html.img
                    (Html.Attributes.src config.src
                        :: Html.Extra.attributeMaybe Html.Attributes.alt config.alt
                        :: attrs
                    )
                    []
               ]
        )

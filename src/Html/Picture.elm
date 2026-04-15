module Html.Picture exposing (picture)

{-|

@docs picture

-}

import Html
import Html.Attributes
import Html.Extra
import Html.Source as Source exposing (Source)


{-| Create a [`picture`](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/picture) tag. The attributes will be placed on the inner [`img`](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/img) tag.
-}
picture :
    List (Html.Attribute msg)
    ->
        { sources : List (Source kind)
        , src : String
        , alt : Maybe String
        }
    -> Html.Html msg
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

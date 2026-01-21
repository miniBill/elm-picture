module Html.Picture exposing
    ( picture
    , source, Source
    )

{-|

@docs picture


## Sources

@docs source, Source

-}

import Css.Media
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Extra
import Html.Picture.ToHtml


{-| -}
type Source msg
    = Source (Html.Picture.ToHtml.Source msg)


{-| -}
source :
    { srcset : String
    , media : Maybe Css.Media.Expression
    , type_ : Maybe String
    , attributes : List (Attribute msg)
    }
    -> Source msg
source =
    Source


{-| -}
picture :
    { sources : List (Source msg)
    , imgAttributes : List (Attribute msg)
    , src : String
    , alt : Maybe String
    }
    -> Html msg
picture config =
    Html.node "picture"
        []
        (List.map
            (\(Source src) -> Html.Picture.ToHtml.sourceToHtml src)
            config.sources
            ++ [ Html.img
                    (Html.Attributes.src config.src
                        :: Html.Extra.attributeMaybe Html.Attributes.alt config.alt
                        :: config.imgAttributes
                    )
                    []
               ]
        )

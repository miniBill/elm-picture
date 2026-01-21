module Html.Picture.ToHtml exposing (Source, sourceToHtml)

import Css.Media as Media
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Extra


type alias Source msg =
    { srcset : String
    , media : Maybe Media.Expression
    , type_ : Maybe String
    , attributes : List (Attribute msg)
    }


sourceToHtml : Source msg -> Html msg
sourceToHtml config =
    Html.source
        (Html.Attributes.attribute "srcset" config.srcset
            :: Html.Extra.attributeMaybe Html.Attributes.media (Maybe.map Media.expressionToString config.media)
            :: Html.Extra.attributeMaybe Html.Attributes.type_ config.type_
            :: config.attributes
        )
        []

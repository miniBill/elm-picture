module Html.Picture.ToHtml exposing (Source, picture, source)

import Css.Media as Media
import Html exposing (Attribute, Html)
import Html.Attributes


type alias Source =
    { srcset : String
    , media : Maybe Media.Expression
    , type_ : Maybe String
    , attributes : List (Attribute msg)
    }


picture :
    { pictureAttributes : List (Attribute msg)
    , sources : List Source
    , imgAttributes : List (Attribute msg)
    , src : String
    , alt : Maybe String
    }
    -> Html msg
picture config =
    Html.node "picture"
        config.pictureAttributes
        (List.map source config.sources
            ++ [ Html.img
                    (Html.Attributes.src config.src
                        :: attrIf Html.Attributes.alt config.alt
                        :: config.imgAttributes
                    )
                    []
               ]
        )


source : Source -> Html msg
source config =
    Html.source
        (Html.Attributes.attribute "srcset" config.srcset
            :: attrIf Html.Attributes.media (Maybe.map Media.expressionToString config.media)
            :: attrIf Html.Attributes.type_ config.type_
            :: config.attributes
        )
        []


attrIf : (a -> Attribute msg) -> Maybe a -> Attribute msg
attrIf toAttr value =
    case value of
        Nothing ->
            Html.Attributes.classList []

        Just v ->
            toAttr v

module Html.Source exposing (Image, Single, Source, WithDensities, WithWidths, fromImagesAndDensities, fromImagesAndWidths, imageWithDensityDescriptor, imageWithWidth, mediaExpressionToString, single, toHtml, withSizes)

{-| -}

import Css exposing (Length)
import Css.Media as Media
import Css.Value exposing (Value(..))
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Extra
import Url exposing (Url)


{-| -}
type Source kind msg
    = Source
        { srcset : String
        , media : Maybe Media.Expression
        , type_ : Maybe String
        , attributes : List (Attribute msg)
        }


type WithWidths
    = WithWidths


type WithDensities
    = WithDensities


type Single
    = Single


type Image
    = ImageWithWidth Url Int
    | ImageWithDensityDescriptor Url Int


imageWithWidth : Url -> Int -> Image
imageWithWidth =
    ImageWithWidth


imageWithDensityDescriptor : Url -> Int -> Image
imageWithDensityDescriptor =
    ImageWithDensityDescriptor


imageToString : Url -> Maybe Int -> String -> String
imageToString url maybeValue specifier =
    case maybeValue of
        Nothing ->
            Url.toString url

        Just value ->
            Url.toString url ++ " " ++ String.fromInt value ++ specifier


{-| Build a `Source` from a single image.
-}
single : Url -> Source Single msg
single image =
    Source
        { srcset = Url.toString image
        , media = Nothing
        , type_ = Nothing
        , attributes = []
        }


{-| Build a `Source` from a set of images with given widths.
-}
fromImagesAndWidths : List { url : Url, width : Maybe Int } -> Source WithWidths msg
fromImagesAndWidths images =
    Source
        { srcset =
            String.join ","
                (List.map
                    (\{ url, width } ->
                        imageToString url width "w"
                    )
                    images
                )
        , media = Nothing
        , type_ = Nothing
        , attributes = []
        }


{-| Build a `Source` from a set of images with given densities.
-}
fromImagesAndDensities : List { url : Url, density : Maybe Int } -> Source WithDensities msg
fromImagesAndDensities images =
    Source
        { srcset =
            String.join ","
                (List.map
                    (\{ url, density } ->
                        imageToString url density "x"
                    )
                    images
                )
        , media = Nothing
        , type_ = Nothing
        , attributes = []
        }


withSizes : List ( Media.Expression, Value Length ) -> Maybe (Value Length) -> Source WithWidths msg -> Source WithWidths msg
withSizes sizes default (Source config) =
    Source
        { config
            | attributes =
                config.attributes
                    ++ [ Html.Attributes.attribute "sizes"
                            (String.join ","
                                (case default of
                                    Nothing ->
                                        List.map lengthToString sizes

                                    Just (Value defaultSize) ->
                                        List.map lengthToString sizes ++ [ defaultSize ]
                                )
                            )
                       ]
        }


lengthToString : ( Media.Expression, Value Length ) -> String
lengthToString ( media, Value length ) =
    mediaExpressionToString media ++ " " ++ length


{-| Convert a `Source` to the corresponding html tag.
-}
toHtml : Source kind msg -> Html msg
toHtml (Source config) =
    Html.source
        (Html.Attributes.attribute "srcset" config.srcset
            :: Html.Extra.attributeMaybe Html.Attributes.media (Maybe.map mediaExpressionToString config.media)
            :: Html.Extra.attributeMaybe Html.Attributes.type_ config.type_
            :: config.attributes
        )
        []


mediaExpressionToString : Media.Expression -> String
mediaExpressionToString expression =
    case expression.value of
        Nothing ->
            "(" ++ expression.feature ++ ")"

        Just value ->
            "(" ++ expression.feature ++ ": " ++ value ++ ")"

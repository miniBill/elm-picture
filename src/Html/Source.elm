module Html.Source exposing
    ( Source
    , single, Single, fromImagesAndWidths, WithWidths, fromImagesAndDensities, WithDensities
    , withSizes, withType, ImageType(..)
    , toHtml
    )

{-|

@docs Source


# Building

@docs single, Single, fromImagesAndWidths, WithWidths, fromImagesAndDensities, WithDensities


# Properties

@docs withSizes, withType, ImageType


# Using

@docs toHtml

-}

import Css
import Css.Media
import Css.Value
import Html
import Html.Attributes
import Html.Extra


{-| A source set of images, used to build a `source` tag.
-}
type Source kind
    = Source
        { srcset : String
        , media : Maybe Css.Media.Expression
        , type_ : Maybe ImageType
        , sizes : Maybe (List String)
        }


{-| A source defined using widths (`300w`).
-}
type WithWidths
    = WithWidths


{-| A source defined using densities (`2x`).
-}
type WithDensities
    = WithDensities


{-| A source comprised of a single image.
-}
type Single
    = Single


imageToString : String -> Maybe Int -> String -> String
imageToString url maybeValue specifier =
    case maybeValue of
        Nothing ->
            url

        Just value ->
            url ++ " " ++ String.fromInt value ++ specifier


{-| Build a `Source` from a single image.
-}
single : String -> Source Single
single image =
    Source
        { srcset = image
        , media = Nothing
        , type_ = Nothing
        , sizes = Nothing
        }


{-| Build a `Source` from a set of images with given widths.
-}
fromImagesAndWidths : List { url : String, width : Maybe Int } -> Source WithWidths
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
        , sizes = Nothing
        }


{-| Build a `Source` from a set of images with given densities.
-}
fromImagesAndDensities : List { url : String, density : Maybe Int } -> Source WithDensities
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
        , sizes = Nothing
        }


{-| Set the `size` attribute. The second argument is the (optional) default size.
-}
withSizes : List ( Css.Media.Expression, Css.Value.Value Css.Length ) -> Maybe (Css.Value.Value Css.Length) -> Source WithWidths -> Source WithWidths
withSizes sizes default (Source config) =
    Source
        { config
            | sizes =
                Just
                    (case default of
                        Nothing ->
                            List.map lengthToString sizes

                        Just (Css.Value.Value defaultSize) ->
                            List.map lengthToString sizes ++ [ defaultSize ]
                    )
        }


{-| Image types supported
-}
type ImageType
    = APNG
    | AVIF
    | BMP
    | GIF
    | ICO
    | JPEG
    | JPEG_XL
    | PNG
    | SVG
    | TIFF
    | WebP


{-| Set the `type` attribute.
-}
withType : ImageType -> Source kind -> Source kind
withType type_ (Source config) =
    Source { config | type_ = Just type_ }


lengthToString : ( Css.Media.Expression, Css.Value.Value Css.Length ) -> String
lengthToString ( media, Css.Value.Value length ) =
    mediaExpressionToString media ++ " " ++ length


{-| Convert a `Source` to the corresponding html tag.
-}
toHtml : Source kind -> Html.Html msg
toHtml source =
    Html.source (toAttributes source) []


{-| Convert a `Source` to the attributes you need to build the corresponding `source`.
-}
toAttributes : Source kind -> List (Html.Attribute msg)
toAttributes (Source config) =
    [ Html.Attributes.attribute "srcset" config.srcset
    , Html.Extra.attributeMaybe Html.Attributes.media (Maybe.map mediaExpressionToString config.media)
    , Html.Extra.attributeMaybe Html.Attributes.type_ (Maybe.map imageTypeToString config.type_)
    , Html.Extra.attributeMaybe (Html.Attributes.attribute "sizes") (Maybe.map (String.join ",") config.sizes)
    ]


imageTypeToString : ImageType -> String
imageTypeToString type_ =
    case type_ of
        APNG ->
            "image/apng"

        AVIF ->
            "image/avif"

        BMP ->
            "image/bmp"

        GIF ->
            "image/gif"

        ICO ->
            "image/x-icon"

        JPEG ->
            "image/jpeg"

        JPEG_XL ->
            "image/jxl"

        PNG ->
            "image/png"

        SVG ->
            "image/svg+xml"

        TIFF ->
            "image/tiff"

        WebP ->
            "image/webp"


mediaExpressionToString : Css.Media.Expression -> String
mediaExpressionToString expression =
    case expression.value of
        Nothing ->
            "(" ++ expression.feature ++ ")"

        Just value ->
            "(" ++ expression.feature ++ ": " ++ value ++ ")"

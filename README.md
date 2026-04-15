# elm-picture

Easily generate `picture` tags in Elm.

```elm
picture : Html msg
picture =
    Html.Picture.picture
        [Html.Attributes.width 1024
        , Html.Attributes.height 768
        ]
        { sources =
            [ Html.Source.single "flower.avif" |> Html.Source.withType Html.Source.AVIF
            , Html.Source.single "flower.jpeg" |> Html.Source.withType Html.Source.JPEG
            , Html.Source.single "flower.webp" |> Html.Source.withType Html.Source.WEBP
            ]
        , src = "flower.png"
        , alt = Nothing
        }
```

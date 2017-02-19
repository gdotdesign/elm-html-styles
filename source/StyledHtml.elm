module StyledHtml exposing (node)

import Html.Attributes exposing (property)
import Html

import Json.Encode as Json

import Native.Styles

node : String -> List (String, String) -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
node tag styles attributes children =
  let
    encodeStyle (prop, value) =
      Json.list [ Json.string prop, Json.string value ]

    encodedStyles =
      styles
      |> List.map encodeStyle
      |> Json.list

    styleAttribute =
      property "styles" encodedStyles
  in
    Html.node tag (styleAttribute :: attributes) children

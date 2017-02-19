module StyledHtml exposing (node, style, selector, pseudo)

import Html.Attributes exposing (property)
import Html

import Json.Encode as Json

import Native.Styles

type Selector
  = None
  | Child String
  | Pseudo String

type alias Style =
  { selector : Selector
  , data : List (String, String)
  }

style : List (String, String) -> Style
style =
  Style None

selector : String -> List (String, String) -> Style
selector string =
  Style (Child string)

pseudo : String -> List (String, String) -> Style
pseudo string =
  Style (Pseudo string)

encodeStyles : List Style -> Json.Value
encodeStyles styles =
  let
    isChild style =
      case style.selector of
        Child _ -> True
        _ -> False

    isPseudo style =
      case style.selector of
        Pseudo _ -> True
        _ -> False

    isNone style =
      case style.selector of
        None -> True
        _ -> False

    baseData =
      styles
      |> List.filter isNone
      |> List.map .data
      |> List.foldr (++) []
      |> encodeData

    encodeItem item =
      let
        selector =
          case item.selector of
            Pseudo value -> value
            Child value -> value
            _ -> ""
      in
        Json.object
        [ ("selector", Json.string selector )
        , ("data", encodeData item.data)
        ]

    pseudos =
      styles
      |> List.filter isPseudo
      |> List.map encodeItem
      |> Json.list

    childs =
      styles
      |> List.filter isChild
      |> List.map encodeItem
      |> Json.list

    encodeStyle (prop, value) =
      Json.list [ Json.string prop, Json.string value ]

    encodeData data =
      data
      |> List.map encodeStyle
      |> Json.list
  in
    Json.object
      [ ("data", baseData)
      , ("pseudos", pseudos)
      , ("childs", childs)
      ]

node : String -> List Style -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
node tag styles attributes children =
  let
    styleAttribute =
      property "styles" (encodeStyles styles)
  in
    Html.node tag (styleAttribute :: attributes) children

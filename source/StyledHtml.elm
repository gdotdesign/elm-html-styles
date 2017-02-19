module StyledHtml exposing (styles, selector, pseudo)

import Html.Attributes exposing (property)
import Html

import Json.Encode as Json

import Native.Styles

type Selector
  = Child String
  | Pseudo String

type alias Style =
  { selector : Selector
  , data : List (String, String)
  }

selector : String -> List (String, String) -> Style
selector string =
  Style (Child string)

pseudo : String -> List (String, String) -> Style
pseudo string =
  Style (Pseudo string)

encodeStyles : List (String, String) -> List Style -> Json.Value
encodeStyles selfStyles styles =
  let
    isChild style =
      case style.selector of
        Child _ -> True
        _ -> False

    isPseudo style =
      case style.selector of
        Pseudo _ -> True
        _ -> False

    baseData =
      selfStyles
      |> encodeData

    encodeItem item =
      let
        selector =
          case item.selector of
            Pseudo value -> value
            Child value -> value
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

styles : List (String, String) -> List Style -> Html.Attribute msg
styles selfStyles styles =
  property "styles" (encodeStyles selfStyles styles)

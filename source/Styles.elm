module Styles exposing (styles, selector, pseudo)

{-| This module provides a way to add CSS styles to your HTML elements easily.

@docs styles, selector, pseudo
-}
import Html.Attributes exposing (property)
import Html

import Json.Encode as Json

import Native.Styles

{-| Representation of sub selector. It can either be a normal selector like
"span", "+ span", "> button" etc... or a pseudo selector like "::before",
"::after", etc...
-}
type Selector
  = Child String
  | Pseudo String


{-| Representation of a sub style.
-}
type alias Style =
  { selector : Selector
  , data : List (String, String)
  }


{-| Returns an attribute that applies the given css styles and sub selectors to
the given element.

    div
      [ styles
        [ ( "font-size", "20px" )
        , ( "line-height", "26px" )
        , ( "color", "#555" )
        ]
        [ selector "span"
          [ ( "color", "red" )
          ]
        , pseudo "::before"
          [ ( "content", "'Before here!!!'" )
          ]
        ]
      ]
      [ text "Hello there."
      , span [] [ text "this is a span" ]
      ]

-}
styles : List (String, String) -> List Style -> Html.Attribute msg
styles selfStyles styles =
  property "styles" (encodeStyles selfStyles styles)


{-| Returns a sub selector to use in an elements styles.
-}
selector : String -> List (String, String) -> Style
selector string =
  Style (Child string)


{-| returns a pseudo selector to use in an elements styles.
-}
pseudo : String -> List (String, String) -> Style
pseudo string =
  Style (Pseudo string)


{-| Encodes the data for the styles property.
-}
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
        [ ( "selector", Json.string selector )
        , ( "data",     encodeData item.data )
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
      [ ( "data",    baseData )
      , ( "pseudos", pseudos  )
      , ( "childs",  childs   )
      ]

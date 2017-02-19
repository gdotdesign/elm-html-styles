import StyledHtml exposing (node, style, selector, pseudo)

import Html.Events exposing (onClick)
import Html exposing (text)
import Html.Lazy

import Mouse

type alias Model =
  { show : Bool }

type Msg = Toggle
  | Move Mouse.Position

init : Model
init =
  { show = False }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg_ model =
  case msg_ of
    Move pos ->
      (model, Cmd.none)

    Toggle ->
      ({ model | show = not model.show }, Cmd.none)

view : Model -> Html.Html Msg
view model =
  let
    child =
      if model.show then
        node "strong"
          [ style [("color", "cyan")]
          , pseudo "::before"
            [ ("content", "'Hello'")
            , ("color", "rebeccapurple")
            , ("font-weight", "bold")
            ]
          , selector "i"
            [ ("letter-spacing", "10px")]
          ]
          []
          [ node "i" [] [] [text "strong"] ]
      else
        text ""

    display =
      if model.show then
        "block"
      else
        "none"
  in
    node "div"
      [ style
        [ ("background", "red")
        , ("position", "absolute")
        , ("padding", "20px")
        , ("font-family", "sans")
        ]
      ]
      []
      [ node "span"
        [ style
          [("font-size", "20px")
          ,("display", display)
          ,("color", "#FFF")
          ]
        ]
        []
        [text "Blah"]
      , child
      , node "button"
        [ style
          [ ("background", "blue")
          , ("border", "0")
          , ("color", "#FFF")
          ]
        ]
        [ onClick Toggle ]
        [ text "Toggle" ]
      ]


main =
  Html.program
    { init = (init, Cmd.none)
    , update = update
    , view = Html.Lazy.lazy view
    , subscriptions = \_ -> Sub.none --Mouse.moves Move
    }

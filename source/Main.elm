import StyledHtml

import Html.Attributes exposing (style)
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
    display =
      if model.show then
        "block"
      else
        "none"
  in
    StyledHtml.node "div"
      [ ("background", "red")
      , ("position", "absolute")
      , ("padding", "20px")
      , ("font-family", "sans")
      ]
      []
      [ StyledHtml.node "span"
        [("font-size", "20px")
        ,("display", display) ]
        []
        [text "Blah"]
      , StyledHtml.node "button"
        [ ("background", "blue")
        , ("border", "0")
        , ("color", "#FFF")
        ]
        [ onClick Toggle ]
        [ text "Toggle" ]
      ]


main =
  Html.program
    { init = (init, Cmd.none)
    , update = update
    , view = Html.Lazy.lazy view
    , subscriptions = \_ -> Mouse.moves Move
    }

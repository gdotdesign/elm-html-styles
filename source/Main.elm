import StyledHtml

import Html.Attributes exposing (style)
import Html exposing (text)
import Mouse

type alias Model = Mouse.Position

type Msg = Move Mouse.Position

init : Model
init =
  { x = 0, y = 0 }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg_ model =
  case msg_ of
    Move pos -> (pos, Cmd.none)

view : Model -> Html.Html Msg
view model =
  StyledHtml.node "div"
    [ ("background", "red")
    , ("position", "absolute")
    , ("left", (toString model.x) ++ "px")
    , ("top", (toString model.y) ++ "px")
    ]
    []
    [text "hello"]


main =
  Html.program
    { init = (init, Cmd.none)
    , update = update
    , view = view
    , subscriptions = \_ -> Mouse.moves Move
    }

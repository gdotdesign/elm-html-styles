import Html.Styles exposing (styles, selector, pseudo)
import Html.Events exposing (onClick)
import Html exposing (node, text)
import Html.Lazy

import Spec exposing (..)

type alias Model =
  { show : Bool }

type Msg
  = Toggle

init : () -> Model
init _ =
  { show = False }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg_ model =
  case msg_ of
    Toggle ->
      ({ model | show = not model.show }, Cmd.none)

view : Model -> Html.Html Msg
view model =
  let
    child =
      if model.show then
        node "strong"
          [ styles
            [("color", "cyan")]
            [ pseudo "::before"
              [ ("content", "'Hello'")
              , ("color", "rebeccapurple")
              , ("font-weight", "bold")
              ]
            , selector "i"
              [ ("letter-spacing", "10px")]
            ]
          ]
          [ node "i" [] [text "strong"] ]
      else
        text ""

    display =
      if model.show then
        "block"
      else
        "none"
  in
    node "div"
      [ styles
        [ ("background", "red")
        , ("padding", "20px")
        , ("font-family", "sans")
        ]
        []
      ]
      [ node "span"
        [ styles
          [("font-size", "20px")
          ,("display", display)
          ,("color", "#FFF")
          ]
          []
        ]
        [text "Blah"]
      , child
      , node "button"
        [ styles
          [ ("background", "blue")
          , ("border", "0")
          , ("color", "#FFF")
          ]
          []
        , onClick Toggle
        ]
        [ text "Toggle" ]
      ]

specs =
  describe "Html.Styles"
    [ it "Applies base styles"
      [ assert.styleEquals
        { style = "background"
        , selector = "div"
        , value = "red"
        }
      , assert.styleEquals
        { style = "padding"
        , selector = "div"
        , value = "20px"
        }
      ]
    , it "Applies sub selectors"
      [ steps.click "button"
      , assert.styleEquals
        { style = "letter-spacing"
        , selector = "i"
        , value = "10px"
        }
      ]
    ]

main =
  runWithProgram
    { subscriptions = \_ -> Sub.none
    , update = update
    , view = view
    , init = init
    } specs

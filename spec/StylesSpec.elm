import Html.Styles exposing (styles, selector, pseudo)
import Html.Events exposing (onClick)
import Html exposing (node, text)
import Html.Lazy

import Spec exposing (..)

type alias Model =
  { show : Bool
  , replace : Bool
  }

type Msg
  = Toggle
  | Replace

init : () -> Model
init _ =
  { show = False
  , replace = False
  }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg_ model =
  case msg_ of
    Replace ->
      ({ model | replace = not model.replace }, Cmd.none)
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
            , selector "i"
              [ ( "overflow", "hidden" )
              ]
            ]
          ]
          [ node "i" [] [text "strong"] ]
      else
        text ""

    display =
      if model.show then
        []
      else
        [( "display", "none" )]
  in
    if model.replace then
      node "div" []
        [ node "button"
          [ styles
            [ ("background", "blue")
            , ("border", "0")
            , ("color", "#FFF")
            ]
            []
          , onClick Replace
          ]
          [ text "Replace" ]
        ]
    else
      node "div"
        [ styles
          [ ("background", "red")
          , ("padding", "20px")
          , ("font-family", "sans")
          ]
          [ selector "33invalid"
            [ ( "opacity", "0.6" )
            ]
          ]
        ]
        [ node "span"
          [ styles
            ([("font-size", "20px")
            ,("color", "#FFF")
            ] ++ display)
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
        , node "button"
          [ styles
            [ ("background", "blue")
            , ("border", "0")
            , ("color", "#FFF")
            ]
            []
          , onClick Replace
          ]
          [ text "Replace" ]
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
    , it "Removes not used properties"
      [ assert.styleEquals
        { style = "display"
        , selector = "span"
        , value = "none"
        }
      , steps.click "button"
      , assert.styleEquals
        { style = "display"
        , selector = "span"
        , value = ""
        }
      ]
    , it "Applies sub selectors"
      [ steps.click "button"
      , assert.styleEquals
        { style = "letter-spacing"
        , selector = "i"
        , value = "10px"
        }
      , assert.styleEquals
        { style = "overflow"
        , value = "hidden"
        , selector = "i"
        }
      ]
    , it "Clears element"
      [ assert.styleEquals
        { style = "background"
        , selector = "div"
        , value = "red"
        }
      , steps.click "button:last-of-type"
      , assert.styleEquals
        { style = "background"
        , selector = "div"
        , value = ""
        }
      , steps.click "button:last-of-type"
      , assert.styleEquals
        { style = "background"
        , selector = "div"
        , value = "red"
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

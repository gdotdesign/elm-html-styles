import Html.Styles exposing (..)
import Html exposing (..)

main =
  div
  [ styles
    [ ( "background", "red" )
    , ( "height", "200px" )
    , ( "width", "200px" )
    ]
    [ pseudo "::before"
      [ ( "content", "'Hello'" )
      , ( "font-size", "20px" )
      ]
    , selector "span"
      [ ( "color", "blue" )
      ]
    ]
  ]
  [ span [] [ text "I'm a span!" ]
  ]

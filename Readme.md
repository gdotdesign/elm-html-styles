# elm-html-styles
[![Build Status](https://travis-ci.org/gdotdesign/elm-html-styles.svg?branch=master)](https://travis-ci.org/gdotdesign/elm-html-styles)
![Elm Package Version](https://img.shields.io/badge/elm%20package-1.1.1-brightgreen.svg)

This package helps you to add CSS styles simply and dynamically to HTML
elements.

## Installation
Add `gdotdesign/elm-html-styles` to your dependencies:

```json
"dependencies": {
  "gdotdesign/elm-html-styles": "1.0.0 <= v < 2.0.0"
}
```

And install with [elm-github-install](https://github.com/gdotdesign/elm-github-install)
using the `elm-install` command.

## Usage
This package provides the `Html.Styles` module which exposes the following
three functions:

#### `styles : List (String, String) -> List Style -> Html.Attribute msg`
This function takes two arguments:

* the first is a list of property-value pairs (tuple) which will be applied to
  the main element (this is much like the `Html.Attribute.style` function)
* the second is a list of sub selectors where each can be either a sub selector
  (like descendant or child selector) or a pseudo selector

#### `pseudo : String -> List (String, String) -> Style`
This functions returns a `Style` to use in the `styles` function above, it is
used to style pseudo elements of the main element. It takes two arguments:

* the first is the pseudo selector `::before`, `::after`, `::placeholder`, etc...
* the second are the property-value paris (tuple) for the selector

#### `selector : String -> List (String, String) -> Style`
This functions returns a `Style` to use in the `styles` function above, it is
used to style sub elements of the main element. It takes two arguments:

* the first is the pseudo selector `span`, `> div`, `li + li`, etc...
* the second are the property-value paris (tuple) for the selector

## Example
This is a minimal example on how to use this package:

```elm
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

```

The HTML equivalent of the following example:

```html
<style>
  .s-001 {
    background: red;
    height: 200px;
    width: 200px;
  }

  .s-001::before {
    content: 'Hello';
    font-size: 20px
  }

  .s-001 span {
    color: blue;
  }
</style>
<div class="s-001">
  <span>I'm a span!</span>
</div>
```

## FAQ

#### Does this package provide functions for CSS properties or values like `elm-css` does?
No it just provides a way to apply the styles, how do you get them is up to you.

#### Does it support `@keyframes`, `@media`, `@import` or `@font-face` rules?
Not at this time. Support for these will be in a later version.

## How it works?
In short it uses some parts of [CSSOM](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Object_Model)
to provide virtual-dom like implementation for styles.

A more detalied explanation:

* A `style` tag is created and appended to the `head`

* A new setter `styles` is added to `Element.prototype` which does the following:
  * it creates a unique class for it's element `s-000`
  * using the previously created `style` tag, it creates rules for it's CSS and
    it's selectors CSS and stores the reference to them
  * in a subsequent render the rules are updates with new data

* `Element.prototype.removeChild` and `Element.prototype.replaceChild` functions
  are patched so when removing an element the created rules for it are
  also removed.

* The data for the styles are converted to a JS object with `Json.Encode` and then
  passed to the `Element.prototype.styles` with `Html.Attribute.property`
  function.

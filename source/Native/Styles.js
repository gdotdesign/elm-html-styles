/* eslint-env browser */

(function () {
  // Set up "global" variables that tracks the ID and the rules
  var currentID = 0
  var rules = {}

  // Create a style tag to hold the styles and append it to the HEAD
  var styleElement = document.createElement('style')
  document.head.appendChild(styleElement)

  /* This function sets the styles for an element with the given ID using the
     provided selector and style data.
  */
  var setStyle = function (id, selector, data) {
    // Get the rule object
    var rule = getRule(id, selector)

    // Get the styles object
    var style = rule.style

    var i, j

    // Remove non existent styles
    for (i = 0; i < (rule.previousData || []).length; i++) {
      var index = data.findIndex(function (item) {
        return item[0] === rule.previousData[i][0]
      })

      if (index === -1) {
        style.removeProperty(rule.previousData[i][0])
      }
    }

    // Set the styles
    for (i = 0; i < data.length; i++) {
      var prop = data[i][0]
      var value = data[i][1]

      var oldValue = null
      for (j = 0; j < (rule.previousData || []).length; j++) {
        if (rule.previousData[j][0] === prop) {
          oldValue = rule.previousData[j][1]
          break
        }
      }

      if (oldValue !== value) {
        style.setProperty(prop, value)
      }
    }

    rule.previousData = data
  }

  /* This function returns a [rule](https://developer.mozilla.org/en-US/docs/Web/API/CSSRule)
     object for an element with the given ID using the provided selector.
  */
  var getRule = function (id, selector) {
    // Create empty object for the rules selectors
    if (!rules[id]) { rules[id] = {} }

    // Don't create the rule if there is one but return it instead
    if (rules[id][selector]) { return rules[id][selector] }

    // Create the rule
    styleElement.sheet.insertRule('.' + (id + selector) + '{}', 0)
    var rule = styleElement.sheet.cssRules[0]

    // Store the rule
    rules[id][selector] = rule

    // Return the rule
    return rule
  }

  /* Remove all rules related to the given child */
  var removeRule = function (child) {
    // Exit if there is nothing to do
    if (!child.__styleID) { return }

    // Clear rules
    clearRule(child)

    // Remove references
    delete rules[child.__styleID]
    delete child.__styleID
  }

  /* Removes all rules for a given element */
  var clearRule = function (child) {
    // Exit if there is nothing to do
    if (!child.__styleID) { return }

    // Iterate over the rules for the element
    var childRules = rules[child.__styleID]

    for (var key in childRules) {
      // Get the rule
      var rule = childRules[key]

      // Remove the rule
      styleElement.sheet.deleteRule(rule)
    }

    // Remove references
    rules[child.__styleID] = {}
  }

  /* Patch removeChild and replaceChild to remove styles for an element
     if it's removed from the DOM. (only these are used in elm-lang/virtual-dom)
  */
  Element.prototype.oldRemoveChild = Element.prototype.removeChild
  Element.prototype.removeChild = function (child) {
    removeRule(child)
    return this.oldRemoveChild(child)
  }

  Element.prototype.oldReplaceChild = Element.prototype.replaceChild
  Element.prototype.replaceChild = function (newNode, child) {
    removeRule(child)
    return this.oldReplaceChild(newNode, child)
  }

  /* Create a setter for a property so we can apply styles to it's element
     from Elm:

        { data : List (String, String)
        , pseudos : List { selector : String, data : List (String, String ) }
        , childs : List { selector : String, data : List (String, String ) }
        }
  */
  Object.defineProperty(Element.prototype, 'styles', {
    get: function () { null },
    set: function (styles) {
      // Clear rules if there is no next styles
      if (!styles) { return clearRule(this) }

      // Create a unique id for the element
      if (!this.__styleID) {
        this.__styleID = 's-' + (currentID++)
        this.classList.add(this.__styleID)
      }

      // Apply the basic styles
      setStyle(this.__styleID, '', styles.data)

      var i

      // Itarate over the child selectors and apply their styles
      for (i = 0; i < styles.childs.length; i++) {
        var child = styles.childs[i]
        setStyle(this.__styleID, ' ' + child.selector, child.data)
      }

      // Iterate over the pseudo selectors and apply their styles
      for (i = 0; i < styles.pseudos.length; i++) {
        var pseudo = styles.pseudos[i]
        setStyle(this.__styleID, pseudo.selector, pseudo.data)
      }
    }
  })
}())

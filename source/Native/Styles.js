var _gdotdesign$elm_styled_html$Native_Styles = function() {
  var currentID = 0
  var rules = {}

  window.rules= rules

  var styleElement = document.createElement('style')
  document.head.appendChild(styleElement)

  var setStyle = function(id, selector, data) {
    // Get rule
    var rule = getRule(id, selector)

    // Get styles
    var style = rule.style

    // Set styles
    for (var i = 0; i < data.length; i++) {
      var prop = data[i][0]
      var value = data[i][1]
      if(style.getPropertyValue(prop) != value){
        style.setProperty(prop, value)
      }
    }
  }

  var getRule = function(id, selector) {
    // Create empty object for the rules selectors
    if(!rules[id]) { rules[id] = {} }

    // Don't create rule if there is one
    if(rules[id][selector]) { return rules[id][selector] }

    // Create rule
    styleElement.sheet.insertRule('.' + (id + selector) + '{}', 0)
    var rule = styleElement.sheet.cssRules[0]

    // Store rule
    rules[id][selector] = rule

    // Return rule
    return rule
  }

  var removeRule = function(child){
    if(child.__styleID) {
      var childRules = rules[child.__styleID]

      for (var key in childRules) {
        var rule = childRules[key]
        styleElement.sheet.deleteRule(rule)
      }

      delete rules[child.__styleID]
    }
  }

  Element.prototype.oldRemoveChild = Element.prototype.removeChild
  Element.prototype.removeChild = function(child){
    removeRule(child)
    return this.oldRemoveChild(child)
  }

  Element.prototype.oldReplaceChild = Element.prototype.replaceChild
  Element.prototype.replaceChild = function(newNode, child){
    removeRule(child)
    return this.oldReplaceChild(newNode, child)
  }

  Object.defineProperty(Element.prototype, 'styles', {
    set: function(styles){
      if (!this.__styleID) {
        this.__styleID = 's-' + (currentID++)
        this.classList.add(this.__styleID)
      }

      setStyle(this.__styleID, '', styles.data)

      for (var i = 0; i < styles.childs.length; i++) {
        var child = styles.childs[i]
        setStyle(this.__styleID, ' ' + child.selector, child.data)
      }

      for (var i = 0; i < styles.pseudos.length; i++) {
        var pseudo = styles.pseudos[i]
        setStyle(this.__styleID, pseudo.selector, pseudo.data)
      }
    }
  })
}()

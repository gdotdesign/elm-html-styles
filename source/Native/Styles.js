var _gdotdesign$elm_styled_html$Native_Styles = function() {
  var currentID = 0

  var styleElement = document.createElement('style')
  document.head.appendChild(styleElement)

  var createRule = function(id) {
    styleElement.sheet.insertRule('.' + id + '{}', 0)
    return styleElement.sheet.cssRules[0]
  }

  var removeRule = function(child){
    if(child.__styleNode) {
      child.__styleNode.parentStyleSheet.deleteRule(child.__styleNode)
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
    set: function(values){
      if (!values.length) { return }
      if (!this.__styleNode) {
        var id = 's-' + (currentID++)
        this.classList.add(id)
        this.__styleNode = createRule(id)
      }

      var style = this.__styleNode.style

      for (var i = 0; i < values.length; i++) {
        var prop = values[i][0]
        var value = values[i][1]
        if(style.getPropertyValue(prop) != value){
          style.setProperty(prop, value)
        }
      }
    }
  })
}()

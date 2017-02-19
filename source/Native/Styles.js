var nextId = (function() {
  var nextIndex = [0,0,0];
  var chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  var num = chars.length;

  return function() {
    var a = nextIndex[0];
    var b = nextIndex[1];
    var c = nextIndex[2];
    var id = chars[a] + chars[b] + chars[c];

    a = ++a % num;

    if (!a) {
      b = ++b % num;

      if (!b) {
        c = ++c % num;
      }
    }
    nextIndex = [a, b, c];
    return id;
  }
}());
window.nextId = nextId

var _gdotdesign$elm_styled_html$Native_Styles = function() {
  var styleElement = document.createElement('style')
  document.head.appendChild(styleElement)

  var createRule = function(id) {
    styleElement.sheet.insertRule('.' + id + '{}', 0)
    return styleElement.sheet.rules[0]
  }

  Object.defineProperty(HTMLElement.prototype, 'styles', {
    set: function(values){
      if (!values.length) { return }
      if (!this.__styleNode) {
        var id = 's-' + nextId()
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

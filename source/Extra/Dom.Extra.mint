module Dom.Extra {
  fun getAttribute (name : String, element : Dom.Element) : String {
    `element.getAttribute(name) || ""`
  }

  fun setStyle (name : String, value : String, element : Dom.Element) : Dom.Element {
    `
    (() => {
      #{element}.style[#{name}] = #{value}
      return #{element}
    })()
    `
  }

  fun getElementFromPoint (left : Number, top : Number) : Maybe(Dom.Element) {
    `
    (() => {
      const element = document.elementFromPoint(left, top)

      if (element) {
        return new Just(element)
      } else {
        return new Nothing()
      }
    })()
    `
  }

  fun focus (timeout : Number, element : Dom.Element) : Promise(Never, Void) {
    sequence {
      Timer.timeout(timeout, "")
      `element.focus() && element`
    }
  }

  fun containedInSelector (selector : String, element : Dom.Element) : Bool {
    `
    (() => {
      for (let base of document.querySelectorAll(selector)) {
        if (base.contains(element)) {
          return true
        }
      }

      return false
    })()
    `
  }

  fun contains (element : Dom.Element, base : Dom.Element) : Bool {
    `base.contains(element)`
  }
}

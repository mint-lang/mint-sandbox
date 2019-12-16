record Provider.Shortcuts.Shortcut {
  action : Function(Promise(Never, Void)),
  condition : Function(Bool),
  shortcut : Array(Number),
  bypassFocused : Bool
}

record Provider.Shortcuts.Subscription {
  shortcuts : Array(Provider.Shortcuts.Shortcut)
}

provider Provider.Shortcuts : Provider.Shortcuts.Subscription {
  fun actions (event : Html.Event) : Void {
    `
     (() => {
      /* Start the combo with the pressed key */
      const combo = [#{event.keyCode}]

      /* Add 17 if control is pressed. */
      if (#{event.ctrlKey} && #{event.keyCode} != 17) { combo.push(17) }

      /* Add 16 if shift is pressed. */
      if (#{event.shiftKey} && #{event.keyCode} != 16) { combo.push(16) }

      this.subscriptions.forEach((subscription) => {
        subscription.shortcuts.forEach((data) => {
          if (_compare(data.shortcut.sort(), combo.sort()) && data.condition()) {
            if (!document.querySelector("*:focus") || data.bypassFocused) {
              event.preventDefault()
              event.stopPropagation()
              data.action()
            }
          }
        })
      })
    })()
    `
  }

  fun attach : Void {
    `
    (() => {
      const actions = this._actions || (this._actions = #{actions}.bind(this))
      window.addEventListener("keydown", actions, true)
    })()
    `
  }

  fun detach : Void {
    `
    (() => {
      window.removeEventListener("keydown", this._actions, true)
    })()
    `
  }
}

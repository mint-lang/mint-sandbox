store Stores.Editor {
  state value : Maybe(String) = Maybe::Nothing
  state title : Maybe(String) = Maybe::Nothing
  state timestamp : Number = `+new Date()`

  fun setValue (value : String) : Promise(Void) {
    next { value: Maybe::Just(value) }
  }

  fun setTitle (value : String) : Promise(Void) {
    next { title: Maybe::Just(value) }
  }

  fun reset {
    next
      {
        timestamp: `+new Date()`,
        value: Maybe::Nothing
      }
  }
}

store Stores.Editor {
  state timestamp : Number = `+new Date()`
  state value : Maybe(String) = Maybe::Nothing
  state title : Maybe(String) = Maybe::Nothing

  fun setValue (value : String) : Promise(Never, Void) {
    next { value = Maybe::Just(value) }
  }

  fun setTitle (value : String) : Promise(Never, Void) {
    next { title = Maybe::Just(value) }
  }

  fun reset {
    next
      {
        value = Maybe::Nothing,
        timestamp = `+new Date()`
      }
  }
}

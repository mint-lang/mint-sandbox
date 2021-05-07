component Page {
  property children : Array(Html) = []
  property fill : Bool = false

  style base {
    border-top: 0.125em solid var(--faded-color);
    margin-top: 0.5em;
    display: grid;

    if (!fill) {
      padding-top: 2em;
    }

    > * {
      if (fill) {
        display: grid;
      }
    }
  }

  fun render : Html {
    <div::base>
      <Ui.Content>
        <{ children }>
      </Ui.Content>
    </div>
  }
}

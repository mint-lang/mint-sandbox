component Notification {
  property data : Notification = {
    contents = <></>,
    duration = 0
  }

  state shown : Bool = false

  style base {
    box-shadow: 0 0 10px rgba(0,0,0,0.2);
    transition: #{transition};
    transform: #{transform};
    overflow: visible;
    height: #{height};
    font-weight: 600;

    margin-bottom: 10px;
  }

  style content {
    background: rgba(17, 17, 17, 0.9);
    border-radius: 2px;
    padding: 14px 24px;
    cursor: pointer;
    display: block;
    color: #FFF;

    @media (max-width: 900px) {
      font-size: 14px;
    }
  }

  get transition : String {
    if (shown) {
      "transform 320ms"
    } else {
      "transform 320ms, height 320ms 200ms"
    }
  }

  get transform : String {
    if (shown) {
      "translateX(0)"
    } else {
      "translateX(100%) translateX(20px)"
    }
  }

  get height : String {
    if (shown) {
      try {
        rect =
          content
          |> Maybe.withDefault(Dom.createElement("div"))
          |> Dom.getDimensions()

        Number.toString(rect.height) + "px"
      }
    } else {
      "0"
    }
  }

  get opacity : Number {
    if (shown) {
      1
    } else {
      0
    }
  }

  fun componentDidMount : Promise(Never, Void) {
    sequence {
      Timer.nextFrame("")
      next { shown = true }
      Timer.timeout(data.duration - 520, "")
      next { shown = false }
    }
  }

  fun handleClick : Promise(Never, Void) {
    next { shown = false }
  }

  fun render : Html {
    <div::base>
      <div::content as content onClick={handleClick}>
        <{ data.contents }>
      </div>
    </div>
  }
}

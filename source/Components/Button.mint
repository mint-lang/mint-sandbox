component Button {
  property onClick : Function(Promise(Never, Void)) = Promise.never
  property children : Array(Html) = []
  property type : String = "neutral"
  property disabled : Bool = false
  property href : String = ""

  style base {
    align-items: center;
    display: flex;

    border: 1px solid;
    border-radius: 2px;

    case (type) {
      "danger" =>
        border-color: #d72800;
        background: #880606;

      "primary" =>
        border-color: #009d3d;
        background: #04662b;

      =>
        border-color: #1e2128;
        background: #282c34;
    }

    text-transform: uppercase;
    text-decoration: none;
    font-family: inherit;
    font-weight: bold;
    font-size: 14px;
    color: #DDD;

    padding: 0 14px;
    height: 34px;

    cursor: pointer;

    &:hover {
      case (type) {
        "danger" =>
          border-color: #e83108;
          background: #a20505;

        =>
          background: #04662b;
          border-color: #009d3d;
      }
    }

    &:disabled {
      pointer-events: none;
      opacity: 0.5;
    }

    svg {
      fill: currentColor;
      margin-right: 7px;
      font-weight: 600;
    }
  }

  fun render : Html {
    if (href == "") {
      <button::base
        disabled={disabled}
        onClick={onClick}>

        <{ children }>

      </button>
    } else {
      <a::base
        onClick={onClick}
        href={href}>

        <{ children }>

      </a>
    }
  }
}

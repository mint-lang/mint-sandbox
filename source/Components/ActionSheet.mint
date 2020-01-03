record ActionSheet.Item {
  action : Function(Html.Event, Promise(Never, Void)),
  label : String,
  icon : Html
}

global component ActionSheet {
  state items : Array(ActionSheet.Item) = []
  state open : Bool = false

  fun hide : Promise(Never, Void) {
    next { open = false }
  }

  fun show (items : Array(ActionSheet.Item)) : Promise(Never, Void) {
    next
      {
        items = items,
        open = true
      }
  }

  style base {
    background: linear-gradient(rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.8));
    position: fixed;
    z-index: 1000;
    bottom: 0;
    right: 0;
    left: 0;
    top: 0;

    justify-content: flex-end;
    flex-direction: column;
    display: flex;

    if (open) {
      transition: visibility 1ms, opacity 320ms;
      visibility: visibilie;
      opacity: 1;
    } else {
      transition: visibility 320ms 1ms, opacity 320ms;
      visibility: hidden;
      opacity: 0;
    }
  }

  style item {
    align-items: center;
    font-weight: 600;
    padding: 0 15px;
    display: flex;
    height: 50px;

    + * {
      border-top: 1px solid #EEE;
    }
  }

  style label {
    line-height: 14px;
    font-weight: 500;
    height: 16px;
  }

  style icon {
    margin-right: 10px;
    height: 24px;
    width: 24px;

    align-items: center;
    display: flex;

    svg {
      height: 20px;
      width: 20px;
    }
  }

  style items {
    background: #FFF;
    border-radius: 3px;
    transition: 320ms;
    margin: 10px;

    if (open) {
      transform: translateY(0);
      opacity: 1;
    } else {
      transform: translateY(100%);
      opacity: 0;
    }
  }

  fun handleClick (
    action : Function(Html.Event, Promise(Never, Void))
  ) : Function(Html.Event, Promise(Never, Void)) {
    (event : Html.Event) : Promise(Never, Void) {
      sequence {
        action(event)
        hide()
      }
    }
  }

  fun handleClose (event : Html.Event) : Promise(Never, Void) {
    if (Dom.contains(
        event.target,
        Maybe.withDefault(Dom.createElement("div"), container))) {
      next {  }
    } else {
      hide()
    }
  }

  fun render : Html {
    <div::base onClick={handleClose}>
      <div::items as container>
        for (item of items) {
          <div::item onClick={handleClick(item.action)}>
            <div::icon>
              <{ item.icon }>
            </div>

            <div::label>
              <{ item.label }>
            </div>
          </div>
        }
      </div>
    </div>
  }
}

record Notification {
  contents : Html,
  duration : Number
}

global component Notifications {
  state notifications : Map(String, Notification) = Map.empty()

  style base {
    position: fixed;
    z-index: 2000;
    right: 20px;
    top: 20px;

    flex-direction: column;
    align-items: flex-end;
    display: flex;

    @media (max-width: 900px) {
      width: cacl(100vw - 20px);
      right: 10px;
      left: 10px;
      top: 10px;
    }
  }

  fun notifyDefault (message : String) : Promise(Never, Void) {
    notify(
      {
        contents =
          <>
            <{ message }>
          </>,
        duration = 7000
      })
  }

  fun notifyError : Promise(Never, Void) {
    notifyDefault("Something went wrong, please try again.")
  }

  fun notify (notification : Notification) : Promise(Never, Void) {
    try {
      sequence {
        id =
          Uid.generate()

        next { notifications = Map.set(id, notification, notifications) }
        Timer.timeout(notification.duration, "")
        next { notifications = Map.delete(id, notifications) }
      }

      Promise.never()
    }
  }

  fun render : Html {
    <div::base>
      for (id, notification of notifications) {
        <Notification
          data={notification}
          key={id}/>
      }
    </div>
  }
}

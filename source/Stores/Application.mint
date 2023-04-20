store Application {
  state userStatus : UserStatus = UserStatus::Initial
  state page : Page = Page::Initial

  fun setPage (page : Page) : Promise(Void) {
    next { page: page }
  }

  get isLoggedIn : Bool {
    case (userStatus) {
     UserStatus::LoggedIn => true
      => false
    }
  }

  fun send (
    raw : Http.Request,
    decoder : Function(Object, Result(Object.Error, a))
  ) : Promise(Result(Void, a)) {
    case (await Http.send(raw)) {
      Result::Err => Result::Err(void)

      Result::Ok(response) =>
        case (Json.parse(response.body)) {
          Result::Err =>
            Result::Err(void)

          Result::Ok(object) =>
            case (decoder(object)) {
              Result::Ok(value) => Result::Ok(value)
              Result::Err => Result::Err(void)
            }
        }
    }
  }

  fun initialize : Promise(Void) {
    let request =
      await "#{@ENDPOINT}/sandbox/user"
      |> Http.get()
      |> Http.withCredentials(true)

    let userStatus =
      await case (await send(request, decode as User)) {
        Result::Ok(user) => UserStatus::LoggedIn(user)
        Result::Err => UserStatus::LoggedOut
      }

    next { userStatus: userStatus }
  }

  fun logout : Promise(Void) {
    let request =
      "#{@ENDPOINT}/sandbox/logout"
      |> Http.get()
      |> Http.withCredentials(true)
      |> Http.send()

    await case (await request) {
      Result::Err => Promise.never()

      Result::Ok =>
        {
          Window.navigate("/")
          Ui.Notifications.notifyDefault(<{ "Logged out." }>)
        }
    }

    next { userStatus: UserStatus::LoggedOut }
  }

  fun save (id : String, mintVersion : String, content : String, title : String) : Promise(Void) {
    let body =
      encode {
        mintVersion: mintVersion,
        content: content,
        title: title
      }

    let request =
      "#{@ENDPOINT}/sandbox/#{id}"
      |> Http.put()
      |> Http.header("Content-Type", "application/json")
      |> Http.jsonBody(body)
      |> Http.withCredentials(true)

    let page =
      await case (await send(request, decode as Project)) {
        Result::Ok(project) => Page::Project(project)
        Result::Err => Page::Error
      }

    next { page: page }
  }

  fun fork (id : String) : Promise(Void) {
    let request =
      "#{@ENDPOINT}/sandbox/#{id}/fork"
      |> Http.post()
      |> Http.header("Content-Type", "application/json")
      |> Http.withCredentials(true)

    case (await send(request, decode as Project)) {
      Result::Err =>
        next { page: Page::Error }

      Result::Ok(project) =>
        {
          Window.navigate("/#{project.id}")

          Ui.Notifications.notifyDefault(
            <{ "Forked the sandbox successfully!" }>)
        }
    }
  }

  fun remove (id : String) : Promise(Void) {
    let request =
      "#{@ENDPOINT}/sandbox/#{id}"
      |> Http.delete()
      |> Http.header("Content-Type", "application/json")
      |> Http.withCredentials(true)

    case (await send(request, decode as Project)) {
      Result::Err =>
        next { page: Page::Error }

      Result::Ok =>
        {
          Window.navigate("/my-sandboxes")
          Ui.Notifications.notifyDefault(<{ "Deleted successfully!" }>)
        }
    }
  }

  fun format (id : String) : Promise(Void) {
    let request =
      "#{@ENDPOINT}/sandbox/#{id}/format"
      |> Http.post()
      |> Http.withCredentials(true)

    let page =
      await case (await send(request, decode as Project)) {
        Result::Ok(project) => Page::Project(project)
        Result::Err => Page::Error
      }

    next { page: page }
  }

  fun new : Promise(Void) {
    let request =
      "#{@ENDPOINT}/sandbox"
      |> Http.post()
      |> Http.withCredentials(true)

    case (await send(request, decode as Project)) {
      Result::Err => next { page: Page::Error }

      Result::Ok(project) =>
        {
          Window.navigate("/sandboxes/#{project.id}")
          save(project.id, project.mintVersion, project.content, project.title)
        }
    }
  }

  fun mySandboxes : Promise(Void) {
    let request =
      "#{@ENDPOINT}/sandbox"
      |> Http.get()
      |> Http.withCredentials(true)

    case (await send(request, decode as Array(Project))) {
      Result::Ok(projects) => next { page: Page::Sandboxes(projects) }
      Result::Err => next { page: Page::Error }
    }
  }

  fun recent : Promise(Void) {
    let request =
      "#{@ENDPOINT}/sandbox/recent"
      |> Http.get()
      |> Http.withCredentials(true)

    case (await send(request, decode as Array(Project))) {
      Result::Ok(projects) => next { page: Page::Home(projects) }
      Result::Err => next { page: Page::Error }
    }
  }

  fun load (id : String) : Promise(Void) {
    let request =
      "#{@ENDPOINT}/sandbox/#{id}"
      |> Http.get()
      |> Http.withCredentials(true)

    let page =
      await case (await send(request, decode as Project)) {
        Result::Ok(project) => Page::Project(project)
        Result::Err => Page::Error
      }

    next { page: page }
  }
}

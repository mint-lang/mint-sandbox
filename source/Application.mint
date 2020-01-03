store Application {
  state userStatus : UserStatus = UserStatus::Initial
  state page : Page = Page::Initial

  fun setPage (page : Page) : Promise(Never, Void) {
    next { page = page }
  }

  get isLoggedIn : Bool {
    case (userStatus) {
      UserStatus::LoggedIn => true
      => false
    }
  }

  fun initialize : Promise(Never, Void) {
    sequence {
      response =
        "#{@ENDPOINT}/sandbox/user"
        |> Http.get()
        |> Http.withCredentials(true)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      decoded =
        decode object as User

      next { userStatus = UserStatus::LoggedIn(decoded) }
    } catch {
      next { userStatus = UserStatus::LoggedOut }
    }
  }

  fun logout : Promise(Never, Void) {
    sequence {
      "#{@ENDPOINT}/sandbox/logout"
      |> Http.get()
      |> Http.withCredentials(true)
      |> Http.send()

      next { userStatus = UserStatus::LoggedOut }

      Window.navigate("/")
      Notifications.notifyDefault("Logged out.")
    } catch {
      next { userStatus = UserStatus::LoggedOut }
    }
  }

  fun save (
    id : String,
    content : Maybe(String),
    title : Maybe(String)
  ) : Promise(Never, Void) {
    sequence {
      body =
        encode {
          content = content,
          title = title
        }

      response =
        "#{@ENDPOINT}/sandbox/#{id}"
        |> Http.put()
        |> Http.header("Content-Type", "application/json")
        |> Http.jsonBody(body)
        |> Http.withCredentials(true)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      decoded =
        decode object as Project

      next { page = Page::Project(decoded) }
    } catch {
      next { page = Page::Error }
    }
  }

  fun fork (id : String) : Promise(Never, Void) {
    sequence {
      response =
        "#{@ENDPOINT}/sandbox/#{id}/fork"
        |> Http.post()
        |> Http.header("Content-Type", "application/json")
        |> Http.withCredentials(true)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      decoded =
        decode object as Project

      Window.navigate("/#{decoded.id}")

      Notifications.notifyDefault(
        "Forked the sandbox successfully!")
    } catch {
      next { page = Page::Error }
    }
  }

  fun remove (id : String) : Promise(Never, Void) {
    sequence {
      response =
        "#{@ENDPOINT}/sandbox/#{id}"
        |> Http.delete()
        |> Http.header("Content-Type", "application/json")
        |> Http.withCredentials(true)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      decoded =
        decode object as Project

      Window.navigate("/my-sandboxes")
      Notifications.notifyDefault("Deleted successfully!")
    } catch {
      next { page = Page::Error }
    }
  }

  fun format (id : String) : Promise(Never, Void) {
    sequence {
      response =
        "#{@ENDPOINT}/sandbox/#{id}/format"
        |> Http.post()
        |> Http.withCredentials(true)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      decoded =
        decode object as Project

      next { page = Page::Project(decoded) }
    } catch {
      next { page = Page::Error }
    }
  }

  fun new : Promise(Never, Void) {
    sequence {
      response =
        "#{@ENDPOINT}/sandbox"
        |> Http.post()
        |> Http.withCredentials(true)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      decoded =
        decode object as Project

      Window.navigate("/sandboxes/#{decoded.id}")
      Notifications.notifyDefault("Created sandbox!")
    } catch {
      next { page = Page::Error }
    }
  }

  fun mySandboxes : Promise(Never, Void) {
    sequence {
      response =
        "#{@ENDPOINT}/sandbox"
        |> Http.get()
        |> Http.withCredentials(true)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      decoded =
        decode object as Array(Project)

      next { page = Page::Sandboxes(decoded) }
    } catch {
      next { page = Page::Error }
    }
  }

  fun recent : Promise(Never, Void) {
    sequence {
      response =
        "#{@ENDPOINT}/sandbox/recent"
        |> Http.get()
        |> Http.withCredentials(true)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      decoded =
        decode object as Array(Project)

      next { page = Page::Home(decoded) }
    } catch {
      next { page = Page::Error }
    }
  }

  fun load (id : String) : Promise(Never, Void) {
    sequence {
      response =
        "#{@ENDPOINT}/sandbox/#{id}"
        |> Http.get()
        |> Http.withCredentials(true)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      decoded =
        decode object as Project

      next { page = Page::Project(decoded) }
    } catch {
      next { page = Page::Error }
    }
  }
}

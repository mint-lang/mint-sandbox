component Main {
  fun render : Html {
    <Layout/>
  }
}

enum Page {
  Sandboxes(Array(Project))
  Project(Project)
  Initial
  Error
  Home
}

enum UserStatus {
  LoggedIn(User)
  LoggedOut
  Initial
}

record User {
  nickname : String,
  image : String,
  id : Number
}

record Project {
  createdAt : Time using "created_at",
  updatedAt : Time using "updated_at",
  userId : Number using "user_id",
  content : String,
  title : String,
  id : String
}

store Application {
  state userStatus : UserStatus = UserStatus::Initial
  state page : Page = Page::Initial

  fun setPage (page : Page) : Promise(Never, Void) {
    next { page = page }
  }

  fun initialize : Promise(Never, Void) {
    sequence {
      response =
        "http://localhost:3001/sandbox/user"
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
      "http://localhost:3001/sandbox/logout"
      |> Http.get()
      |> Http.withCredentials(true)
      |> Http.send()

      next { userStatus = UserStatus::LoggedOut }
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
        "http://localhost:3001/sandbox/#{id}"
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
        "http://localhost:3001/sandbox/#{id}/fork"
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

  fun format (id : String) : Promise(Never, Void) {
    sequence {
      response =
        "http://localhost:3001/sandbox/#{id}/format"
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
        "http://localhost:3001/sandbox"
        |> Http.post()
        |> Http.withCredentials(true)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      decoded =
        decode object as Project

      Window.navigate("/sandboxes/#{decoded.id}")
    } catch {
      next { page = Page::Error }
    }
  }

  fun mySandboxes : Promise(Never, Void) {
    sequence {
      response =
        "http://localhost:3001/sandbox"
        |> Http.get()
        |> Http.withCredentials(true)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      decoded =
        decode object as Array(Project)
        |> Debug.log()

      next { page = Page::Sandboxes(decoded) }
    } catch {
      next { page = Page::Error }
    }
  }

  fun load (id : String) : Promise(Never, Void) {
    sequence {
      response =
        "http://localhost:3001/sandbox/#{id}"
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

routes {
  / {
    sequence {
      Application.initialize()
      Application.setPage(Page::Home)
    }
  }

  /my-sandboxes {
    sequence {
      Application.initialize()
      Application.mySandboxes()
    }
  }

  /sandboxes/:id (id : String) {
    sequence {
      Application.initialize()
      Application.load(id)
    }
  }

  * {
    Window.navigate("/")
  }
}

component Main {
  fun render : Html {
    <Layout/>
  }
}

enum Page {
  Sandboxes(Array(Project))
  Home(Array(Project))
  Project(Project)
  Initial
  Error
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
  id : String,
  user : User
}

routes {
  / {
    sequence {
      Application.initialize()
      Application.recent()
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

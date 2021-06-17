component Main {
  connect Application exposing { page }

  const TOKENS =
    Array.concat(
      [
        Ui:DEFAULT_TOKENS,
        [
          Ui.Token::Simple(name = "primary-hover", value = "#d91ca9"),
          Ui.Token::Simple(name = "primary-color", value = "#e30fae")
        ]
      ])

  get content : Html {
    case (page) {
      Page::Sandboxes(sandboxes) =>
        if (Array.isEmpty(sandboxes)) {
          <Page fill={true}>
            <Ui.IllustratedMessage
              subtitle=<{ "You don't have any sandboxes yet!" }>
              title=<{ "My Sandboxes" }>
              actions=<{
                <Ui.Button
                  onClick={(event : Html.Event) { Application.new() }}
                  iconBefore={Ui.Icons:PLUS}
                  label="Create a Sandbox"/>

                <Ui.Button
                  href="/"
                  type="secondary"
                  iconBefore={Ui.Icons:TELESCOPE}
                  label="Discover Sandboxes"/>
              }>
              image=<{
                <Ui.Icon
                  icon={Ui.Icons:BOOK}
                  size={Ui.Size::Em(10)}/>
              }>/>
          </Page>
        } else {
          <Page>
            <h1>"My Sandboxes"</h1>

            <p>"These are the sandboxes you created."</p>

            <Sandboxes sandboxes={sandboxes}/>
          </Page>
        }

      Page::Project(project) => <Editor project={project}/>

      Page::Home(recent) =>
        <Page>
          <h1>"Recently updated"</h1>

          <p>"These sandboxes have been updated recently."</p>

          <Sandboxes sandboxes={recent}/>
        </Page>

      => <></>
    }
  }

  fun render : Html {
    <Ui.Theme.Root
      fontConfiguration={Ui:DEFAULT_FONT_CONFIGURATION}
      tokens={TOKENS}>

      <Ui.Layout.Website
        footer={<Footer/>}
        header={<Header/>}
        content={content}
        maxWidth="100vw"
        centered={
          case (page) {
            Page::Project => false
            => true
          }
        }/>

    </Ui.Theme.Root>
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

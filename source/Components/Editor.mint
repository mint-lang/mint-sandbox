component Editor {
  connect Application exposing {
    save,
    format,
    userStatus,
    logout,
    fork,
    page
  }

  property project : Project = {
    updatedAt = Time.now(),
    createdAt = Time.now(),
    title = "",
    id = "",
    userId = 0,
    content = ""
  }

  use Provider.Shortcuts {
    shortcuts =
      [
        {
          condition = () : Bool { true },
          bypassFocused = true,
          shortcut =
            [
              17,
              16,
              83
            ],
          action = handleFormat
        },
        {
          condition = () : Bool { true },
          bypassFocused = true,
          shortcut =
            [
              17,
              83
            ],
          action = handleSave
        }
      ]
  }

  state value : Maybe(String) = Maybe::Nothing
  state title : Maybe(String) = Maybe::Nothing

  style base {
    grid-template-columns: 1fr 1fr;
    display: grid;
  }

  style code-header {
    border-bottom: 1px solid #1e2128;
    background: #30353e;

    padding: 6px 10px;
    padding-left: 20px;

    display: flex;
  }

  style code {
    border-right: 4px solid #1e2128;
  }

  style preview {
    display: grid;
  }

  style iframe {
    background: white;
    height: 100%;
    width: 100%;
    border: 0;
  }

  style input {
    background: transparent;
    margin-right: auto;
    font-weight: 600;
    font-family: inherit;
    color: #EEE;
    font-size: 18px;
    border: 0;
  }

  fun setValue2 (value : String) : Promise(Never, Void) {
    next { value = Maybe::Just(value) }
  }

  fun setTitle (event : Html.Event) : Promise(Never, Void) {
    next { title = Maybe::Just(Dom.getValue(event.target)) }
  }

  fun handleSave : Promise(Never, Void) {
    sequence {
      save(project.id, value, title)
      next { value = Maybe::Nothing }
      `#{frame}._0.contentWindow.postMessage("*", "*")`
    }
  }

  fun handleFormat : Promise(Never, Void) {
    sequence {
      save(project.id, value, title)
      format(project.id)
      next { value = Maybe::Nothing }
      `#{frame}._0.contentWindow.postMessage("*", "*")`
    }
  }

  fun render : Html {
    <div::base>
      <div::code>
        <div::code-header>
          <input::input
            onChange={setTitle}
            onBlur={handleSave}
            value={Maybe.withDefault(project.title, title)}/>

          case (page) {
            Page::Project =>
              case (userStatus) {
                UserStatus::LoggedIn user =>
                  if (user.id == project.userId) {
                    <>
                      <Button onClick={handleFormat}>
                        <Icons.Note/>

                        <span>
                          "Format"
                        </span>
                      </Button>

                      <Spacer width={6}/>

                      <Button onClick={handleSave}>
                        <Icons.Play/>

                        <span>
                          "Compile"
                        </span>
                      </Button>
                    </>
                  } else {
                    <>
                      <Button onClick={() : Promise(Never, Void) { fork(project.id) }}>
                        <Icons.Fork/>

                        <span>
                          "Fork"
                        </span>
                      </Button>
                    </>
                  }

                UserStatus::LoggedOut =>
                  <>
                    <Button disabled={true}>
                      <Icons.Fork/>

                      <span>
                        "Fork"
                      </span>
                    </Button>
                  </>

                UserStatus::Initial => <></>
              }

            => <></>
          }
        </div>

        <CodeMirror
          value={Maybe.withDefault(project.content, value)}
          javascripts=[]
          styles=[]
          mode="mint"
          theme="one-dark"
          onChange={setValue2}/>
      </div>

      <div::preview>
        <iframe::iframe as frame src="http://localhost:3001/sandbox/#{project.id}/preview"/>
      </div>
    </div>
  }
}

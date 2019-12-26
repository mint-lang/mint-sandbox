component Editor {
  connect Application exposing {
    save,
    format,
    userStatus,
    remove,
    isLoggedIn,
    logout,
    fork,
    page
  }

  property project : Project = {
    updatedAt = Time.now(),
    createdAt = Time.now(),
    user =
      {
        nickname = "",
        image = "",
        id = 0
      },
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
  } when {
    isMine
  }

  state value : Maybe(String) = Maybe::Nothing
  state title : Maybe(String) = Maybe::Nothing

  style base {
    grid-template-columns: 1fr 1fr;
    display: grid;

    @media (max-width: 900px) {
      grid-template-columns: 1fr;

      .CodeMirror {
        width: 100vw;
      }
    }
  }

  style code-header {
    border-bottom: 1px solid #1e2128;
    background: #30353e;

    padding: 6px 10px;
    padding-left: 20px;

    grid-template-columns: 1fr min-content;
    align-items: center;
    grid-gap: 30px;
    display: grid;

    @media (max-width: 900px) {
      grid-template-columns: 1fr;
      grid-gap: 10px;
    }
  }

  style code {
    border-right: 4px solid #1e2128;

    @media (max-width: 900px) {
      border-right: 0;
    }
  }

  style preview {
    display: grid;
  }

  style iframe {
    background: white;
    height: 100%;
    width: 100%;
    border: 0;

    @media (max-width: 900px) {
      min-height: 100vh;
    }
  }

  style hint {
    font-size: 14px;
    margin-right: 10px;
    color: rgba(255,255,255,0.6);
    font-weight: 600;
    white-space: nowrap;
    align-items: center;
    display: flex;

    svg {
      fill: currentColor;
      margin-right: 6px;
    }
  }

  style code-buttons {
    align-items: center;
    margin-left: auto;
    display: flex;
  }

  style input {
    background: transparent;
    font-weight: 600;
    font-family: inherit;
    color: #EEE;
    font-size: 18px;
    flex: 1;
    border: 0;

    if (isMine) {
      border-bottom: 1px dashed rgba(255,255,255,0.3);
    }
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

  fun handleDelete : Promise(Never, Void) {
    sequence {
      Window.confirm("Are you sure?")
      remove(project.id)
      next {  }
    } catch {
      next {  }
    }
  }

  get isMine : Bool {
    case (userStatus) {
      UserStatus::LoggedIn user => user.id == project.userId
      UserStatus::LoggedOut => false
      UserStatus::Initial => false
    }
  }

  fun render : Html {
    <div::base>
      <div::code>
        <div::code-header>
          if (isMine) {
            <input::input
              onChange={setTitle}
              onBlur={handleSave}
              value={Maybe.withDefault(project.title, title)}/>
          } else {
            <div::input>
              <{ Maybe.withDefault(project.title, title) }>
            </div>
          }

          <div::code-buttons>
            if (isMine) {
              <>
                <Button
                  onClick={handleDelete}
                  type="danger">

                  <Icons.Trashcan/>

                  <span>
                    "Delete"
                  </span>

                </Button>

                <Spacer width={6}/>

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
                if (!isLoggedIn) {
                  <span::hint>
                    <Icons.Info/>
                    "Log in to fork this sandbox."
                  </span>
                }

                <Button
                  onClick={() : Promise(Never, Void) { fork(project.id) }}
                  disabled={!isLoggedIn}>

                  <Icons.Fork/>

                  <span>
                    "Fork"
                  </span>

                </Button>
              </>
            }
          </div>
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
        <iframe::iframe as frame src="#{@ENDPOINT}/sandbox/#{project.id}/preview"/>
      </div>
    </div>
  }
}

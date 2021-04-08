component Editor {
  connect Ui exposing { mobile, darkMode }

  connect Stores.Editor exposing {
    timestamp,
    value,
    title,
    setTitle,
    setValue,
    reset
  }

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

  property project : Project =
    {
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
    border-bottom: 1px solid var(--border);
    background: var(--content-color);
    font-family: var(--font-family);
    color: var(--content-text);

    padding: 10px;
    padding-left: 2em;

    grid-template-columns: 1fr minmax(min-content, auto);
    align-items: center;
    grid-gap: 30px;
    display: grid;

    @media (max-width: 900px) {
      grid-template-columns: 1fr min-content;
      grid-gap: 10px;
    }
  }

  style code {
    background: var(--content-faded-color);
    border-right: 4px solid var(--border);
    color: var(--content-faded-text);

    @media (max-width: 900px) {
      border-bottom: 4px solid var(--border);
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
      min-height: 50vh;
    }
  }

  style hint {
    font-size: 14px;
    margin-right: 10px;
    font-weight: 600;
    white-space: nowrap;
    align-items: center;
    display: flex;
    opacity: 0.75;

    svg {
      fill: currentColor;
      margin-right: 6px;
    }
  }

  style code-buttons {
    align-items: center;
    margin-left: auto;
    display: flex;

    font-size: 14px;
  }

  style input {
    background: transparent;
    font-weight: 600;
    font-family: inherit;
    font-size: 18px;
    flex: 1;
    border: 0;
    width: 100%;

    if (isMine) {
      border-bottom: 1px dashed rgba(255,255,255,0.3);
    }
  }

  style menu {
    justify-self: center;
    height: 24px;

    svg {
      fill: #EEE;
    }
  }

  fun handleSave : Promise(Never, Void) {
    sequence {
      save(
        project.id,
        Maybe.withDefault(project.content, value),
        Maybe.withDefault(project.title, title))

      reset()
    }
  }

  fun handleFormat : Promise(Never, Void) {
    sequence {
      save(
        project.id,
        Maybe.withDefault(project.content, value),
        Maybe.withDefault(project.title, title))

      format(project.id)
      reset()
    }
  }

  fun handleDelete : Promise(Never, Void) {
    sequence {
      content =
        <Ui.Modal.Content
          title=<{ "Are you sure?" }>
          content=<{ "Are you sure you want to delete this sandbox?" }>
          actions=<{
            <Ui.Button
              onClick={(event : Html.Event) { Ui.Modal.cancel() }}
              label="Cancel"
              type="surface"/>

            <Ui.Button
              type="danger"
              label="Yes"
              onClick={
                (event : Html.Event) {
                  sequence {
                    Ui.Modal.hide()
                    remove(project.id)
                  }
                }
              }/>
          }>/>

      Ui.Modal.show(content)
      next {  }
    } catch {
      next {  }
    }
  }

  fun handleMenu : Promise(Never, Void) {
    Ui.ActionSheet.show(actions)
  }

  get isMine : Bool {
    case (userStatus) {
      UserStatus::LoggedIn user => user.id == project.userId
      UserStatus::LoggedOut => false
      UserStatus::Initial => false
    }
  }

  get actions {
    if (isMine) {
      [
        Ui.NavItem::Item(
          action = (event : Html.Event) : Promise(Never, Void) { handleDelete() },
          label = "Delete",
          iconBefore = Ui.Icons:TRASHCAN,
          iconAfter = <{  }>),
        Ui.NavItem::Item(
          action = (event : Html.Event) : Promise(Never, Void) { handleFormat() },
          label = "Format",
          iconBefore = Ui.Icons:FILE_CODE,
          iconAfter = <{  }>),
        Ui.NavItem::Item(
          action = (event : Html.Event) : Promise(Never, Void) { handleSave() },
          label = "Compile",
          iconBefore = Ui.Icons:PLAY,
          iconAfter = <{  }>)
      ]
    } else if (isLoggedIn) {
      [
        Ui.NavItem::Item(
          action = (event : Html.Event) : Promise(Never, Void) { fork(project.id) },
          label = "Fork",
          iconAfter = <{  }>,
          iconBefore = Ui.Icons:GIT_BRANCH)
      ]
    } else {
      [
        Ui.NavItem::Item(
          action = (event : Html.Event) : Promise(Never, Void) { next {  } },
          label = "Log in to fork this sandbox.",
          iconBefore = Ui.Icons:GIT_BRANCH,
          iconAfter = <{  }>)
      ]
    }
  }

  fun render : Html {
    <div::base>
      <div::code>
        <div::code-header>
          if (isMine) {
            <Ui.Input
              onChange={setTitle}
              onBlur={handleSave}
              value={Maybe.withDefault(project.title, title)}/>
          } else {
            <div::input>
              <{ Maybe.withDefault(project.title, title) }>
            </div>
          }

          <div::code-buttons>
            if (mobile) {
              <div::menu onClick={handleMenu}>
                <Ui.Icon icon={Ui.Icons:THREE_BARS}/>
              </div>
            } else if (isMine) {
              <Ui.Container gap={Ui.Size::Px(6)}>
                for (item of actions) {
                  case (item) {
                    Ui.NavItem::Item action iconBefore label =>
                      <Ui.Button
                        onClick={action}
                        iconBefore={iconBefore}
                        label={label}
                        type={
                          if (label == "Delete") {
                            "danger"
                          } else {
                            "surface"
                          }
                        }/>

                    => <></>
                  }
                }
              </Ui.Container>
            } else {
              <Ui.Container gap={Ui.Size::Px(6)}>
                if (!isLoggedIn) {
                  <span::hint>
                    <Ui.Icon icon={Ui.Icons:INFO}/>
                    "Log in to fork this sandbox."
                  </span>
                }

                <Ui.Button
                  onClick={(event : Html.Event) { fork(project.id) }}
                  disabled={!isLoggedIn}
                  iconBefore={Ui.Icons:REPO_FORKED}
                  ellipsis={false}
                  label="Fork"/>
              </Ui.Container>
            }
          </div>
        </div>

        <CodeMirror
          value={Maybe.withDefault(project.content, value)}
          javascripts=[]
          styles=[]
          readOnly={!isLoggedIn}
          mode="mint"
          theme={
            if (darkMode) {
              "darcula"
            } else {
              "neo"
            }
          }
          onChange={setValue}/>
      </div>

      <div::preview>
        <iframe::iframe as frame src="#{@ENDPOINT}/sandbox/#{project.id}/preview?timestamp=#{timestamp}"/>
      </div>
    </div>
  }
}

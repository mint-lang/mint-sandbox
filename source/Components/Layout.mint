component Layout {
  state mobile : Bool = false

  use Provider.MediaQuery {
    query = "(max-width: 900px)",
    changes =
      (value : Bool) : Promise(Never, Void) {
        next { mobile = value }
      }
  }

  connect Application exposing {
    userStatus,
    logout,
    page
  }

  style base {
    height: 100vh;
  }

  style toolbar {
    background: #3c424d;
    border-bottom: 1px solid #1e2128;
    height: 50px;

    padding: 0 20px;
    align-items: center;
    display: flex;
  }

  style menu {
    text-transform: uppercase;
    font-weight: bold;
    font-size: 14px;
    color: #EEE;

    align-items: center;
    display: flex;

    svg {
      fill: currentColor;
      margin-left: 10px;
    }
  }

  style brand {
    align-items: center;
    margin-right: auto;
    display: flex;
  }

  style toolbar-separator {
    width: 3px;
    background: rgba(255,255,255,0.6);
    height: 26px;
    margin: 0 10px;
  }

  fun handleMenu : Promise(Never, Void) {
    try {
      items =
        case (userStatus) {
          UserStatus::LoggedIn user =>
            [
              {
                action = (event : Html.Event) : Promise(Never, Void) { Application.new() },
                label = "Create Sandbox",
                icon = <Icons.Plus/>
              },
              {
                action = (event : Html.Event) : Promise(Never, Void) { Window.navigate("/my-sandboxes") },
                label = "My Sandboxes",
                icon = <Icons.Book/>
              },
              {
                action = (event : Html.Event) : Promise(Never, Void) { logout() },
                label = "Logout",
                icon = <Icons.SignOut/>
              }
            ]

          =>
            [
              {
                action = (event : Html.Event) : Promise(Never, Void) { `window.location = #{@ENDPOINT} + "/auth/github"` },
                label = "Log in with Github",
                icon = <Icons.Github/>
              }
            ]
        }

      ActionSheet.show(items)
    }
  }

  fun render : Html {
    <div::base>
      <div::toolbar>
        <a::brand href="/">
          <Logo/>
        </a>

        if (mobile) {
          <div::menu onClick={handleMenu}>
            "Menu"
            <Icons.Grabber/>
          </div>
        } else {
          <>
            case (userStatus) {
              UserStatus::LoggedIn user =>
                <>
                  <Button
                    type="primary"
                    onClick={Application.new}>

                    <Icons.Plus/>

                    <span>
                      "Create Sandbox"
                    </span>

                  </Button>

                  <Spacer width={6}/>

                  <Button href="/my-sandboxes">
                    <Icons.Book/>

                    <span>
                      "My Sandboxes"
                    </span>
                  </Button>

                  <Spacer width={6}/>

                  <Button onClick={logout}>
                    <Icons.SignOut/>

                    <span>
                      "Logout"
                    </span>
                  </Button>

                  <div::toolbar-separator/>
                </>

              => <></>
            }

            <UserInfo/>
          </>
        }
      </div>

      case (page) {
        Page::Sandboxes sandboxes =>
          <Page
            title="My Sandboxes"
            description="These are the sandboxes you created.">

            <Sandboxes sandboxes={sandboxes}/>

          </Page>

        Page::Project project => <Editor project={project}/>

        Page::Home recent =>
          <Page
            title="Recently updated"
            description="These sandboxes have been updated recently.">

            <Sandboxes sandboxes={recent}/>

          </Page>

        => <></>
      }
    </div>
  }
}

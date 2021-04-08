component Layout {
  connect Ui exposing { darkMode, setDarkMode }
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

  style layout {
    grid-template-rows: auto 1fr;
    min-height: 100vh;
    display: grid;
  }

  style header {
    padding: 0 1.5em;
  }

  style page {
    padding: 0 1.5em;
  }

  fun render : Html {
    try {
      darkModeToggle =
        if (mobile) {
          Ui.NavItem::Item(
            action = (event : Html.Event) { setDarkMode(!darkMode) },
            label =
              if (darkMode) {
                "Light Mode"
              } else {
                "Dark Mode"
              },
            iconBefore =
              if (darkMode) {
                Ui.Icons:SUN
              } else {
                Ui.Icons:MOON
              },
            iconAfter = <></>)
        } else {
          Ui.NavItem::Html(<Ui.DarkModeToggle/>)
        }

      items =
        case (userStatus) {
          UserStatus::LoggedIn =>
            [
              Ui.NavItem::Item(
                action = (event : Html.Event) { Application.new() },
                iconBefore = Ui.Icons:PLUS,
                iconAfter = <{  }>,
                label = "Create Sandbox"),
              Ui.NavItem::Link(
                href = "/my-sandboxes",
                iconBefore = Ui.Icons:BOOK,
                iconAfter = <{  }>,
                target = "",
                label = "My Sandboxes"),
              Ui.NavItem::Item(
                action = (event : Html.Event) { Application.logout() },
                iconBefore = Ui.Icons:SIGN_OUT,
                iconAfter = <{  }>,
                label = "Logout"),
              Ui.NavItem::Divider,
              darkModeToggle
            ]

          UserStatus::LoggedOut =>
            [
              Ui.NavItem::Link(
                href = @ENDPOINT + "/auth/github",
                iconBefore = Ui.Icons:MARK_GITHUB,
                iconAfter = <{  }>,
                target = "_blank",
                label = "Login with Github"),
              Ui.NavItem::Divider,
              darkModeToggle
            ]

          => []
        }

      content =
        case (page) {
          Page::Sandboxes sandboxes =>
            <div::page>
              <Ui.Content>
                <h1>"My Sandboxes"</h1>

                <p>"These are the sandboxes you created."</p>

                <Sandboxes sandboxes={sandboxes}/>
              </Ui.Content>
            </div>

          Page::Project project => <Editor project={project}/>

          Page::Home recent =>
            <>
              /*
              <Ui.Hero
                              background={Ui.Backgrounds:COMPLEX_REPEATING_STRIPES_01}
                              title=<{
                                <Logo/>

                                <Ui.Spacer height={40}/>
                                "A playground for Mint"
                              }>
                              subtitle=<{ "Try out Mint in this interactive sandbox." }>
                              actions=<{
                                <Ui.Button
                                  label="Create a Sandbox"
                                  iconBefore={Ui.Icons:PLUS}/>
                              }>/>
              */
              <page::page>
                <Ui.Content>
                  <h1>"Recently updated"</h1>

                  <p>"These sandboxes have been updated recently."</p>

                  <Sandboxes sandboxes={recent}/>
                </Ui.Content>
              </page>
            </>

          => <></>
        }

      <div::layout>
        <div::header>
          <Ui.Header
            brand={
              <a::brand href="/">
                <Logo/>
              </a>
            }
            items={items}/>
        </div>

        <{ content }>
      </div>
    }
  }
}

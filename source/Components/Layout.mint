component Layout {
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

  fun render : Html {
    <div::base>
      <div::toolbar>
        <a::brand href="/">
          <Logo/>
        </a>

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

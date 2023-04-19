component Header {
  connect Ui exposing { mobile, darkMode, setDarkMode }
  connect Application exposing { userStatus }

  get darkModeToggleNavItem : Ui.NavItem {
    if (mobile) {
      Ui.NavItem::Item(
        action: (event : Html.Event) { setDarkMode(!darkMode) },
        iconAfter: <></>,
        label:
          if (darkMode) {
            "Light Mode"
          } else {
            "Dark Mode"
          },
        iconBefore:
          if (darkMode) {
            Ui.Icons:SUN
          } else {
            Ui.Icons:MOON
          })
    } else {
      Ui.NavItem::Html(<Ui.DarkModeToggle/>)
    }
  }

  fun render : Html {
    <Ui.Header
      brand={
        <Logo
          size={Ui.Size::Em(1.25)}
          href="/"/>
      }
      items={
        case (userStatus) {
          UserStatus::LoggedIn =>
            [
              NavItems:CREATE_SANDBOX,
              NavItems:MY_SANDBOXES,
              NavItems:LOGOUT,
              Ui.NavItem::Divider,
              darkModeToggleNavItem
            ]

          UserStatus::LoggedOut =>
            [
              NavItems:GITHUB_LOGIN,
              Ui.NavItem::Divider,
              darkModeToggleNavItem
            ]

          => []
        }
      }/>
  }
}

store NavItems {
  const HOME =
    Ui.NavItem::Link(
      iconBefore = Ui.Icons:HOME,
      iconAfter = <></>,
      label = "Home",
      target = "",
      href = "/")

  const CREATE_SANDBOX =
    Ui.NavItem::Item(
      action = (event : Html.Event) { Application.new() },
      iconBefore = Ui.Icons:PLUS,
      label = "Create Sandbox",
      iconAfter = <{  }>)

  const MY_SANDBOXES =
    Ui.NavItem::Link(
      iconBefore = Ui.Icons:BOOK,
      href = "/my-sandboxes",
      label = "My Sandboxes",
      iconAfter = <{  }>,
      target = "")

  const LOGOUT =
    Ui.NavItem::Item(
      action = (event : Html.Event) { Application.logout() },
      iconBefore = Ui.Icons:SIGN_OUT,
      iconAfter = <{  }>,
      label = "Logout")

  const GITHUB_LOGIN =
    Ui.NavItem::Link(
      href = @ENDPOINT + "/auth/github",
      iconBefore = Ui.Icons:MARK_GITHUB,
      label = "Login with Github",
      iconAfter = <{  }>,
      target = "")

  const GITTER =
    Ui.NavItem::Link(
      label = "Gitter",
      iconBefore = @svg(../../assets/svgs/gitter-icon.svg),
      iconAfter = <></>,
      href = "https://gitter.im/mint-lang/Lobby",
      target = "_blank")

  const DISCORD =
    Ui.NavItem::Link(
      iconBefore = @svg(../../assets/svgs/discord-icon.svg),
      iconAfter = <></>,
      href = "https://discord.gg/NXFUJs2",
      label = "Discord",
      target = "_blank")

  const TELEGRAM =
    Ui.NavItem::Link(
      iconBefore = @svg(../../assets/svgs/telegram-icon.svg),
      iconAfter = <></>,
      href = "https://web.telegram.org/#/im?p=@mintlang",
      label = "Telegram",
      target = "_blank")

  const TWITTER =
    Ui.NavItem::Link(
      iconBefore = @svg(../../assets/svgs/twitter-icon.svg),
      iconAfter = <></>,
      href = "https://twitter.com/mint_lang",
      label = "Twitter",
      target = "_blank")

  const SOURCE =
    Ui.NavItem::Link(
      iconBefore = Ui.Icons:REPO,
      iconAfter = <></>,
      href = "https://github.com/mint-lang/mint-sandbox",
      target = "_blank",
      label = "Source")
}

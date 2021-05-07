component Footer {
  style infos {
    max-width: 500px;
  }

  style copyright {
    opacity: 0.5;
  }

  fun render : Html {
    try {
      navitems =
        [
          {
            "Site",
            [
              NavItems:HOME,
            ]
          },
          {
            "Community",
            [
              NavItems:GITTER,
              NavItems:DISCORD,
              NavItems:TELEGRAM,
              NavItems:TWITTER
            ]
          },
          {
            "Source",
            [
              NavItems:SOURCE,
            ]
          }
        ]

      infos =
        <div::infos>
          <Logo size={Ui.Size::Em(2)}/>

          <p>
            "Mint Sandbox is a site to write and share Mint code."
          </p>

          <div::copyright>
            "Copyright © #{Time.year(Time.now())} Mint. A" \
            "ll rights reserved."
          </div>
        </div>

      <Ui.Footer
        categoryWhiteSpace="nowrap"
        navitems={navitems}
        infos={infos}/>
    }
  }
}

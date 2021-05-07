component Logo {
  property size : Ui.Size = Ui.Size::Inherit
  property href : String = ""

  style base {
    svg {
      color: var(--primary-color);
    }
  }

  fun render : Html {
    <div::base>
      <Ui.Brand
        icon={Ui.Icons:MINT}
        name="Mint Sandbox"
        size={size}
        href={href}/>
    </div>
  }
}

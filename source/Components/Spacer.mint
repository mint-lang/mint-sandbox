component Spacer {
  property height : Number = 0
  property width : Number = 0

  style base {
    height: #{height}px;
    width: #{width}px;
    flex: 0 0 auto;
  }

  fun render : Html {
    <div::base/>
  }
}

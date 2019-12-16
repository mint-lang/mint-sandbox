component Page {
  property children : Array(Html) = []
  property actions : Array(Html) = []
  property description : String = ""
  property title : String = ""

  style base {
    padding: 20px;
    color: #DDD;
  }

  style title {
    font-family: 'M PLUS Rounded 1c', sans-serif;
    font-weight: 700;
    font-size: 24px;
  }

  style subtitle {
    color: #939db0;
  }

  style header {
    margin-bottom: 20px;
    align-items: center;
    display: flex;
  }

  style header-title {

  }

  style actions {
    margin-left: auto;
  }

  fun render : Html {
    <div::base>
      <div::header>
        <div::header-title>
          <div::title>
            <{ title }>
          </div>

          <div::subtitle>
            <{ description }>
          </div>
        </div>

        <div::actions>
          <{ actions }>
        </div>
      </div>

      <{ children }>
    </div>
  }
}

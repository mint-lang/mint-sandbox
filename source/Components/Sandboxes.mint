component Sandboxes {
  property sandboxes : Array(Project) = []

  style iframe {
    border-radius: 2px 2px 0 0;
    pointer-events: none;
    background: white;
    border: 0;
  }

  style sandbox {
    border: 1px solid #1e2128;
    background: #30353e;
    border-radius: 2px;

    grid-template-rows: 200px min-content;
    display: grid;

    text-decoration: none;
    color: #DDD;
  }

  style info {
    border-top: 1px solid #1e2128;
    padding: 10px;
  }

  style info-title {
    border-bottom: 1px dashed rgba(255,255,255,0.3);
    padding-bottom: 10px;
    margin-bottom: 10px;
    font-weight: bold;
    font-size: 16px;
  }

  style info-user {
    color: rgba(255,255,255,0.8);
    font-size: 14px;

    text-transform: uppercase;
    font-weight: 600;

    align-items: center;
    display: flex;

    img {
      border-radius: 50%;
      background: white;
      margin-right: 10px;
      padding: 2px;
      height: 16px;
      width: 16px;
    }
  }

  style grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    grid-gap: 20px;
    display: grid;
  }

  fun render : Html {
    <div::grid>
      for (sandbox of sandboxes) {
        <a::sandbox
          href="/sandboxes/#{sandbox.id}"
          key={sandbox.id}>

          <Preview url="#{@ENDPOINT}/sandbox/#{sandbox.id}/preview"/>

          <div::info>
            <div::info-title>
              <{ sandbox.title }>
            </div>

            <div::info-user>
              <img src={sandbox.user.image}/>
              <{ sandbox.user.nickname }>
            </div>
          </div>

        </a>
      }
    </div>
  }
}

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
    font-size: 16px;
    font-weight: bold;
  }

  style info-date {
    color: rgba(255,255,255,0.6);
    font-size: 14px;
  }

  style grid {
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    grid-gap: 20px;
    display: grid;
  }

  fun render : Html {
    <div::grid>
      for (sandbox of sandboxes) {
        <a::sandbox href="/sandboxes/#{sandbox.id}">
          <Preview url="http://localhost:3001/sandbox/#{sandbox.id}/preview"/>

          <div::info>
            <div::info-title>
              <{ sandbox.title }>
            </div>

            <div::info-date>
              "Created at "
              <{ Time.relative(sandbox.createdAt, Time.now()) }>
            </div>
          </div>
        </a>
      }
    </div>
  }
}

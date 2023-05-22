component Sandboxes {
  property sandboxes : Array(Project) = []

  style base {
    grid-template-columns: repeat(auto-fill, minmax(20em, 1fr));
    grid-gap: 2em;
    display: grid;

    margin-top: 1.5em;
  }

  style hr {
    width: 100%;
    margin: 0;

    border: 0;
    border-top: 1px solid var(--content-border);
  }

  fun render : Html {
    <div::base>
      for sandbox of sandboxes {
        <Ui.Card
          href="/sandboxes/#{sandbox.id}"
          key={sandbox.id}>

          <Ui.Card.Image
            src="#{@ENDPOINT}/sandbox/#{sandbox.id}/screenshot"
            objectPosition="top left"
            height={Ui.Size::Em(10)}/>

          <hr::hr/>

          <Ui.Card.Container
            title=<{ sandbox.title }>
            content={
              <Ui.Container justify="start">
                <Ui.Image
                  height={Ui.Size::Em(1.5)}
                  width={Ui.Size::Em(1.5)}
                  src={sandbox.user.image}/>

                <{ sandbox.user.nickname }>
              </Ui.Container>
            }/>

        </Ui.Card>
      }
    </div>
  }
}

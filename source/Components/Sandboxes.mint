component Sandboxes {
  property sandboxes : Array(Project) = []

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

  fun render : Html {
    <Ui.Grid
      width={Ui.Size::Px(280)}
      gap={Ui.Size::Px(20)}>

      for (sandbox of sandboxes) {
        <Ui.Card
          href="/sandboxes/#{sandbox.id}"
          key={sandbox.id}>

          <Ui.Card.Image
            src="#{@ENDPOINT}/sandbox/#{sandbox.id}/screenshot"
            objectPosition="top left"
            height={Ui.Size::Px(155)}/>

          <Ui.Card.Container
            title=<{ sandbox.title }>
            content={
              <Ui.Container>
                <Ui.Image
                  src={sandbox.user.image}
                  borderRadius="50%"
                  height={Ui.Size::Px(16)}
                  width={Ui.Size::Px(16)}/>

                <{ sandbox.user.nickname }>
              </Ui.Container>
            }/>

        </Ui.Card>
      }

    </Ui.Grid>
  }
}

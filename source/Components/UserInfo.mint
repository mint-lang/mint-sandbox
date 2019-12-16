component UserInfo {
  connect Application exposing { userStatus }

  style image {
    width: 20px;
    height: 20px;
    border-radius: 50%;
  }

  style avatar {
    border: 4px solid rgba(0,0,0,0.3);
    background: white;
    background-clip: padding-box;
    padding: 2px;
    border-radius: 50%;
    width: 32px;
    height: 32px;
  }

  style name {
    text-transform: uppercase;
    font-weight: bold;
    margin-right: 10px;
    font-size: 14px;
    color: #DDD;
  }

  style base {
    align-items: center;
    display: flex;
  }

  fun login : Promise(Never, Void) {
    `window.location = "http://localhost:3001/auth/github"`
  }

  fun render : Html {
    case (userStatus) {
      UserStatus::LoggedIn user =>
        <div::base>
          <div::name>
            <{ user.nickname }>
          </div>

          <div::avatar>
            <img::image src={user.image}/>
          </div>
        </div>

      UserStatus::LoggedOut =>
        <Button onClick={login}>
          <Icons.Github/>

          <span>
            "Log in with Github"
          </span>
        </Button>

      UserStatus::Initial => <></>
    }
  }
}

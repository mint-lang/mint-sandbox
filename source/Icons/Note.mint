component Icons.Note {
  style base {
    position: relative;
    top: 1px;
  }

  fun render : Html {
    <svg::base
      class="octicon octicon-note"
      viewBox="0 0 14 16"
      aria-hidden="true"
      version="1.1"
      height="16"
      width="14">

      <path
        fill-rule="evenodd"
        d={
          "M3 10h4V9H3v1zm0-2h6V7H3v1zm0-2h8V5H3v1zm10 6H1V3h12v9zM" \
          "1 2c-.55 0-1 .45-1 1v9c0 .55.45 1 1 1h12c.55 0 1-.45 1-1" \
          "V3c0-.55-.45-1-1-1H1z"
        }/>

    </svg>
  }
}

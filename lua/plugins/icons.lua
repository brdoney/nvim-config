-- For some reason, my font maps the nf-linux-qt to an AWS logo, so this fixes it
local qt = {
  icon = "",
  color = "#40cd52",
  cterm_color = "77",
  name = "Qt",
}

return {
  {
    'nvim-tree/nvim-web-devicons',
    opts = {
      override = {
        qml = qt,
        qrc = qt,
        qss = qt
      }
    }
  }
}

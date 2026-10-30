local font_result, font_error = rex.exec({
  "/usr/bin/defaults", "write", "com.superlogical.rex",
  "Workspace.terminalFontName", "-string", "Fira Code",
})
assert(font_result, font_error)
assert(font_result.ok, font_result.stderr)

local size_result, size_error = rex.exec({
  "/usr/bin/defaults", "write", "com.superlogical.rex",
  "Workspace.terminalFontPointSize", "-float", "14",
})
assert(size_result, size_error)
assert(size_result.ok, size_result.stderr)

rex.action {
  name = "import_theme",
  title = "Import Rex Zenburn Theme",
  run = function()
    rex.client.queue("client.theme.import", {
      path = os.getenv("HOME") .. "/.config/rex/themes/zenburn",
    })
  end,
}

rex.bind("ctrl+alt+f", "client.window.fullscreen.toggle")
rex.bind("ctrl+[", "com.superlogical.terminal.write", {
  data = "\027",
})

rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- General.
rex.bind("ctrl+a>space", "client.palette.toggle")
rex.bind("ctrl+a>,", "client.settings")
rex.bind("ctrl+a>shift+,", "client.config.reload")
rex.bind("ctrl+a>b", "client.sidebar.toggle")
rex.bind("ctrl+a>.", "client.sidebar.activity.toggle")

-- Sessions.
rex.bind("ctrl+a>p", "session.switch")
rex.bind("ctrl+a>s", "session.new")
rex.bind("ctrl+a>shift+s", "session.rename")
rex.bind("ctrl+a>c", "session.close")

-- Tabs.
rex.bind("ctrl+a>t", "client.tab.new")
rex.bind("ctrl+a>shift+t", "client.tab.rename")
rex.bind("ctrl+a>shift+7", "client.tab.close") -- &
rex.bind("ctrl+a>n", "client.tab.next")
rex.bind("ctrl+a>shift+n", "client.tab.previous")
for index = 1, 9 do
  rex.bind("ctrl+a>" .. index, "client.tab.goto", { index = index })
end

-- Panes.
rex.bind("ctrl+a>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+a>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+a>x", "pane.close")
rex.bind("ctrl+a>z", "pane.zoom")
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+a>" .. key, "pane.focus", { direction = direction })
  rex.bind("ctrl+a>shift+" .. key, "pane.move", { direction = direction })
end

-- Resizing.
rex.mode("resize", { exclusive = true })
rex.bind("ctrl+a>r", "client.mode.enter", { name = "resize" })
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("resize/" .. key, "pane.resize", { direction = direction, amount = 5 })
  rex.bind("resize/shift+" .. key, "pane.resize", { direction = direction, amount = 15 })
end
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
rex.bind("resize/ctrl+[", "client.mode.exit")

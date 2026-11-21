-- To make `cltr+a` work (double send)
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- Splits
rex.bind("ctrl+a>t", "pane.split", { direction = "right" })
rex.bind("ctrl+a>shift+t", "pane.split", { direction = "down" })
rex.bind("ctrl+a>x", "pane.close")
rex.bind("ctrl+a>z", "pane.zoom")
rex.bind("ctrl+a>=", "pane.balance")
-- Floating
rex.bind("ctrl+a>ctrl+f", "pane.float")
rex.bind("ctrl+a>f", "pane.new_floating")

-- Move between panes
rex.bind("ctrl+a>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+a>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+a>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+a>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+a>shift+1", "pane.move_to_new_tab")

-- Tabs (windows)
rex.bind("ctrl+a>n", "client.tab.new")
rex.bind("ctrl+a>ctrl+h", "client.tab.previous")
rex.bind("ctrl+a>ctrl+l", "client.tab.next")
rex.bind("ctrl+a>,", "client.tab.rename")
-- rex.bind("ctrl+a>'", "client.tab.recent")

rex.bind("ctrl+a>v", "pane.copy_mode.enter")

-- :: Modes
-- Move mode
rex.mode("move", { exclusive = true })
rex.bind("ctrl+a>m", "client.mode.enter", { name = "move" })
rex.bind("move/escape", "client.mode.exit")
rex.bind("move/q", "client.mode.exit")
rex.bind("move/h", "pane.move", { direction = "left" })
rex.bind("move/j", "pane.move", { direction = "down" })
rex.bind("move/k", "pane.move", { direction = "up" })
rex.bind("move/l", "pane.move", { direction = "right" })
rex.bind("move/ctrl+h", "client.tab.move", { direction = "backward" })
rex.bind("move/ctrl+l", "client.tab.move", { direction = "forward" })
rex.bind("move/shift+1", "pane.move_to_new_tab")
rex.bind("move/f", "pane.float")

-- Resize mode
rex.mode("resize", { exclusive = true })
rex.bind("ctrl+a>r", "client.mode.enter", { name = "resize" })
rex.bind("resize/escape", "client.mode.exit")
rex.bind("resize/q", "client.mode.exit")
rex.bind("resize/h", "pane.resize", { direction = "left" })
rex.bind("resize/j", "pane.resize", { direction = "down" })
rex.bind("resize/k", "pane.resize", { direction = "up" })
rex.bind("resize/l", "pane.resize", { direction = "right" })
rex.bind("resize/shift+h", "pane.resize", { amount = 15, direction = "left" })
rex.bind("resize/shift+j", "pane.resize", { amount = 15, direction = "down" })
rex.bind("resize/shift+k", "pane.resize", { amount = 15, direction = "up" })
rex.bind("resize/shift+l", "pane.resize", { amount = 15, direction = "right" })
rex.bind("resize/=", "pane.balance")

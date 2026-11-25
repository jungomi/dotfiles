-- Take over the active mode
rex.action({
  name = "mode_takeover",
  title = "Take over Keymap Mode",
  description = "Exit active modes and enter the given mode. This is mainly useful to call in an active mode, otherwise they get nested indefinitely.",
  args = {
    name = "string",
    once = "boolean?",
  },
  run = function(ctx, args)
    -- Exit all existing modes before entering the new one, effectively taking over.
    rex.client.queue("client.mode.exit_all")
    rex.client.queue("client.mode.enter", args)
  end,
})

local overseer = require("overseer")

local gitlab_ci = {
  name = "GitLab CI",
  files = { ".gitlab-ci.yml", ".gitlab-ci.yaml" },
}

function gitlab_ci.find_config(path)
  return vim.fs.find(gitlab_ci.files, {
    upward = true,
    path = path or vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    type = "file",
  })[1]
end

function gitlab_ci.parse_config(path)
  if vim.fn.executable("yq") == 0 then
    vim.notify("Must install `yq` to parse GitLab CI YAML", vim.log.levels.WARN)
    return nil
  end

  -- Convert the YAML to JSON with yq, to read it from NeoVim.
  local json_str = ""
  local yq = vim.fn.jobstart({ "yq", ".", path }, {
    on_stdout = function(_, data, _)
      json_str = table.concat(data, "\n")
    end,
    -- Only call on_stdout when the process finishes.
    stdout_buffered = true,
  })
  if yq > 0 then
    yq = vim.fn.jobwait({ yq })[1]
  else
    yq = -1
  end
  if yq ~= 0 then
    error(string.format("Could not read YAML file: %s with `yq`", path))
  end
  if json_str == "" then
    return nil
  end
  return vim.json.decode(json_str)
end

function gitlab_ci.find_and_parse_nearest_config(path)
  local config = gitlab_ci.find_config(path)
  if config == nil then
    return nil
  end
  return gitlab_ci.parse_config(config)
end

---@type overseer.TemplateDefinition
local tmpl = {
  priority = 60,
  params = {
    cwd = { optional = true },
    name = { optional = true, type = "string" },
    tasks = { optional = false },
  },
  builder = function(params)
    return {
      name = params.name,
      cwd = params.cwd,
      strategy = {
        "orchestrator",
        tasks = params.tasks,
      },
    }
  end,
}

function gitlab_ci.task_from_script(name, script, root_dir)
  local cmds = {}
  for _, cmd in ipairs(script) do
    table.insert(cmds, { "shell", cmd = cmd })
  end
  return overseer.wrap_template(tmpl, {
    name = name,
  }, {
    -- For some reason name needs to be preset in both,
    -- this wrapping template makes no sense to me, but whatever.
    name = name,
    cwd = root_dir,
    tasks = cmds,
  })
end

---@type overseer.TemplateProvider
gitlab_ci.template_provider = {
  name = gitlab_ci.name,
  cache_key = function(opts)
    return gitlab_ci.find_config(opts.dir)
  end,
  generator = function(opts, cb)
    local config = gitlab_ci.find_and_parse_nearest_config(opts.dir)
    if config == nil then
      cb({})
      return
    end
    local root_dir = vim.fs.dirname(gitlab_ci.find_config(opts.dir))
    local tasks = {}
    local all_task_names = {}
    for key, value in pairs(config) do
      if value.script ~= nil then
        local name = string.format("%s: %s", gitlab_ci.name, key)
        local task = gitlab_ci.task_from_script(name, value.script, root_dir)
        table.insert(tasks, task)
        table.insert(all_task_names, name)
      end
    end

    table.sort(all_task_names)
    -- This is the "all" task, where all targets are run in sequence.
    -- It should be in parallel, but that doesn't seem to work correctly.
    local all_task = overseer.wrap_template(tmpl, {
      name = string.format("%s: ALL", gitlab_ci.name),
    }, {
      name = string.format("%s: ALL", gitlab_ci.name),
      cwd = root_dir,
      tasks = all_task_names,
    })
    table.insert(tasks, all_task)

    -- Setup task (not inlcuded in ALL tasks)
    if config.before_script ~= nil then
      local name = string.format("%s: SETUP (before_script)", gitlab_ci.name)
      local task = gitlab_ci.task_from_script(name, config.before_script, root_dir)
      table.insert(tasks, task)
    end

    cb(tasks)
  end,
}

return gitlab_ci

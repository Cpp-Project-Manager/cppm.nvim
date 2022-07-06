local config = require("cppm.config")
local util = require("cppm.util")
local scan = require('plenary.scandir')

local cppm = {}

function cppm.setup(opts)
    if (cppm._config_exists()) then
        return util.error("Attempted to setup more than once, this is an error.")
    end

    local cfg = config.apply_defaults(opts)

    -- Allow the rest of the module to access the config
    cppm.config = cfg
end

function cppm.enable()
    if (not cppm._config_exists()) then
      return util.error("You must call setup() before using CPPM")
    end

    cppm.config.enabled = true

    local opts = {
        hidden = true,
        depth = 2,
        search_pattern = cppm.config.cfg_files,
        respect_gitignore = true
    }

    local cwd_files = scan.scan_dir(".", opts)

    if (util.tbl_empty(cwd_files)) then
        return util.warn('No CPPM config files could be found.')
    end

    local chosen_path = table.remove(cwd_files, 1)

    if (not util.tbl_empty(cwd_files)) then
        return util.warn(string.format('Found multiple entries for CPPM config files, using %s', chosen_path))
    end

    local toml = config.parse_config(chosen_path)

    for index, value in ipairs(toml) do
       vim.notify(string.format("I %s, V %s", index, value))
    end

end

function cppm.disable()
    if (not cppm._config_exists()) then
      return util.error("You must call setup() before using CPPM")
    end

    cppm.config.enabled = false
end

-- Private API

function cppm._config_exists()
    return cppm.config ~= nil
end

return cppm

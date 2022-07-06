local M = {}

local defaults = {
    enabled = false,
    cfg_files = { 'Cppm.toml' }
}

M.defaults = defaults

function M.apply_defaults(opts)
    return vim.tbl_deep_extend("force", {}, defaults, opts or {})
end

local toml = require('toml')
local util = require('cppm.util')
local Path = require('plenary.path')

function M.parse_config(cfg_path)
    local path = Path.new(cfg_path)

    if (not path.is_file()) then
        return util.error("Config path was not a file")
    end

    local content = path.read()
    local parsed = toml.parse(content)

    -- TODO: maybe transform this into a table?
    return parsed
end

return M

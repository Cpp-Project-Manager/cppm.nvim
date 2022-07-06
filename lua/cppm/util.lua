local M = {}

function M.error(msg)
    vim.notify_once("[ERROR] CPPM - " .. msg)
end

function M.warn(msg)
    vim.notify_once("[WARN] CPPM - " .. msg)
end

function M.tbl_empty(tbl)
    if (type(tbl) ~= 'table') then
        -- Always "empty" if it's not a table
        return true
    end

    return next(tbl) == nil
end

return M

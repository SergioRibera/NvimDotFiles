local M = {}

function M.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function M.get_filename_fn()
    local bufnr_name_cache = {}
    return function(bufnr)
        bufnr = vim.F.if_nil(bufnr, 0)
        local c = bufnr_name_cache[bufnr]
        if c then
            return c
        end

        local n = vim.api.nvim_buf_get_name(bufnr)
        bufnr_name_cache[bufnr] = n
        return n
    end
end

function M.ensure_init(messages, id, name)
    if not messages[id] then
        messages[id] = { name = name, messages = {}, progress = {}, status = {} }
    end
end

function M.mk_handler(fn)
    return function(...)
        local config_or_client_id = select(4, ...)
        local is_new = type(config_or_client_id) ~= 'number'
        if is_new then
            fn(...)
        else
            local err = select(1, ...)
            local method = select(2, ...)
            local result = select(3, ...)
            local client_id = select(4, ...)
            local bufnr = select(5, ...)
            local config = select(6, ...)
            fn(err, result, { method = method, client_id = client_id, bufnr = bufnr }, config)
        end
    end
end

function M.gen_from_quickfix(entry)
    local get_filename = M.get_filename_fn()
    local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))

    return {
        value = entry,
        bufnr = entry.bufnr,
        filename = filename,
        lnum = entry.lnum,
        col = entry.col,
        text = entry.text,
        start = entry.start,
        finish = entry.finish,
    }
end

function M.gen_from_lsp_symbols(entry)
    local get_filename = M.get_filename_fn()
    local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))
    local symbol_msg = entry.text
    local symbol_type, symbol_name = symbol_msg:match "%[(.+)%]%s+(.*)"

    return {
        value = entry,
        filename = filename,
        lnum = entry.lnum,
        col = entry.col,
        symbol_name = symbol_name,
        text = symbol_name,
        symbol_type = symbol_type,
        start = entry.start,
        finish = entry.finish,
    }
end

return M

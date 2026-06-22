local catalog = require("facomplete.catalog")

local Source = {}
Source.__index = Source

local function find_query(ctx)
  local before_cursor = ctx.line:sub(1, ctx.cursor[2])
  local start_at = before_cursor:match("()fa:[%w_-]*$")
  if not start_at then
    return nil
  end

  local previous = start_at > 1 and before_cursor:sub(start_at - 1, start_at - 1) or ""
  if previous:match("[%w_:]") then
    return nil
  end

  return before_cursor:sub(start_at + 3), start_at - 1
end

function Source.new()
  return setmetatable({}, Source)
end

function Source:get_trigger_characters()
  return { ":" }
end

function Source:should_show_items(ctx)
  return find_query(ctx) ~= nil
end

function Source:get_completions(ctx, callback)
  local _, start_col = find_query(ctx)
  if not start_col then
    callback({ items = {}, is_incomplete_backward = false, is_incomplete_forward = false })
    return
  end

  local row = ctx.cursor[1] - 1
  local end_col = ctx.cursor[2]
  local items = {}
  for _, icon in ipairs(catalog) do
    items[#items + 1] = {
      label = icon.glyph .. "  " .. icon.name,
      kind = vim.lsp.protocol.CompletionItemKind.Text,
      detail = table.concat(icon.styles, ", "),
      filterText = icon.search,
      documentation = {
        kind = "markdown",
        value = table.concat({
          "`" .. icon.name .. "`",
          icon.aliases ~= "" and ("Aliases: " .. icon.aliases) or "",
          "Font Awesome Free 7.2.0",
        }, "\n\n"),
      },
      textEdit = {
        newText = icon.glyph,
        range = {
          start = { line = row, character = start_col },
          ["end"] = { line = row, character = end_col },
        },
      },
    }
  end

  callback({ items = items, is_incomplete_backward = false, is_incomplete_forward = false })
end

Source.find_query = find_query

return Source

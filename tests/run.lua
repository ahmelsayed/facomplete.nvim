vim.opt.rtp:prepend(vim.fn.getcwd())

local Source = require("facomplete.blink")
local source = Source.new()

local function context(line)
  return { line = line, cursor = { 1, #line } }
end

local query, start_col = Source.find_query(context("try fa:arrow"))
assert(query == "arrow" and start_col == 4, "fa query range was parsed incorrectly")
assert(Source.find_query(context("alpha:fa:arrow")) == nil, "fa inside a word must not activate")

local function complete(line)
  local result
  source:get_completions(context(line), function(response)
    result = response
  end)
  return result
end

assert(#complete("arrow").items == 0, "source must stay inactive without fa:")

local canonical = complete("fa:arrow-right")
assert(#canonical.items > 0, "canonical icon name returned no matches")
local item = canonical.items[1]
assert(item.textEdit.range.start.character == 0, "replacement must begin at fa:")
assert(item.textEdit.range["end"].character == #"fa:arrow-right", "replacement must end at cursor")
assert(item.textEdit.newText ~= "", "icon glyph was empty")

local alias = complete("fa:contact-book")
assert(#alias.items > 0, "alias returned no matches")

assert(source:should_show_items(context("fa:")), "provider should show after fa:")
assert(not source:should_show_items(context("plain text")), "provider should stay hidden outside fa:")

print("facomplete tests passed")

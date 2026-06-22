#!/usr/bin/env ruby
# Generates lua/facomplete/catalog.lua from Font Awesome's metadata/icons.json.
# Usage: ruby scripts/generate_catalog.rb /path/to/icons.json

require "json"

input = ARGV.fetch(0)
icons = JSON.parse(File.read(input))

def lua_quote(value)
  '"' + value.to_s.gsub('\\', '\\\\').gsub('"', '\\"').gsub("\n", "\\n") + '"'
end

records = icons.each_with_object([]) do |(name, icon), records|
  free_styles = icon.fetch("free", [])
  next if free_styles.empty?

  aliases = icon.dig("aliases", "names") || []
  terms = icon.dig("search", "terms") || []
  search = ([name] + aliases + terms).join(" ").downcase
  styles = free_styles.sort
  records << [name, icon.fetch("unicode"), aliases.sort.join(", "), styles, search]
end.sort_by(&:first)

out = <<~LUA
  -- Generated from FortAwesome/Font-Awesome 7.2.0 metadata/icons.json.
  -- Font Awesome Free icons: CC BY 4.0. See LICENSE-FONTAWESOME.
  return {
LUA

records.each do |name, unicode, aliases, styles, search|
  glyph = [unicode.to_i(16)].pack("U")
  out << "  { name = #{lua_quote(name)}, glyph = #{lua_quote(glyph)}, aliases = #{lua_quote(aliases)}, styles = { #{styles.map { |s| lua_quote(s) }.join(', ')} }, search = #{lua_quote(search)} },\n"
end

out << "}\n"
File.write("lua/facomplete/catalog.lua", out)
puts "Wrote #{records.length} Font Awesome Free icons."

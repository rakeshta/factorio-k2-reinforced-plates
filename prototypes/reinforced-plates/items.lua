--
--  items.lua
--  factorio-k2-reinforced-plates
--
--  Created by Rakesh Ayyaswami on 03 Jan 2023.
--

local tiles_graphics_path = k2_reinforced_plates .. "graphics/reinforced-plates/"

-- Create an item for each tile variant
for variant, name in pairs(k2_tile_variants) do
  data:extend({
    {
      type = "item",
      name = name,
      icon = tiles_graphics_path .. "reinforced-plate-" .. variant .. "-icon.png",
      icon_size = 64,
      icon_mipmaps = 4,
      subgroup = "terrain",
      order = "z[reinforced-plate-" .. variant .. "]-a1[reinforced-plate-" .. variant .. "]",
      place_as_tile = {
        result = name,
        condition_size = 1,
        condition = { "water-tile" },
      },
      stack_size = 200,
    },
  })
end

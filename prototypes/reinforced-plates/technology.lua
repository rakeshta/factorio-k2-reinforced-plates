--
--  technology.lua
--  factorio-k2-reinforced-plates
--
--  Created by Rakesh Ayyaswami on 03 Jan 2023.
--

local tiles_graphics_path = k2_reinforced_plates .. "graphics/reinforced-plates/"

-- create recipe unlock effect for each tile variant
local recipe_unlock_effects = {}
for _, name in pairs(k2_tile_variants) do
  table.insert(recipe_unlock_effects, { type = "unlock-recipe", recipe = name })
end

-- create technology to unlock all tile variants
data:extend({
  {
    type = "technology",
    name = "kr-reinforced-plates",
    mod = "k2-reinforced-plates",
    icon = tiles_graphics_path .. "reinforced-plates-technology-icon.png",
    icon_size = 256,
    icon_mipmaps = 4,
    effects = recipe_unlock_effects,
    prerequisites = { "concrete", "steel-processing" },
    unit = {
      count = 200,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 30,
    },
  },
})

--
--  recipes.lua
--  factorio-k2-reinforced-plates
--
--  Created by Rakesh Ayyaswami on 03 Jan 2023.
--

-- Create a recipe for each tile variant
for _, name in pairs(k2_tile_variants) do
  data:extend({
    {
      type = "recipe",
      name = name,
      energy_required = 5,
      enabled = false,
      ingredients = {
        { type = "item", name = "refined-concrete", amount = 20 },
        { type = "item", name = "steel-plate",      amount = 5 },
      },
      results = { { type = "item", name = name, amount = 10 } }
    },
  })
end

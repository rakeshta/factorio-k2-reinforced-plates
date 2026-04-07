--
--  tiles.lua
--  factorio-k2-reinforced-plates
--
--  Created by Rakesh Ayyaswami on 03 Jan 2023.
--

local tiles_graphics_path = k2_reinforced_plates .. "graphics/reinforced-plates/"
local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_sounds = require("__base__/prototypes/tile/tile-sounds")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

local water_tile_type_names = { "water", "deepwater", "water-green", "deepwater-green", "water-shallow", "water-mud" }
local default_transition_group_id = 0
local water_transition_group_id = 1
local out_of_map_transition_group_id = 2

local concrete_transitions = {
  {
    to_tiles = water_tile_type_names,
    transition_group = water_transition_group_id,
    spritesheet = "__base__/graphics/terrain/water-transitions/concrete.png",
    layout = tile_spritesheet_layout.transition_8_8_8_4_4,
    background_enabled = false,
    effect_map_layout = {
      spritesheet = "__base__/graphics/terrain/effect-maps/water-stone-mask.png",
      inner_corner_count = 1,
      outer_corner_count = 1,
      side_count = 1,
      u_transition_count = 1,
      o_transition_count = 1,
    },
  },
  -- This doesn't exist?
  -- concrete_out_of_map_transition,
}

local concrete_transitions_between_transitions = {
  {
    transition_group1 = default_transition_group_id,
    transition_group2 = water_transition_group_id,
    spritesheet = "__base__/graphics/terrain/water-transitions/concrete-transitions.png",
    layout = tile_spritesheet_layout.transition_3_3_3_1_0,
    background_enabled = false,
    effect_map_layout = {
      spritesheet = "__base__/graphics/terrain/effect-maps/water-stone-to-land-mask.png",
      o_transition_count = 0,
    },
  },
  {
    transition_group1 = default_transition_group_id,
    transition_group2 = out_of_map_transition_group_id,
    background_layer_offset = 1,
    background_layer_group = "zero",
    offset_background_layer_by_tile_layer = true,
    spritesheet = "__base__/graphics/terrain/out-of-map-transition/concrete-out-of-map-transition-b.png",
    layout = tile_spritesheet_layout.transition_3_3_3_1_0,
  },
  {
    transition_group1 = water_transition_group_id,
    transition_group2 = out_of_map_transition_group_id,
    background_layer_offset = 1,
    background_layer_group = "zero",
    offset_background_layer_by_tile_layer = true,
    spritesheet = "__base__/graphics/terrain/out-of-map-transition/concrete-shore-out-of-map-transition.png",
    layout = tile_spritesheet_layout.transition_3_3_3_1_0,
    effect_map_layout = {
      spritesheet = "__base__/graphics/terrain/effect-maps/water-stone-to-out-of-map-mask.png",
      u_transition_count = 0,
      o_transition_count = 0,
    },
  },
}

--- Function to create a tile with the given variant details
local function create_tile(variant, layer, map_color)
  -- form tile name and add it to the table of tile variants
  local name = "kr-" .. variant .. "-reinforced-plate"
  k2_tile_variants[variant] = name

  -- create the tile
  data:extend({
    {
      type = "tile",
      name = name,
      needs_correction = false,
      minable = { mining_time = 0.1, result = name },
      mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
      collision_mask = {
        layers = {
          ground_tile = true
        }
      },
      walking_speed_modifier = 1.75,
      layer = layer,
      transition_overlay_layer_offset = 2, -- need to render border overlay on top of hazard-concrete
      decorative_removal_probability = 0.95,
      variants = {
        main = {
          {
            picture = "__core__/graphics/empty.png",
            count = 1,
            size = 1,
          },
          {
            picture = "__core__/graphics/empty.png",
            count = 1,
            size = 2,
            probability = 0.39,
          },
          {
            picture = "__core__/graphics/empty.png",
            count = 1,
            size = 4,
            probability = 1,
          },
        },
        transition = {
          overlay_layout = {
            inner_corner = {
              spritesheet = "__base__/graphics/terrain/concrete/concrete-inner-corner.png",
              count = 16,
              scale = 0.5,
            },
            outer_corner = {
              spritesheet = "__base__/graphics/terrain/concrete/concrete-outer-corner.png",
              count = 8,
              scale = 0.5,
            },
            side = {
              spritesheet = "__base__/graphics/terrain/concrete/concrete-side.png",
              count = 16,
              scale = 0.5,
            },
            u_transition = {
              spritesheet = "__base__/graphics/terrain/concrete/concrete-u.png",
              count = 8,
              scale = 0.5,
            },
            o_transition = {
              spritesheet = "__base__/graphics/terrain/concrete/concrete-o.png",
              count = 4,
              scale = 0.5,
            },
          },
          mask_layout = {
            inner_corner = {
              spritesheet = "__base__/graphics/terrain/concrete/concrete-inner-corner-mask.png",
              count = 16,
              scale = 0.5,
            },
            outer_corner = {
              spritesheet = "__base__/graphics/terrain/concrete/concrete-outer-corner-mask.png",
              count = 8,
              scale = 0.5,
            },
            side = {
              spritesheet = "__base__/graphics/terrain/concrete/concrete-side-mask.png",
              count = 16,
              scale = 0.5,
            },
            u_transition = {
              spritesheet = "__base__/graphics/terrain/concrete/concrete-u-mask.png",
              count = 8,
              scale = 0.5,
            },
            o_transition = {
              spritesheet = "__base__/graphics/terrain/concrete/concrete-o-mask.png",
              count = 4,
              scale = 0.5,
            },
          },
        },

        material_background = {
          picture = tiles_graphics_path .. "reinforced-plate-" .. variant .. ".png",
          count = 16,
          hr_version = {
            picture = tiles_graphics_path .. "hr-reinforced-plate-" .. variant .. ".png",
            count = 16,
            scale = 0.5,
          },
        },
      },

      transitions = concrete_transitions,
      transitions_between_transitions = concrete_transitions_between_transitions,

      walking_sound = tile_sounds.walking.refined_concrete,

      map_color = map_color,
      absorptions_per_second = {},
      vehicle_friction_modifier = 0.75,
    },
  })
end

-- Black & white tiles from Krastorio 2
create_tile("black", 95, { r = 40, g = 40, b = 40 })
create_tile("white", 90, { r = 110, g = 110, b = 110 })

-- Additional tiles
-- create_tile("red", 93, { r = 128, g = 34, b = 34 })

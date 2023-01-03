--
--  tiles.lua
--  factorio-k2-reinforced-plates
--
--  Created by Rakesh Ayyaswami on 03 Jan 2023.
--

local tiles_graphics_path = k2_reinforced_plates .. "graphics/reinforced-plates/"

local water_tile_type_names = { "water", "deepwater", "water-green", "deepwater-green", "water-shallow", "water-mud" }
local patch_for_inner_corner_of_transition_between_transition = {
  filename = "__base__/graphics/terrain/water-transitions/water-patch.png",
  width = 32,
  height = 32,
  hr_version = {
    filename = "__base__/graphics/terrain/water-transitions/hr-water-patch.png",
    scale = 0.5,
    width = 64,
    height = 64,
  },
}

local default_transition_group_id = 0
local water_transition_group_id = 1
local out_of_map_transition_group_id = 2

local function water_transition_template_with_effect(to_tiles, normal_res_transition, high_res_transition, options)
  return make_generic_transition_template(
    to_tiles,
    water_transition_group_id,
    nil,
    normal_res_transition,
    high_res_transition,
    options,
    true,
    false,
    true
  )
end

local function water_transition_template(to_tiles, normal_res_transition, high_res_transition, options)
  return make_generic_transition_template(
    to_tiles,
    water_transition_group_id,
    nil,
    normal_res_transition,
    high_res_transition,
    options,
    true,
    true,
    true
  )
end

local function make_water_transition_template(
  to_tiles,
  normal_res_transition,
  high_res_transition,
  options,
  base_layer,
  background,
  mask
)
  return make_generic_transition_template(
    to_tiles,
    water_transition_group_id,
    nil,
    normal_res_transition,
    high_res_transition,
    options,
    base_layer,
    background,
    mask
  )
end

local function out_of_map_transition_template(to_tiles, normal_res_transition, high_res_transition, options)
  return make_generic_transition_template(
    to_tiles,
    out_of_map_transition_group_id,
    nil,
    normal_res_transition,
    high_res_transition,
    options,
    true,
    true,
    true
  )
end

local function make_out_of_map_transition_template(
  to_tiles,
  normal_res_transition,
  high_res_transition,
  options,
  base_layer,
  background,
  mask
)
  return make_generic_transition_template(
    to_tiles,
    out_of_map_transition_group_id,
    nil,
    normal_res_transition,
    high_res_transition,
    options,
    base_layer,
    background,
    mask
  )
end

local function generic_transition_between_transitions_template(
  group1,
  group2,
  normal_res_transition,
  high_res_transition,
  options
)
  return make_generic_transition_template(
    nil,
    group1,
    group2,
    normal_res_transition,
    high_res_transition,
    options,
    true,
    true,
    true
  )
end

local function init_transition_between_transition_common_options(base)
  local t = base or {}

  t.background_layer_offset = t.background_layer_offset or 1
  t.background_layer_group = t.background_layer_group or "zero"
  if t.offset_background_layer_by_tile_layer == nil then
    t.offset_background_layer_by_tile_layer = true
  end

  return t
end

local function init_transition_between_transition_water_out_of_map_options(base)
  return init_transition_between_transition_common_options(base)

  --[[
  local t = base or {}

  t.background_layer_offset = t.background_layer_offset or 1
  t.background_layer_group = t.background_layer_group or "water-overlay"
  t.water_patch = patch_for_inner_corner_of_transition_between_transition
  --if (t.offset_background_layer_by_tile_layer == nil) then
  --  t.offset_background_layer_by_tile_layer = true
  --end

  return t
  --]]
end

local base_tile_transition_effect_maps = {}
local ttfxmaps = base_tile_transition_effect_maps

ttfxmaps.water_stone = {
  filename_norm = "__base__/graphics/terrain/effect-maps/water-stone-mask.png",
  filename_high = "__base__/graphics/terrain/effect-maps/hr-water-stone-mask.png",
  count = 1,
  o_transition_tall = false,
}

ttfxmaps.water_stone_to_land = {
  filename_norm = "__base__/graphics/terrain/effect-maps/water-stone-to-land-mask.png",
  filename_high = "__base__/graphics/terrain/effect-maps/hr-water-stone-to-land-mask.png",
  count = 3,
  u_transition_count = 1,
  o_transition_count = 0,
}

ttfxmaps.water_stone_to_out_of_map = {
  filename_norm = "__base__/graphics/terrain/effect-maps/water-stone-to-out-of-map-mask.png",
  filename_high = "__base__/graphics/terrain/effect-maps/hr-water-stone-to-out-of-map-mask.png",
  count = 3,
  u_transition_count = 0,
  o_transition_count = 0,
}

ttfxmaps.water_stone_to_out_of_map = {
  filename_norm = "__base__/graphics/terrain/effect-maps/water-stone-to-out-of-map-mask.png",
  filename_high = "__base__/graphics/terrain/effect-maps/hr-water-stone-to-out-of-map-mask.png",
  count = 3,
  u_transition_count = 0,
  o_transition_count = 0,
}

local concrete_transitions = {
  water_transition_template_with_effect(
    water_tile_type_names,
    "__base__/graphics/terrain/water-transitions/concrete.png",
    "__base__/graphics/terrain/water-transitions/hr-concrete.png",
    {
      effect_map = ttfxmaps.water_stone,
      o_transition_tall = false,
      u_transition_count = 4,
      o_transition_count = 4,
      side_count = 8,
      outer_corner_count = 8,
      inner_corner_count = 8,
      --base = { layer = 40 }
    }
  ),
  -- This doesn't exist?
  -- concrete_out_of_map_transition,
}

local concrete_transitions_between_transitions = {
  make_generic_transition_template(-- generic_transition_between_transitions_template
    nil,
    default_transition_group_id,
    water_transition_group_id,
    "__base__/graphics/terrain/water-transitions/concrete-transitions.png",
    "__base__/graphics/terrain/water-transitions/hr-concrete-transitions.png",
    {
      effect_map = ttfxmaps.water_stone_to_land,
      inner_corner_tall = true,
      inner_corner_count = 3,
      outer_corner_count = 3,
      side_count = 3,
      u_transition_count = 1,
      o_transition_count = 0,
    },
    true,
    false,
    true
  ),
  make_generic_transition_template(
    nil,
    default_transition_group_id,
    out_of_map_transition_group_id,
    "__base__/graphics/terrain/out-of-map-transition/concrete-out-of-map-transition-b.png",
    "__base__/graphics/terrain/out-of-map-transition/hr-concrete-out-of-map-transition-b.png",
    {
      inner_corner_tall = true,
      inner_corner_count = 3,
      outer_corner_count = 3,
      side_count = 3,
      u_transition_count = 1,
      o_transition_count = 0,
      base = init_transition_between_transition_common_options(),
    },
    true,
    true,
    true
  ),
  generic_transition_between_transitions_template(
    water_transition_group_id,
    out_of_map_transition_group_id,
    "__base__/graphics/terrain/out-of-map-transition/concrete-shore-out-of-map-transition.png",
    "__base__/graphics/terrain/out-of-map-transition/hr-concrete-shore-out-of-map-transition.png",
    {
      effect_map = ttfxmaps.water_stone_to_out_of_map,
      o_transition_tall = false,
      inner_corner_count = 3,
      outer_corner_count = 3,
      side_count = 3,
      u_transition_count = 1,
      o_transition_count = 0,
      base = init_transition_between_transition_water_out_of_map_options(),
    }
  ),
}

local refined_concrete_sounds = {
  {
    filename = "__base__/sound/walking/refined-concrete-01.ogg",
    volume = 0.75,
  },
  {
    filename = "__base__/sound/walking/refined-concrete-02.ogg",
    volume = 0.75,
  },
  {
    filename = "__base__/sound/walking/refined-concrete-03.ogg",
    volume = 0.75,
  },
  {
    filename = "__base__/sound/walking/refined-concrete-04.ogg",
    volume = 0.75,
  },
  {
    filename = "__base__/sound/walking/refined-concrete-05.ogg",
    volume = 0.75,
  },
  {
    filename = "__base__/sound/walking/refined-concrete-06.ogg",
    volume = 0.75,
  },
  {
    filename = "__base__/sound/walking/refined-concrete-07.ogg",
    volume = 0.75,
  },
  {
    filename = "__base__/sound/walking/refined-concrete-08.ogg",
    volume = 0.75,
  },
  {
    filename = "__base__/sound/walking/refined-concrete-09.ogg",
    volume = 0.75,
  },
  {
    filename = "__base__/sound/walking/refined-concrete-10.ogg",
    volume = 0.75,
  },
  {
    filename = "__base__/sound/walking/refined-concrete-11.ogg",
    volume = 0.75,
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
      collision_mask = { "ground-tile" },
      walking_speed_modifier = 1.75,
      layer = layer,
      transition_overlay_layer_offset = 2, -- need to render border overlay on top of hazard-concrete
      decorative_removal_probability = 0.95,
      variants = {
        main = {
          {
            picture = "__base__/graphics/terrain/concrete/concrete-dummy.png",
            count = 1,
            size = 1,
          },
          {
            picture = "__base__/graphics/terrain/concrete/concrete-dummy.png",
            count = 1,
            size = 2,
            probability = 0.39,
          },
          {
            picture = "__base__/graphics/terrain/concrete/concrete-dummy.png",
            count = 1,
            size = 4,
            probability = 1,
          },
        },
        inner_corner = {
          picture = tiles_graphics_path .. "concrete-inner-corner.png",
          count = 16,
          hr_version = {
            picture = tiles_graphics_path .. "hr-concrete-inner-corner.png",
            count = 16,
            scale = 0.5,
          },
        },
        inner_corner_mask = {
          picture = "__base__/graphics/terrain/concrete/concrete-inner-corner-mask.png",
          count = 16,
          hr_version = {
            picture = "__base__/graphics/terrain/concrete/hr-concrete-inner-corner-mask.png",
            count = 16,
            scale = 0.5,
          },
        },

        outer_corner = {
          picture = tiles_graphics_path .. "concrete-outer-corner.png",
          count = 8,
          hr_version = {
            picture = tiles_graphics_path .. "hr-concrete-outer-corner.png",
            count = 8,
            scale = 0.5,
          },
        },
        outer_corner_mask = {
          picture = "__base__/graphics/terrain/concrete/concrete-outer-corner-mask.png",
          count = 8,
          hr_version = {
            picture = "__base__/graphics/terrain/concrete/hr-concrete-outer-corner-mask.png",
            count = 8,
            scale = 0.5,
          },
        },

        side = {
          picture = tiles_graphics_path .. "concrete-side.png",
          count = 16,
          hr_version = {
            picture = tiles_graphics_path .. "hr-concrete-side.png",
            count = 16,
            scale = 0.5,
          },
        },
        side_mask = {
          picture = "__base__/graphics/terrain/concrete/concrete-side-mask.png",
          count = 16,
          hr_version = {
            picture = "__base__/graphics/terrain/concrete/hr-concrete-side-mask.png",
            count = 16,
            scale = 0.5,
          },
        },

        u_transition = {
          picture = tiles_graphics_path .. "concrete-u.png",
          count = 8,
          hr_version = {
            picture = tiles_graphics_path .. "hr-concrete-u.png",
            count = 8,
            scale = 0.5,
          },
        },
        u_transition_mask = {
          picture = "__base__/graphics/terrain/concrete/concrete-u-mask.png",
          count = 8,
          hr_version = {
            picture = "__base__/graphics/terrain/concrete/hr-concrete-u-mask.png",
            count = 8,
            scale = 0.5,
          },
        },

        o_transition = {
          picture = tiles_graphics_path .. "concrete-o.png",
          count = 4,
          hr_version = {
            picture = tiles_graphics_path .. "hr-concrete-o.png",
            count = 4,
            scale = 0.5,
          },
        },
        o_transition_mask = {
          picture = "__base__/graphics/terrain/concrete/concrete-o-mask.png",
          count = 4,
          hr_version = {
            picture = "__base__/graphics/terrain/concrete/hr-concrete-o-mask.png",
            count = 4,
            scale = 0.5,
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

      walking_sound = refined_concrete_sounds,

      map_color = map_color,
      pollution_absorption_per_second = 0,
      vehicle_friction_modifier = 0.75,
    },
  })
end

-- Black & white tiles from Krastorio 2
create_tile("black", 95, { r = 40, g = 40, b = 40 })
create_tile("white", 90, { r = 110, g = 110, b = 110 })

-- Additional tiles
-- create_tile("red", 93, { r = 128, g = 34, b = 34 })

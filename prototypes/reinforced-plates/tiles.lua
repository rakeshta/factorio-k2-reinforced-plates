--
--  tiles.lua
--  factorio-k2-reinforced-plates
--
--  Created by Rakesh Ayyaswami on 03 Jan 2023.
--  Aligned with Krastorio 2.0.16 reinforced plate tiles (Factorio 2.x).
--

local tiles_graphics_path = k2_reinforced_plates .. "graphics/reinforced-plates/"
local tile_sounds = require("__base__/prototypes/tile/tile-sounds")

--- Mask layout shared with vanilla concrete (matches Krastorio2 black/white tiles).
local function mask_layout()
  return {
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
  }
end

--- White tile: vanilla concrete transition spritesheets (Krastorio2 white-reinforced-plate.lua).
local function transition_variants_base_overlay()
  return {
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
      mask_layout = mask_layout(),
    },
  }
end

--- Black tile: Krastorio2-style darkened overlays from this mod's graphics (Krastorio2 black-reinforced-plate.lua).
local function transition_variants_mod_overlay()
  local p = tiles_graphics_path
  return {
    transition = {
      overlay_layout = {
        inner_corner = {
          spritesheet = p .. "concrete-inner-corner.png",
          count = 16,
          scale = 0.5,
        },
        outer_corner = {
          spritesheet = p .. "concrete-outer-corner.png",
          count = 8,
          scale = 0.5,
        },
        side = {
          spritesheet = p .. "concrete-side.png",
          count = 16,
          scale = 0.5,
        },
        u_transition = {
          spritesheet = p .. "concrete-u.png",
          count = 8,
          scale = 0.5,
        },
        o_transition = {
          spritesheet = p .. "concrete-o.png",
          count = 4,
          scale = 0.5,
        },
      },
      mask_layout = mask_layout(),
    },
  }
end

--- @param variant string e.g. "black", "white"
--- @param layer number
--- @param map_color table RGB map color e.g. { r = 40, g = 40, b = 40 }
--- @param use_k2_style_overlays boolean true = mod concrete-* overlays (black), false = base overlays (white)
local function create_tile(variant, layer, map_color, use_k2_style_overlays)
  local name = "kr-" .. variant .. "-reinforced-plate"
  k2_tile_variants[variant] = name

  local concrete = data.raw.tile and data.raw.tile.concrete
  if not concrete then
    error("[k2-reinforced-plates] Base tile 'concrete' not found; cannot inherit transitions.")
  end

  local variants_block = use_k2_style_overlays and transition_variants_mod_overlay() or
      transition_variants_base_overlay()
  variants_block.material_background = {
    picture = tiles_graphics_path .. variant .. "-reinforced-plate.png",
    count = 16,
    scale = 0.5,
  }

  data:extend({
    {
      type = "tile",
      name = name,
      needs_correction = false,
      minable = { mining_time = 0.1, result = name },
      mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
      collision_mask = { layers = { ground_tile = true } },
      walking_speed_modifier = 1.75,
      layer = layer,
      layer_group = "ground-artificial",
      transition_overlay_layer_offset = 2, -- need to render border overlay on top of hazard-concrete
      decorative_removal_probability = 0.95,
      variants = variants_block,

      transitions = concrete.transitions,
      transitions_between_transitions = concrete.transitions_between_transitions,

      walking_sound = tile_sounds.walking.refined_concrete,

      map_color = map_color,
      absorptions_per_second = { pollution = 0 },
      vehicle_friction_modifier = 0.75,
    },
  })
end

-- Black: K2-style overlays + material; white: vanilla overlays + material (Krastorio2 2.0.16 parity)
create_tile("black", 95, { r = 40, g = 40, b = 40 }, true)
create_tile("white", 90, { r = 110, g = 110, b = 110 }, false)

dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua")

local entity = GetUpdatedEntityID()
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" )
if not projectile then return end

local damage_plus_lifetime_limit = EntityGetVariableNumber( entity, "gkbrkn_damage_plus_lifetime_limit", 0 )
-- TODO remove this script when we can't buff anymore
if GameGetFrameNum() > damage_plus_lifetime_limit then return end

local damage_plus_lifetime_stacks = EntityGetVariableNumber( entity, "gkbrkn_damage_plus_lifetime_stacks", 0 )

-- Nx damage over 60 frames
adjust_all_entity_damage( entity, function( current ) return current * (math.pow( damage_plus_lifetime_stacks + 1.0, 1.0 / 60.0 )) end )
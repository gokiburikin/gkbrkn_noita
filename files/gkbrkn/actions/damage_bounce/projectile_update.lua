dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua")

local e = GetUpdatedEntityID()
local p = EntityGetFirstComponent( e, "ProjectileComponent" )
if not p then return end
local damage_plus_bounce_stacks = EntityGetVariableNumber( e, "gkbrkn_damage_plus_bounce_stacks", 0 )
local buffable_bounces_remaining = EntityGetVariableNumber( e, "gkbrkn_buff_bounces_remaining", 0 )
-- TODO remove this script when we can't buff anymore
if buffable_bounces_remaining <= 0 then return end

local last_bounces = EntityGetVariableNumber( e, "gkbrkn_bounces_last" )
local current_bounces = ComponentGetValue2( p, "bounces_left" )
local bounces_done = math.min( last_bounces - current_bounces, buffable_bounces_remaining )
if bounces_done <= 0 then return end

EntityAdjustVariableNumber( e, "gkbrkn_buff_bounces_remaining", 0, function(value) return tonumber( value ) - bounces_done end )
EntitySetVariableNumber( e, "gkbrkn_bounces_last", current_bounces )

-- Nx after 10 bounces
adjust_all_entity_damage( e, function( current ) return current * math.pow( damage_plus_bounce_stacks + 1.0, bounces_done / 5.0 ) end )
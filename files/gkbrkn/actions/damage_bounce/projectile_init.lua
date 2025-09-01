dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")

local e = GetUpdatedEntityID()
local p = EntityGetFirstComponent( e, "ProjectileComponent" )
if not p then return end
EntityAdjustVariableNumber( e, "gkbrkn_damage_plus_bounce_stacks", 0, function( value ) return tonumber( value ) + 1 end )
EntitySetVariableNumber( e, "gkbrkn_bounces_last", ComponentGetValue2( p, "bounces_left" ) )
EntitySetVariableNumber( e, "gkbrkn_buff_bounces_remaining", 5 )
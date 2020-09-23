dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
EntityAdjustVariableNumber( entity, "gkbrkn_follow_shot_multiplier", 0, function( value ) return tonumber( value ) + 1; end );

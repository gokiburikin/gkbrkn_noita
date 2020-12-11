dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile ~= nil then ComponentSetValue2( projectile, "lifetime", -1 ); end

local lifetime = EntityGetFirstComponentIncludingDisabled( entity, "LifetimeComponent" );
if lifetime ~= nil then EntityRemoveComponent( lifetime ); end

EntitySetVariableNumber( entity, "gkbrkn_mana_drain", 0.5 );
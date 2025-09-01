dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" )
local e = GetUpdatedEntityID()
local projectile = EntityGetFirstComponent( e, "ProjectileComponent" )
if not projectile then EntityKill( e ) return end

local shooter = ComponentGetValue2( projectile, "mWhoShot" )
if not shooter or shooter == 0 then EntityKill( e ) return end

local held_wand = get_entity_held_or_random_wand( shooter, false )
if not held_wand then EntityKill( e ) return end

local ability = WandGetAbilityComponent( held_wand, "AbilityComponent" )
if not ability then EntityKill( e ) return end

local mana = ComponentGetValue2( ability, "mana" )
local mana_drain = EntityGetVariableNumber( e, "gkbrkn_mana_drain", 0 )
-- 60 because the script only runs every second
if mana > mana_drain * 60 then
    ComponentSetValue2( ability, "mana", math.max( mana - mana_drain * 60, 0 ) )
else
    EntityKill( e )
end
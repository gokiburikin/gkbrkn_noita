dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile ~= nil then
    local shooter = ComponentGetValue2( projectile, "mWhoShot" );
    if shooter and shooter ~= 0 then
        local held_wand = get_entity_held_or_random_wand( shooter, false );
        if held_wand then
            local ability = WandGetAbilityComponent( held_wand, "AbilityComponent" );
            if ability ~= nil then
                local mana = ComponentGetValue2( ability, "mana" );
                local mana_drain = EntityGetVariableNumber( entity, "gkbrkn_mana_drain", 0 );
                if mana > mana_drain then
                    ComponentSetValue2( ability, "mana", math.max( mana - mana_drain, 0 ) );
                else
                    EntityKill( entity );
                end
            end
        else
            EntityKill( entity );
        end
    end
end

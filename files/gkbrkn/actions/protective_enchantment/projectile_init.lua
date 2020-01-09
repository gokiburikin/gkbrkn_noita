dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    ComponentSetValue( projectile, "explosion_dont_damage_shooter", "1" );
    --ComponentSetValue( projectile, "never_hit_player", "1" );
    ComponentSetValue( projectile, "friendly_fire", "0" );
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    local shooter = ComponentGetValue( projectile, "mWhoShot" );
    if shooter ~= nil then
        EntityIterateComponentsByType( entity, "AreaDamageComponent", function(component)
            if EntityHasTag( shooter, "player_unit" ) then
                ComponentSetValue( component, "entities_with_tag", "enemy" );
            else
                ComponentSetValue( component, "entities_with_tag", "player_unit" );
            end
        end );
    end
    adjust_entity_damage( entity,
        function( current_damage ) return current_damage * 0.3; end,
        function( current_damages )
            for type,damage in pairs( current_damages ) do
                if damage ~= 0 then
                    current_damages[type] = damage * 0.3;
                end
            end
            return current_damages;
        end,
        function( current_damage ) return current_damage * 0.3; end,
        function( current_damage ) return current_damage * 0.3; end,
        function( current_damage ) return current_damage * 0.3; end
    );
end


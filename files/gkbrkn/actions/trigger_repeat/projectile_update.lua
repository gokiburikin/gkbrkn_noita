dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
local link_time = EntityGetVariableNumber( entity, "gkbrkn_link_time", 0 );
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile then
    if link_time == 0 then
        local depth = ComponentObjectGetValue2( projectile, "config", "action_unidentified_sprite_filename" );
        if depth then
            local _,_,depth = depth:find("trigger_repeat_(%d+)");
            if depth then
                local x,y = EntityGetTransform( entity );
                local found_parent = false;
                depth = tonumber( depth );
                for k,nearby in pairs( EntityGetInRadius(x,y,128) or {}) do
                    if nearby ~= entity and EntityGetIsAlive( nearby ) == true then
                        local nearby_projectile = EntityGetFirstComponentIncludingDisabled( nearby, "ProjectileComponent" );
                        if nearby_projectile then
                            local nearby_depth = ComponentObjectGetValue2( nearby_projectile, "config", "action_unidentified_sprite_filename" );
                            local id = ComponentObjectGetValue2( nearby_projectile, "config", "action_id" );
                            if nearby_depth then
                                local _,_,nearby_depth = nearby_depth:find("trigger_repeat_(%d+)");
                                if tonumber(nearby_depth) == tonumber(depth) then
                                    EntitySetVariableNumber( entity, "gkbrkn_link_time", GameGetFrameNum() );
                                    EntityAddChild( nearby, entity );
                                    local link_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/trigger_entity.xml", x, y  );
                                    EntityAddChild( entity, link_entity );
                                    found_parent = true;
                                    break;
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if (GameGetFrameNum() - link_time) % 15 == 0 then
        ComponentSetValue2( projectile, "collide_with_tag", "gkbrkn_trigger_repeat" );
    else
        ComponentSetValue2( projectile, "collide_with_tag", "" );
    end
end
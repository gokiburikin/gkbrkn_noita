if PerkLostTreasureUpdate ~= nil then PerkLostTreasureUpdate(); end

local tracked_projectiles = EntityGetWithTag( "gkbrkn_projectile_orbit" );
if #tracked_projectiles > 0 then
    local previous_projectile = nil;
    local leader = nil;
    for i,projectile in pairs(tracked_projectiles) do
        EntityRemoveTag( projectile, "gkbrkn_projectile_orbit" );
        if previous_projectile ~= nil then
            EntityAddChild( leader, projectile );
            EntityAddComponent( projectile, "VariableStorageComponent", {
                _tags="gkbrkn_orbit",
                name="gkbrkn_orbit",
                value_string=tostring(#tracked_projectiles);
                value_int=tostring(i-1);
            } );
            EntityAddComponent( projectile, "LuaComponent", { script_source_file="files/gkbrkn/actions/projectile_orbit/projectile_update.lua", execute_on_added="1" } );
        else
            leader = projectile;
        end
        previous_projectile = projectile;
    end
end

--[[
    local players = EntityGetWithTag( "player_unit" );
    for _,player in pairs( players ) do
        local x, y = EntityGetTransform( player );
        local nearby_entities = EntityGetInRadius( x, y, 128 );
        for _,entity in pairs( nearby_entities ) do
            if EntityHasTag( entity, "gkbrkn_bad_aimer" ) == false then
                local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" );
                if animal_ais ~= nil then
                    for _,ai in pairs( animal_ais ) do
                        ComponentSetValue( ai, "creature_detection_range_x", "100" );
                        ComponentSetValue( ai, "creature_detection_range_y", "100" );
                        --ComponentSetValue( ai, "attack_ranged_frames_between", "10" );
                        GamePrint("made enemy "..entity.." suck at detection");
                    end
                    EntityAddTag( entity, "gkbrkn_bad_aimer" );
                end
            end
        end
    end
    ]]

    --GameCreateParticle( "gold", -0, -100, 1, 0, 0, false )
    --GamePrint( #EntityGetWithTag("gkbrkn_action_orbit") );
    
    --[[
    local players = EntityGetWithTag( "player_unit" );
    if players ~= nil then
        for index,player_entity_id in pairs( players ) do
            local component = EntityGetFirstComponent( player_entity_id, "Inventory2Component" );
            GamePrint( component.."@ herd"..ComponentGetValue( component, "mActiveItem" ) );
        end
    end
    ]]
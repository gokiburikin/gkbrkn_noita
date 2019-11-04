local last_gold_check = 0;
local check_radius = 256;
local gold_check_interval = 40;
local script_tag = "gkbrkn_lost_treasure_gold_nugget";

function IsGoldNuggetLostTreasureSpawned( entity )
    return EntityHasTag( entity, "gkbrkn_lost_treasure_nugget" );
end

function IsGoldNuggetLostTreasure( entity )
    local component = EntityGetFirstComponent( entity, "LuaComponent", script_tag );
    return component ~= nil;
end

function PerkLostTreasureUpdate()
    local now = GameGetFrameNum();
    if now - last_gold_check >= gold_check_interval then
        last_gold_check = now;
        -- iterate through all components of all entities around all players to find
        -- nuggets we haven't tracked
        local players = EntityGetWithTag( "player_unit" );
        local natural_nuggets = {};
        for index,player in pairs( players ) do
            local x, y = EntityGetTransform( player );
            local nearby_entities = EntityGetInRadius( x, y, check_radius );
            for _,entity in pairs( nearby_entities ) do
                -- TODO  this is technically safer since disabled components don't show up, but if it's disabled then
                -- we probably don't want to consider this nugget anyway
                if IsGoldNuggetLostTreasure( entity ) == false and IsGoldNuggetLostTreasureSpawned( entity) == false then
                    local components = EntityGetComponent( entity, "LuaComponent" );
                    if components ~= nil then
                        for _,component in pairs(components) do
                            if ComponentGetValue( component, "script_item_picked_up" ) == "data/scripts/items/gold_pickup.lua" then
                                table.insert( natural_nuggets, entity );
                            end
                        end
                    end
                end
            end
        end
        for index,nugget in pairs( natural_nuggets ) do
            local component = EntityAddComponent( nugget, "LuaComponent", {
                _tags=script_tag,
                execute_on_added="1",
                execute_every_n_frame="-1",
                script_source_file = "files/gkbrkn/perk_lost_treasure_init.lua",
            });
            local component = EntityAddComponent( nugget, "LuaComponent", {
                _tags=script_tag,
                script_item_picked_up = "files/gkbrkn/perk_lost_treasure_pickup.lua",
            });
        end
    end
end
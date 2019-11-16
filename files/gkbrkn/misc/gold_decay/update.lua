local last_gold_check = 0;
local check_radius = 192;
local gold_check_interval = 40;

function IsGoldNuggetTracked( entity ) return EntityGetFirstComponent( entity, "LuaComponent", "gkbrkn_gold_decay" ) ~= nil; end

local now = GameGetFrameNum();
if now - last_gold_check >= gold_check_interval then
    last_gold_check = now;
    -- iterate through all components of all entities around all players to find
    -- nuggets we haven't tracked
    local natural_nuggets = {};
    local nearby_entities = EntityGetInRadius( x, y, check_radius );
    for _,entity in pairs( nearby_entities ) do
        -- TODO  this is technically safer since disabled components don't show up, but if it's disabled then
        -- we probably don't want to consider this nugget anyway
        if IsGoldNuggetTracked( entity ) == false then
            local components = EntityGetComponent( entity, "LuaComponent" );
            if components ~= nil then
                for _,component in pairs(components) do
                    -- TODO there needs to be a better more future proofed way to get gold nuggets
                    if ComponentGetValue( component, "script_item_picked_up" ) == "data/scripts/items/gold_pickup.lua" then
                        EntityAddComponent( entity, "LuaComponent", {
                            execute_every_n_frame = "-1",
                            remove_after_executed = "1",
                            script_item_picked_up = "files/gkbrkn/misc/gold_decay/gold_pickup.lua",
                        });
                        EntityAddComponent( entity, "LuaComponent", {
                            _tags="gkbrkn_gold_decay",
                            execute_on_removed="1",
                            execute_every_n_frame="-1",
                            script_source_file = "files/gkbrkn/misc/gold_decay/gold_removed.lua",
                        });
                        --local ex, ey = EntityGetTransform( entity );
                        --GamePrint( "New nuggy found at "..ex..", "..ey );
                    end
                end
            end
        end
    end
end
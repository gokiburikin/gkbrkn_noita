dofile_once( "data/scripts/lib/utilities.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );

local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
y = y - 4; -- offset to middle of character

local range = 500;
local indicator_distance = 24;

local is_chest = function( entity )
    for _,component in pairs( FindComponentByType( entity, "LuaComponent" ) or {} ) do
        local script_item_picked_up = ComponentGetValue( component, "script_item_picked_up" );
        if script_item_picked_up == "data/scripts/items/chest_random.lua" or script_item_picked_up == "data/scripts/items/chest_random_super.lua" then
            return true;
        end
    end
end

local is_potion = function( entity )
    for _,component in pairs( FindComponentByType( entity, "LuaComponent" ) or {} ) do
        local script_item_picked_up = ComponentGetValue( component, "script_item_picked_up" );
        if script_item_picked_up == "data/scripts/items/potion_effect.lua" then
            return true;
        end
    end
end

local is_heart_pickup = function( entity )
    for _,component in pairs( FindComponentByType( entity, "LuaComponent" ) or {} ) do
        local script_item_picked_up = ComponentGetValue( component, "script_item_picked_up" );
        if script_item_picked_up == "data/scripts/items/heart.lua" or 
        script_item_picked_up == "data/scripts/items/heart_fullhp.lua" or 
        script_item_picked_up == "data/scripts/items/heart_fullhp_temple.lua" or 
        script_item_picked_up == "data/scripts/items/heart_better.lua" or 
        script_item_picked_up == "data/scripts/items/heart_evil.lua"
        then
            return true;
        end
    end
end

local is_treasure = function( entity )
    local item = EntityGetFirstComponent( entity, "ItemComponent" );
    local is_treasure = false;
    if item ~= nil and EntityHasTag( entity, "gold_nugget" ) == false then
        is_treasure = ComponentGetValue( item, "auto_pickup" ) == "1";
        if is_treasure == false then
            if EntityHasTag( entity, "wand" ) == false then
                is_treasure = true;
            end
        end
    end
    return is_treasure;
end

local nearby_entities = EntityGetInRadius( x, y, range ) or {};
-- ping nearby treasure
for _,nearby in pairs( nearby_entities ) do
    local is_treasure = is_treasure( nearby );
    if is_treasure then
        local sprite_prefix = "";
        if is_chest( nearby ) then
            sprite_prefix = "chest_";
        elseif is_potion( nearby ) then
            sprite_prefix = "potion_";
        elseif is_heart_pickup( nearby ) then
            sprite_prefix = "heart_";
        end
        local tx, ty = EntityGetTransform( nearby );
        local dx, dy = tx - x, ty - y;
        local distance = get_magnitude( dx, dy );

        -- sprite positions around character
        dx, dy = vec_normalize( dx, dy );
        local ix = x + dx * indicator_distance;
        local iy = y + dy * indicator_distance;

        -- display sprite based on proximity
        if distance > range * 0.5 then
            GameCreateSpriteForXFrames( "mods/gkbrkn_noita/files/gkbrkn/perks/treasure_radar/"..sprite_prefix.."faint.png", ix, iy );
        elseif distance > range * 0.25 then
            GameCreateSpriteForXFrames( "mods/gkbrkn_noita/files/gkbrkn/perks/treasure_radar/"..sprite_prefix.."medium.png", ix, iy );
        elseif distance > 10 then
            GameCreateSpriteForXFrames( "mods/gkbrkn_noita/files/gkbrkn/perks/treasure_radar/"..sprite_prefix.."strong.png", ix, iy );
        end
    end
end

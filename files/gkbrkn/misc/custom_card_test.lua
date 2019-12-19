GamePrint("custom card test" );
local entity = GetUpdatedEntityID();
local sprite = EntityGetFirstComponent( entity, "SpriteComponent", "icon" );
if sprite ~= nil then
    local border = EntityGetFirstComponent( entity, "SpriteComponent", "border" );
    if border == nil then
        EntityAddComponent( entity, "SpriteComponent", {
            _tags="border,enabled_in_inventory,enabled_in_world,enabled_in_hand",
            offset_x="8",
            offset_y="17",
			image_file="mods/gkbrkn_noita/files/gkbrkn/actions/gilded.png" 
        });
    end
    ComponentSetValue( sprite, "image_file", "mods/gkbrkn_noita/files/gkbrkn/actions/gilded.png" );
end
local item = EntityGetFirstComponent( entity, "ItemComponent" );
if item ~= nil then
    --ComponentSetValue( item, "ui_sprite", "mods/gkbrkn_noita/files/gkbrkn/misc/custom_card_sprite.xml" );
end

local item2 = EntityGetFirstComponent( entity, "ItemComponent", "testitem" );
if item2 == nil then
    GamePrint("adding another item copmponent");
    EntityAddComponent( entity, "ItemComponent", {
        _tags="enabled,enabled_in_world,enabled_in_inventory",
		play_spinning_animation="0",
        preferred_inventory="FULL",
        ui_sprite="mods/gkbrkn_noita/files/gkbrkn/misc/custom_card_sprite2.xml"
    });
    GamePrint("added another item copmponent");
end
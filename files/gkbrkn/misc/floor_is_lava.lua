local entity = GetUpdatedEntityID();
local character_data = EntityGetFirstComponent( entity, "CharacterDataComponent" );
if character_data ~= nil then
    local is_on_ground = ComponentGetValue( character_data, "is_on_ground" );
    if is_on_ground == "1" then
        local x, y = EntityGetTransform( entity );
        local take_damage = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/events/take_damage.xml", x, y );
        ComponentSetValue( EntityGetFirstComponent( take_damage, "AreaDamageComponent" ), "damage_per_frame", 1/100 );
    end
end
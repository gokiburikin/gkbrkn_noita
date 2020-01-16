--[[ friendly twitch pikku ]]
-- load the pikku
local pikku = EntityLoad( "data/entities/animals/firebug.xml", x, y - 50 );
-- give the name
EntityAddComponent( pikku, "SpriteComponent", {
    _tags="enabled_in_world",
    image_file="data/fonts/font_pixel_white.xml",
    emissive="1",
    is_text_sprite="1",
    offset_x="30" ,
    alpha="0.67",
    offset_y="-4" ,
    update_transform="1" ,
    update_transform_rotation="0",
    text=tostring("twitch name here"),
    has_special_scale="1",
    special_scale_x="0.5",
    special_scale_y="0.5",
    z_index="-9000",
});
-- here is an unlimited charm effect
local game_effect = GetGameEffectLoadTo( pikku, "CHARM", true );
if game_effect ~= nil then
    ComponentSetValue( game_effect, "frames", -1 );
end
-- replace the projectile
local animal_ais = EntityGetComponent( pikku, "AnimalAIComponent" ) or {};
for _,animal_ai in pairs( animal_ais ) do
    ComponentSetValue( animal_ai, "attack_ranged_entity_file", "data/entities/projectiles/healshot.xml" );
    ComponentSetValue( animal_ai, "tries_to_ranged_attack_friends", "1" );
    ComponentSetValue( animal_ai, "attack_melee_enabled", "0" );
    ComponentSetValue( animal_ai, "attack_dash_enabled", "0" );
end
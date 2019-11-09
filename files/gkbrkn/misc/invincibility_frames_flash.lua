local entity = GetUpdatedEntityID();

local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
local max_invincibility_frames = 0;
for _,damage_model in pairs( damage_models ) do
    local invincibility_frames = tonumber(ComponentGetValue( damage_model, "invincibility_frames" ));
    if invincibility_frames > max_invincibility_frames then
        max_invincibility_frames = invincibility_frames;
    end
end

if max_invincibility_frames > 0 then
    local game_frame = GameGetFrameNum();
    local sprites = {};
    local children = { entity };
    for _,child in pairs( children ) do
        local child_sprites = EntityGetComponent( child, "SpriteComponent" );
        if child_sprites ~= nil and #child_sprites > 0 then
            for _,sprite in pairs( child_sprites ) do
                table.insert( sprites, sprite );
            end
        end

        local child_children = EntityGetAllChildren( child );
        if child_children ~= nil and #child_children > 0 then
            for _,child_child in pairs(child_children ) do
                table.insert( children, child_child );
            end
        end
    end

    local alpha = math.floor( game_frame / 2 ) % 2;
    if max_invincibility_frames == 1 then
        alpha = 1;
    end
    
    for _,sprite in pairs( sprites ) do
        ComponentSetValue( sprite, "alpha", alpha );
    end
end

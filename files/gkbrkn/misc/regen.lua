local entity = GetUpdatedEntityID();
local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
if damage_models ~= nil then
    for index,damage_model in pairs( damage_models ) do
        local current_hp = ComponentGetValue2( damage_model, "hp" );
        local max_hp = ComponentGetValue2( damage_model, "max_hp" );
        ComponentSetValue2( damage_model, "hp", math.min( max_hp, current_hp + 1/25 ) );
    end
end
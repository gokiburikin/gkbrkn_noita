local entity = GetUpdatedEntityID();
local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
if damage_models ~= nil then
    for index,damage_model in pairs( damage_models ) do
        local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
        local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
        ComponentSetValue( damage_model, "hp", tostring( math.min( max_hp, current_hp + 1/25 ) ) );
    end
end
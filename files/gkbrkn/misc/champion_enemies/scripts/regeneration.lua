local entity = GetUpdatedEntityID();
local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
if #damage_models > 0 then
    for _,damage_model in pairs( damage_models ) do
        local max_hp = tonumber( ComponentGetValue( damage_model, "max_hp" ) );
        local current_hp = tonumber( ComponentGetValue( damage_model, "hp" ) );
        -- heal up to full over 10 seconds (assuming this is called once every 5 frames )
        ComponentSetValue( damage_model, "hp", tostring( math.min( max_hp, current_hp + max_hp * 0.0083 ) ) );
    end
end
local e = GetUpdatedEntityID()
local damage_models = EntityGetComponent( e, "DamageModelComponent" ) or {}
for _,damage_model in pairs( damage_models ) do
    ComponentSetValue2( damage_model, "blood_multiplier", ComponentGetValue2( damage_model, "blood_multiplier" ) * 0.90 )
end
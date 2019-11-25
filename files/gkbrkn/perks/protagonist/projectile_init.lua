dofile("files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local shooter = ComponentGetValue( projectile, "mWhoShot" );
    local health_ratio = 1;
    local damage_models = EntityGetComponent( shooter, "DamageModelComponent" );
    if damage_models ~= nil then
        for i,damage_model in ipairs( damage_models ) do
            local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
            local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
            local ratio = current_hp / max_hp;
            if ratio < health_ratio then
                health_ratio = ratio;
            end
        end
    end
    if shooter ~= nil then
        local current_protagonist_bonus = EntityGetVariableNumber( shooter, "gkbrkn_low_health_damage_bonus", 0.0 );
        local damage_multiplier = 1.0 + current_protagonist_bonus * ( 1 - health_ratio );
        ComponentSetValue( projectile, "damage", tostring( tonumber( ComponentGetValue( projectile, "damage" ) ) * damage_multiplier ) );
    end
end
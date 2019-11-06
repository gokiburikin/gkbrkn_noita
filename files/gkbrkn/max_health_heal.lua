if _GKBRKN_CONFIG == nil then dofile( "files/gkbrkn/config.lua"); end

if last_max_hp == nil then
    last_max_hp = {}
end
local entity_id = GetUpdatedEntityID();
local damage_models = EntityGetComponent( entity_id, "DamageModelComponent" );
for _,damage_model in pairs( damage_models ) do
    local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
    -- local last_max_hp_variable = 
    -- local last_max_hp = 
    if last_max_hp[tostring(damage_model)] == nil then
        last_max_hp[tostring(damage_model)] = tonumber(ComponentGetValue( damage_model, "max_hp" ));
    end
    if max_hp > last_max_hp[tostring(damage_model)] then
        local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
        local gained_hp = max_hp - last_max_hp[tostring(damage_model)];
        if MISC.HealOnMaxHealthUp.HealToMax == true then
            gained_hp = max_hp - current_hp;
        end
        if gained_hp > 0 then
            last_max_hp[tostring(damage_model)] = max_hp
            ComponentSetValue( damage_model, "hp", tostring( current_hp + gained_hp ) );
            GamePrint("Regained "..(gained_hp * 25).." health");
        end
    end
end
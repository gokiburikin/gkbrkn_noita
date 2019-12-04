dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

if last_max_hp == nil then
    last_max_hp = {}
end
local entity = GetUpdatedEntityID();
local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
for _,damage_model in pairs( damage_models ) do
    local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
    -- local last_max_hp_variable = 
    -- local last_max_hp = 
    if last_max_hp[tostring(damage_model)] == nil then
        last_max_hp[tostring(damage_model)] = tonumber(ComponentGetValue( damage_model, "max_hp" ));
    end
    if max_hp > last_max_hp[tostring(damage_model)] then
        local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
        local hp_difference = max_hp - current_hp;
        local gained_hp = (max_hp - last_max_hp[tostring(damage_model)]) * EntityGetVariableNumber( entity, "gkbrkn_max_health_recovery", 0.0 );
        if gained_hp > 0 then
            gained_hp = math.min( gained_hp, hp_difference );
            ComponentSetValue( damage_model, "hp", tostring( current_hp + gained_hp ) );
            if math.ceil(gained_hp) ~= 0 then
                GamePrint("Regained "..math.ceil(gained_hp * 25).." health");
            end
        end
        last_max_hp[tostring(damage_model)] = max_hp;
    end
end
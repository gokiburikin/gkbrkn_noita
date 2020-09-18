dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua" );

function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    if not is_fatal then
        local entity = GetUpdatedEntityID();
        local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
        for _,damage_model in pairs( damage_models ) do
            local current_blood_multiplier = ComponentGetValue2( damage_model, "blood_multiplier" );
            if current_blood_multiplier > 0.01 then
                ComponentSetValue2( damage_model, "blood_multiplier", current_blood_multiplier * find_tweak("blood_amount").options.Multiplier );
            else
                ComponentSetValue2( damage_model, "blood_multiplier", 0 );
            end
        end
    end
end
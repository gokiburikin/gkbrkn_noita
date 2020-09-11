function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID();
    if damage > 0 then
        if tonumber(entity) ~= tonumber(entity_thats_responsible) and tonumber(entity_thats_responsible) ~= 0 then
            EntityRemoveTag( entity, "hittable" );
            EntityAddComponent( entity, "LuaComponent", {
                remove_after_executed="1",
                execute_every_n_frame="3",
                script_source_file = "mods/gkbrkn_noita/files/gkbrkn/champion_types/intangibility_frames/intangibility_undo.lua",
            });
        end
    end
end
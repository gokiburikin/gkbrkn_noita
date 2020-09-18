dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
local entity = GetUpdatedEntityID();
local last_damage_frame = EntityGetVariableNumber( entity, "gkbrkn_last_damage_frame", 0.0 );
if GameGetFrameNum() - last_damage_frame > 60 then
    local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
    if #damage_models > 0 then
        for _,damage_model in pairs( damage_models ) do
            local max_hp = ComponentGetValue2( damage_model, "max_hp" );
            local current_hp = ComponentGetValue2( damage_model, "hp" );
            -- heal up to full over 5 seconds (assuming this is called once every 60 frames )
            if current_hp < max_hp then
                ComponentSetValue2( damage_model, "hp", math.min( max_hp, current_hp + max_hp * 0.2 ) );
            end
        end
    end
end
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_BLOOD_MAGIC", "blood_magic", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_blood_magic_stacks", 0.0, function( value ) return value + 1.0; end );
        local damage_multiplier = 3.0;
        local adjustments = {
            ice = damage_multiplier,
            electricity = damage_multiplier,
            radioactive = damage_multiplier,
            slice = damage_multiplier,
            projectile = damage_multiplier,
            --healing = damage_multiplier,
            physics_hit = damage_multiplier,
            explosion = damage_multiplier,
            poison = damage_multiplier,
            melee = damage_multiplier,
            drill = damage_multiplier,
            fire = damage_multiplier,
        };
        local damage_models = EntityGetComponent( entity_who_picked, "DamageModelComponent" );
        for index,damage_model in pairs( damage_models ) do
            for damage_type,adjustment in pairs( adjustments ) do
                local multiplier = tonumber( ComponentObjectGetValue( damage_model, "damage_multipliers", damage_type ) );
                multiplier = multiplier * adjustment;
                ComponentObjectSetValue( damage_model, "damage_multipliers", damage_type, tostring( multiplier ) );
            end
        end
	end
) );
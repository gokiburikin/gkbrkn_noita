dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local edit_callbacks = {
    PROJECTILE_REPULSION = function( perk, index )
        perk.func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_source_file = "mods/gkbrkn_noita/files/gkbrkn/tweaks/perks/projectile_repulsion.lua",
				execute_every_n_frame = "2",
			} );
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" ) or {};
            for _,damagemodel in pairs( damagemodels ) do
                local projectile_resistance = ComponentObjectGetValue2( damagemodel, "damage_multipliers", "projectile" );
                projectile_resistance = projectile_resistance * 1.26;
                ComponentObjectSetValue2( damagemodel, "damage_multipliers", "projectile", projectile_resistance );
            end
		end
    end,
    REVENGE_EXPLOSION = function( perk, index )
        perk.func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_damage_received = "mods/gkbrkn_noita/files/gkbrkn/tweaks/perks/revenge_explosion.lua",
				execute_every_n_frame = "-1",
			} )
		end
    end,
    REVENGE_TENTACLE = function( perk, index )
        perk.func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_damage_received = "mods/gkbrkn_noita/files/gkbrkn/tweaks/perks/revenge_tentacle.lua",
				execute_every_n_frame = "-1",
			} )
		end
    end,
    GLASS_CANNON = function( perk, index )
        perk.game_effect = nil;
        perk.ui_description = "Deal 3x more damage, receive 3x more damage.";
        perk.func = function( entity_perk_item, entity_who_picked, item_name )
			local adjustments = {
                ice = 3.0,
                electricity = 3.0,
                radioactive = 3.0,
                slice = 3.0,
                projectile = 3.0,
                healing = 3.0,
                physics_hit = 3.0,
                explosion = 3.0,
                poison = 3.0,
                melee = 3.0,
                drill = 3.0,
                fire = 3.0,
            };
            local damage_models = EntityGetComponent( entity_who_picked, "DamageModelComponent" );
            for index,damage_model in pairs( damage_models ) do
                for damage_type,adjustment in pairs( adjustments ) do
                    local multiplier = ComponentObjectGetValue2( damage_model, "damage_multipliers", damage_type );
                    multiplier = multiplier * adjustment;
                    ComponentObjectSetValue2( damage_model, "damage_multipliers", damage_type, multiplier );
                end
            end
            EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_damage_multiplier", 1.0, function( amount ) return amount * 3; end );
            local kicks = EntityGetComponent( entity_who_picked, "KickComponent" ) or {};
            for _,model in pairs( kicks ) do
                local kick_damage = tonumber( ComponentGetValue2( model, "kick_damage" ) ) * 3;
                ComponentsetValue2( model, "kick_damage", kick_damage );
            end
		end
    end
}

local apply_tweaks = {};
for _,tweak in pairs( tweaks ) do
    if tweak.options and tweak.options.perk_id then
        apply_tweaks[ tweak.options.perk_id ] = true
    end
end

for i=#perk_list,1,-1 do
    local perk = perk_list[i];
    if perk ~= nil then
        if edit_callbacks[ perk.id ] ~= nil and apply_tweaks[ perk.id ] == true then
            edit_callbacks[perk.id]( perk, i );
        end
    end
end
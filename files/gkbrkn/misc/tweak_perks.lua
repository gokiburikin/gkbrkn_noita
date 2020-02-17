dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua");
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
                local projectile_resistance = tonumber( ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ) );
                projectile_resistance = projectile_resistance * 1.26;
                ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring( projectile_resistance ) );
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
                    local multiplier = tonumber( ComponentObjectGetValue( damage_model, "damage_multipliers", damage_type ) );
                    multiplier = multiplier * adjustment;
                    ComponentObjectSetValue( damage_model, "damage_multipliers", damage_type, tostring( multiplier ) );
                end
            end
            EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_damage_multiplier", 1.0, function( amount ) return amount * 3; end );
            local kicks = EntityGetComponent( entity_who_picked, "KickComponent" ) or {};
            for _,model in pairs( kicks ) do
                local kick_damage = tonumber( ComponentGetMetaCustom( model, "kick_damage" ) ) * 3;
                ComponentSetMetaCustom( model, "kick_damage", kick_damage );
            end
		end
    end
}

local HARD_MODE_REMOVALS = {
    ELECTRICITY=true,
    PROTECTION_FIRE=true,
    PROTECTION_RADIOACTIVITY=true,
    PROTECTION_EXPLOSION=true,
    PROTECTION_MELEE=true,
    PROTECTION_ELECTRICITY=true,
    INVISIBLITY=true,
    TELEPORTITIS=true,
    GENOME_MORE_LOVE=true,
    GKBRKN_ALWAYS_CAST=true,
    EDIT_WANDS_EVERYWHERE=true,
};

local apply_tweaks = {};
for _,content_id in pairs( TWEAKS ) do
    local tweak = CONTENT[content_id];
    if tweak.enabled() and tweak.options ~= nil and tweak.options.perk_id ~= nil then
        apply_tweaks[ tweak.options.perk_id ] = true
    end
end

for i=#perk_list,1,-1 do
    local perk = perk_list[i];
    if perk ~= nil then
        if CONTENT[CHALLENGES.HardMode].enabled() and HARD_MODE_REMOVALS[perk.id] then
            table.remove( perk_list, i );
        elseif edit_callbacks[ perk.id ] ~= nil and apply_tweaks[ perk.id ] == true then
            edit_callbacks[perk.id]( perk, i );
        end
    end
end
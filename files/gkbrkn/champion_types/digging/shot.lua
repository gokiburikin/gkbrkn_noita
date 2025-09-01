dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
function shot( projectile_entity )
    local digging_stacks = EntityGetVariableNumber( GetUpdatedEntityID(), "gkbrkn_digging_champion_stacks", 0 )
    if digging_stacks <= 0 then return end
    local projectile = EntityGetFirstComponent( projectile_entity, "ProjectileComponent" )
    if projectile then
        ComponentSetValues( projectile, { penetrate_entities = true })
        ComponentAdjustValues( projectile, {
            ground_penetration_coeff = function( value ) return math.max( value, 3 ) * digging_stacks end,
        })
        EntityAddComponent2( projectile_entity, "CellEaterComponent", {
            radius = 4,
            eat_probability = math.min( 25 * digging_stacks, 100 ),
            eat_dynamic_physics_bodies = false,
            ignored_material = CellFactory_GetType("rock_static_cursed"),
		    ignored_material_tag = "[matter_eater_ignore_list]",
        } )
    end
end
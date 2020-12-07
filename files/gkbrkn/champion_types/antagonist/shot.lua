dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
function shot( projectile_entity )
    local entity = GetUpdatedEntityID();
    local current_protagonist_bonus = get_protagonist_bonus( entity );
    adjust_all_entity_damage( projectile_entity, function( current_damage ) return ( current_damage ) * current_protagonist_bonus; end )
end
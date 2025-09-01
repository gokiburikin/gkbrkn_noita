local WAND_HELPER = dofile( "mods/gkbrkn_noita/files/gkbrkn/lib/wand_helper.lua" )

function interacting( entity_who_interacted, entity_interacted, interactable_name )
    local active_wand = WAND_HELPER.entity_get_active_wand( entity_who_interacted )
    if active_wand then
        local held_wand = WAND_HELPER.entity_get_wands( entity_interacted )[1]
        if held_wand then
            EntityRemoveFromParent( held_wand )
            WAND_HELPER.entity_force_refresh_inventory2( entity_interacted )
        end
        EntityRemoveFromParent( active_wand )
        WAND_HELPER.entity_force_refresh_inventory2( entity_who_interacted )
        EntityAddChild( WAND_HELPER.entity_get_inventory_quick( entity_interacted ), active_wand )
        if held_wand then
            EntityAddChild( WAND_HELPER.entity_get_inventory_quick( entity_who_interacted ), held_wand )
        end
        WAND_HELPER.entity_force_refresh_inventory2( entity_interacted )
        WAND_HELPER.entity_force_refresh_inventory2( entity_who_interacted )
    end
end
function item_pickup( entity_item, entity_who_picked, item_name )
	local x, y = EntityGetTransform( entity_item );
    SetRandomSeed( x, y );

    local pull = tonumber( GlobalsGetValue( "gkbrkn_slot_machine_pulls", "0" ) );
    local chosen_action = GetRandomAction( x, y, Random( 0, 6 ), pull );
    GlobalsSetValue( "gkbrkn_slot_machine_pulls", pull + 1 );
    local action = CreateItemActionEntity( chosen_action, x, y );
    EntitySetComponentsWithTagEnabled( action,  "enabled_in_world", true );
    EntitySetComponentsWithTagEnabled( action,  "item_unidentified", false );
    local velocity = EntityGetFirstComponent( action, "VelocityComponent" );
    if velocity ~= nil then
        ComponentSetValueVector2( velocity, "mVelocity", math.random() * 150 + 50, math.random() * -100  - 100 );
    end

	EntityKill( entity_item );
	EntityLoad( "data/entities/particles/perk_reroll.xml", x, y );
	EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/slot_machine/slot_machine.xml", x, y );
end

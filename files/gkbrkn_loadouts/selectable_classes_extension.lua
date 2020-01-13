_give_loadout = give_loadout;
give_loadout = function( player_entity, class_data, x, y )
    class_data.callback( player_entity, x, y );
    _give_loadout( player_entity, class_data, x, y );
end
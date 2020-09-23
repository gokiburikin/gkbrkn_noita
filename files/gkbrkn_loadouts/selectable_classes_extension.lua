local _give_loadout = give_loadout;
give_loadout = function( player_entity, class_data, x, y )
    if class_data.callback then
        class_data.callback( player_entity, x, y );
    end
    _give_loadout( player_entity, class_data, x, y );
end

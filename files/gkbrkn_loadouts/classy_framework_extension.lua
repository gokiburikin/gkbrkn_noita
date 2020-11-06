local _setPlayerClass = setPlayerClass;
setPlayerClass = function( entity, data )
    if data.callback then
        data.callback( entity, x, y );
    end
    _setPlayerClass( entity, data, x, y );
end

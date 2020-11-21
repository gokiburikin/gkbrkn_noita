local _setPlayerClass = setPlayerClass;
setPlayerClass = function( entity, data )
    _setPlayerClass( entity, data, x, y );
    if data.callback then
        data.callback( entity, x, y );
    end
    GlobalsSetValue("gkbrkn_delay_init_frame",tostring(GameGetFrameNum()));
end

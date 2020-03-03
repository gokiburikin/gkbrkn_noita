dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );
dofile_once("data/scripts/lib/utilities.lua");

_material_area_checker_failed = _material_area_checker_failed or material_area_checker_failed;
function material_area_checker_failed( x, y )
    if GameHasFlagRun( "gkbrkn_calm_gods" ) then
    	local h = math.floor( y / 512 );
        local leak_name = "TEMPLE_LEAKED_" .. tostring( h );
    	GlobalsSetValue( leak_name, "1" );
        GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "1" );
        _material_area_checker_failed( x, y );
        GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "0" );
    else
        _material_area_checker_failed( x, y );
    end
end

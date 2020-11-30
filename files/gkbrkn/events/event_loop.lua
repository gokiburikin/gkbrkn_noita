local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" );
dofile_once( "data/scripts/lib/coroutines.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/events.lua" );
dofile_once( "data/scripts/perks/perk.lua" );
dofile_once( "data/scripts/perks/perk_list.lua" );

local next_event = nil;

function weighted_random( items, weights, sum )
	local sum = sum or nil;
	if sum == nil then
		sum = 0;
		for i,k in ipairs( weights ) do
			sum = sum + k;
		end
	end
	local random = Random() * sum;
	for i,k in ipairs( items ) do
		if random <= weights[i] then
			return k;
		end
		random = random - weights[i];
	end
end

async_loop(
    function()
        if setting_get( MISC.Events.EnabledFlag ) then
            local player_entity = EntityGetWithTag( "player_unit" )[1];
            local x, y = EntityGetTransform( player_entity );
            local valid_events = {};
            local valid_weights = {};
            for _,event in pairs( events ) do
                SetRandomSeed( GameGetFrameNum(), x + y );
                if event.condition_callback == nil or event.condition_callback( player_entity ) then
                    table.insert( valid_events, event );
                    table.insert( valid_weights, event.weight or 1 );
                end
            end
            local chosen_event = weighted_random( valid_events, valid_weights );
            if chosen_event ~= nil then
                local event_name = chosen_event.name;
                local event_message = chosen_event.message;
                local event_generator = chosen_event.generator;
                GamePrint( "Next Event: "..event_name );
                next_event = {
                    name = event_name,
                    message = event_message,
                    generator = event_generator
                };
            end
            wait( 300 );
            if next_event ~= nil then
                async( function()
                    local player_entity = EntityGetWithTag( "player_unit" )[1];
                    local generation = next_event.generator( player_entity );
                    if generation.message then
		                GamePrintImportant( generation.message, generation.note or "" );
                    end
                    local status, err = pcall( generation.callback( player_entity ) );
                    if err ~= nil then
                        print( err );
                    end
                end );
            else
                GamePrint( "No events available" );
            end
        else
            next_event = nil;
        end
        wait( 100 );
    end
);
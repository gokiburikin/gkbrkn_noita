dofile_once( "data/scripts/lib/coroutines.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );
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
        if HasFlagPersistent( MISC.Events.Enabled ) then
            local player_entity = EntityGetWithTag( "player_unit" )[1];
            local x, y = EntityGetTransform( player_entity );
            local valid_events = {};
            local valid_weights = {};
            for _,content_id in pairs( EVENTS ) do
                local event = CONTENT[ content_id ];
                if event.enabled() then
                    SetRandomSeed( GameGetFrameNum(), x + y );
                    if event.options.condition == nil or event.options.condition( player_entity ) then
                        table.insert( valid_events, event );
                        table.insert( valid_weights, event.options.weight or 1 );
                    end
                end
            end
            local chosen_event = weighted_random( valid_events, valid_weights );
            if chosen_event ~= nil then
                local event_name = "Event Name";
                local event_message = "Event Message";
                local event_callback = nil;
                if chosen_event.options.generator then
                    event_name, event_message, event_callback = chosen_event.options.generator( player_entity );
                else
                    event_name = chosen_event.options.name;
                    event_message = chosen_event.options.message;
                    event_callback = chosen_event.options.callback;
                end
                GamePrint( "Next Event: "..event_name );
                next_event = {
                    name = event_name,
                    message = event_message,
                    callback = event_callback
                };
            end
            wait( 300 );
            if next_event ~= nil then
                async( function()
                    local player_entity = EntityGetWithTag( "player_unit" )[1];
                    local status, err = pcall( next_event.callback( player_entity ) );
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
        wait( 3600 );
    end
);
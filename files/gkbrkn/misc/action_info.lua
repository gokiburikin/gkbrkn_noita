if _ACTION_INFO_INIT == nil then
    _ACTION_INFO_INIT = true;
    dofile_once("data/scripts/gun/gunaction_generated.lua"); -- ConfigGunActionInfo_Init lives here

    function get_action_info( gun_action )
        local c = {};
        ConfigGunActionInfo_Init( c );
        local projectiles = {};
        local drawn_actions = 0;
        local environment = {
            c = c,
            add_projectile = function( file_path )
                table.insert( projectiles, file_path );
            end,
            draw_actions = function( num )
                drawn_actions = drawn_actions + 1;
            end
        };
        local status,result = pcall( setfenv( gun_action.action, setmetatable( environment, { __index = _G } ) ) );
        if status == false then print_error( result ); end
        setfenv( gun_action.action, getfenv() )
        return c, projectiles, draw_actions;
    end
end

action_info = {};
for _,gun_action in pairs(actions) do
    local card, projectiles, drawn_actions = get_action_info( gun_action );
    if card ~= nil then
        local info = { card = card, projectiles = projectiles, drawn_actions = drawn_actions };
        action_info[card.id] = info;
    end
end
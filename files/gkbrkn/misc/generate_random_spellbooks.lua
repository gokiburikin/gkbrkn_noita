local dynamic_actions = {};
local volumes = {"I","II","III","IV","V","VI","VII","VIII","IX","X"};
for i=1,10 do
    SetRandomSeed( i * 191, i * 77 );
    local spellbook_name = "Encyclopedia Arcanum - Volume "..volumes[i];
    local spellbook_description = "A compilation of spells: ";
    local total_cost = 0;
    local total_mana = 0;
    local total_max_uses = nil;
    local custom_xml = nil;
    local callbacks = {};
    for i=1,Random(3,6) do
        local random_action = actions[ Random(1,#actions) ];
        if random_action.type ~= ACTION_TYPE_PASSIVE then
            if random_action.price then
                total_cost = total_cost + random_action.price;
            end
            if random_action.mana then
                total_mana = total_mana + random_action.mana;
            end
            if random_action.max_uses then
                total_max_uses = (total_max_uses or 0) + random_action.max_uses;
            end
            if i > 1 then
                spellbook_description = spellbook_description .. ", "..GameTextGetTranslatedOrNot( random_action.name );
            else
                spellbook_description = spellbook_description .. GameTextGetTranslatedOrNot( random_action.name );
            end
        else
            i = i - 1;
        end
        --[[ NOTE: You can't stack these, so ignore them
        if random_action.custom_xml_file then
            if custom_xml == nil then
                custom_xml = random_action.custom_xml_file;
            else
                custom_xml = custom_xml..","..random_action.custom_xml_file;
            end
        end
        ]]
        table.insert( callbacks, random_action.action );
    end
    table.insert( dynamic_actions, {
        id          = "GKBRKN_SPELLBOOK_"..i,
        name 		= spellbook_name,
        description = spellbook_description,
        sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/spellbook/icon.png",
        sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/spellbook/icon.png",
        type 		= ACTION_TYPE_OTHER,
        spawn_level                       = "1,2,3,4,5,6",
        spawn_probability                 = "1,1,1,1,1,1",
        price = total_cost,
        mana = total_mana,
        max_uses = total_max_uses,
        custom_xml_file = custom_xml,
        action = function()
            for _,callback in pairs(callbacks) do
                callback();
            end
        end,
        author = "goki_dev",
        local_content = true
    });
end
for _,action in pairs( dynamic_actions ) do table.insert( actions, action ); end

print("[goki's things] Generated Random Spellbooks")
dofile_once( "data/scripts/perks/perk_list.lua");
STARTING_PERKS = {};
for _,perk in pairs( perk_list ) do
    table.insert( STARTING_PERKS, register_content( CONTENT_TYPE.StartingPerk, perk.id, GameTextGetTranslatedOrNot(perk.ui_name), nil, true, nil, true ) );
end
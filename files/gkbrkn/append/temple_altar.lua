local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile( "mods/gkbrkn_noita/files/gkbrkn/content/packs.lua" );
local _spawn_hp = spawn_hp;
function spawn_hp( x, y )
	_spawn_hp( x, y );
    if HasFlagPersistent( MISC.TargetDummy.EnabledFlag ) then
        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/dummy_target.xml", x - 198, y + 40 );
    end
end

local _spawn_all_shopitems = spawn_all_shopitems;
function spawn_all_shopitems( x, y )
    if HasFlagPersistent( MISC.ShopReroll.EnabledFlag ) then
        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/shop_reroll/shop_reroll.xml", x - 35, y - 12 );
    end
    if HasFlagPersistent( MISC.SlotMachine.EnabledFlag ) then
        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/slot_machine/slot_machine.xml", x + 136, y );
    end
    if not HasFlagPersistent( MISC.PackShops.EnabledFlag) then
        _spawn_all_shopitems( x, y );
    else
        local spawn_shop, spawn_perks = temple_random( x, y )
        if( spawn_shop == "0" ) then return; end

        EntityLoad( "data/entities/buildings/shop_hitbox.xml", x, y );
        
        SetRandomSeed( x, y );
        local count = tonumber( GlobalsGetValue( "TEMPLE_SHOP_ITEM_COUNT", "5" ) );
        local width = 132;
        local item_width = width / count;

        local pack_weight_table = {};
        for _,pack_data in pairs( packs ) do
            parse_pack_action_weights( pack_data );
            pack_weight_table[ pack_data.id ] = pack_data.weight;
        end
        for i=1,count do
            --generate_shop_item( x + (i-1)*item_width, y, false, nil, true );
            local pack_data = find_pack( WeightedRandomTable( pack_weight_table ) );
            if pack_data then
                local pack_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/packs/base_pack_pickup.xml", x + (i - 1) * item_width, y );
                EntityAddComponent( pack_entity, "SpriteComponent", { 
                    _tags="shop_cost,enabled_in_world",
                    image_file="data/fonts/font_pixel_white.xml", 
                    is_text_sprite="1", 
                    offset_x="7", 
                    offset_y="25", 
                    update_transform="1" ,
                    update_transform_rotation="0",
                    text="111",
                } );
                EntitySetVariableString( pack_entity, "gkbrkn_pack_id", pack_data.id );
                if pack_data.image_filepath then
                    local sprite = EntityGetFirstComponent( pack_entity, "SpriteComponent" );
                    --if sprite then ComponentSetValue2( sprite, "image_file", pack_data.image_filepath ); end
                    if sprite then update_sprite_image( pack_entity, sprite, pack_data.image_filepath ); end
                end
                local ui_info = EntityGetFirstComponent( pack_entity, "UIInfoComponent" );
                if ui_info then ComponentSetValue2( ui_info, "name", GameTextGetTranslatedOrNot( pack_data.name ) ); end
                local item = EntityGetFirstComponent( pack_entity, "ItemComponent" );
                if item then ComponentSetValue2( item, "item_name", GameTextGetTranslatedOrNot( pack_data.name ) ); end
            else
                print( "[goki's things] Could not find pack data" );
            end
        end
    end
end

dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" )
local action_data = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/action_data.lua" )( true )

local _generate_shop_item = generate_shop_item

function generate_shop_item( x, y, cheap_item, biomeid_, is_stealable )
    local item = _generate_shop_item( x, y, cheap_item, biomeid_, is_stealable )
    if setting_get( FLAGS.ShowSpellDescriptions, false ) then
        local item_action = EntityGetFirstComponentIncludingDisabled( item, "ItemActionComponent" )
        if item_action then
            local action_id = ComponentGetValue2( item_action, "action_id" )
            local this_action_data = action_data[action_id]
            if this_action_data then
            local item = EntityGetFirstComponentIncludingDisabled( item, "ItemComponent" )
                ComponentSetValue2( item, "ui_display_description_on_pick_up_hint", true )
                ComponentSetValue2( item, "ui_description", this_action_data.description )
            end
        end
    end
    return item
end
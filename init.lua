--[[
COMPLETE
    Gold Counter (Utility)
    Enraged (Perk)
    Spell Efficiency (Perk)
    Mana Efficiency (Perk)
    Rapid Fire (Perk)
    Golden Blood (Perk)
    Knockback Immunity (Perk)

UTILITY
    Spell Power (utility stat on wand stat windows)

ACTIONS
    Mana Efficiency (Perk) needs gfx
    Swarm Projectile Modifier (like Spellbundle, but a proper modifier and on enemies)
    Sticky Projectile Modifier (stick to surfaces / enemies) (useful for what kinds of projectiles?)

PERKS
    TODO
        Chaos (randomize projectile stuff)
        A permanent +2 to Wand Capacity
        Projectile Repulsion Field (projectiles within range are subtly repelled)
        Duplicate (duplicate the wand you're holding)
        Thick Skin perk where you take less damage from status ailments like Burning, Poison, Toxic Sludge.
        The ability to swallow an item (wand, spell, flask?) and spit it back up upon taking damage? Kind of weird, but has interesting utility. Basically a janky additional inventory slot.
        Living Wand, basically create an either very healthy or immune Taikasauva of the wand you're currently holding (will be consumed to create the familiar.)
    NYI
        Dual Wield would probably be an excessively difficulty task to implement, but it would be cool if you could designate a Wand to dual wield.
        Lava, Acid, Poison (Material) Immunities (impossible for now? can ignore _all_ materials, but not individual materials)

ABANDONED
    Duplicate Projectile Modifier (dupe->quadshot->spark bolt = 4 spark bolts) (will be difficult) [someone already made this]

]]

dofile( "files/gkbrkn/helper.lua");
dofile( "files/gkbrkn/config.lua");
ModLuaFileAppend( "data/scripts/gun/gun_extra_modifiers.lua", "/files/gkbrkn/gun_extra_modifiers.lua" );
if PERKS.Enraged.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "/files/gkbrkn/perk_enraged.lua" ); end
if PERKS.LivingWand.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "/files/gkbrkn/perk_living_wand.lua" ); end
if PERKS.Duplicate.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "/files/gkbrkn/perk_duplicate.lua" ); end
if PERKS.SpellEfficiency.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "/files/gkbrkn/perk_spell_efficiency.lua" ); end
if PERKS.ManaEfficiency.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "/files/gkbrkn/perk_mana_efficiency.lua" ); end
if PERKS.RapidFire.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "/files/gkbrkn/perk_rapid_fire.lua" ); end
if PERKS.BleedGold.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "/files/gkbrkn/perk_bleed_gold.lua" ); end
if PERKS.Sturdy.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "/files/gkbrkn/perk_sturdy.lua" ); end
if PERKS.Resilience.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "/files/gkbrkn/perk_resilience.lua" ); end
if ACTIONS.ManaEfficiency.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "/files/gkbrkn/action_mana_efficiency.lua" ); end
if MISC.GoldPickupTracker.Enabled then dofile( "files/gkbrkn/gold_tracking.lua"); end

local test_gui = GuiCreate();
function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
    if SETTINGS.Debug then 
        dofile( "data/scripts/perks/perk.lua");
        local x, y = EntityGetTransform( player_entity );
        --TryGivePerk( player_entity, "EDIT_WANDS_EVERYWHERE" );
        --perk_spawn( x, y, "GKBRKN_RESILIENCE" );
        --TryGivePerk( player_entity, "GKBRKN_RESILIENCE" );
        --CreateItemActionEntity( "GKBRKN_MANA_EFFICIENCY", x, y );
    end
end

function OnWorldPostUpdate()
    if GoldTrackerUpdate ~= nil then GoldTrackerUpdate(); end
    if RenderLog ~= nil then
        GuiStartFrame( test_gui );
        GuiLayoutBeginVertical( test_gui, 1, 12 );
        RenderLog( test_gui );
        GuiLayoutEnd( test_gui );
    end
end

# Goki's Things
A collection of changes and additions to Noita. This mod contains an in-game config menu found at the top right of the screen. Use it to toggle options and custom content. **To install just download the latest release zip (not the Source code) from https://github.com/gokiburikin/gkbrkn_noita/releases and extract the gkbrkn_noita folder to your Noita mods folder.**

**I highly recommend taking the time to tailor the mod to your liking.** My intention is to offer a selection of options for the player to choose from, not for every option to be enabled. Every change this mod makes can be toggled on or off in the config menu.

## Loadouts
This mod includes a loadout manager. Enable it to control loadouts, loadout skins (for player skin support) and the toggling of individual loadouts. Goki's Things must be loaded before (higher in the list than) other loadout mods!

In the config menu you can enable loadout management under Misc > Loadouts > Manage. This will overwrite the loadout logic of supported mods and let Goki's Things handle loadouts in place of all of them, allowing compatibility between multiple loadout mods at once. Modders can also look at the loadouts file in this mod as an example of how to add new loadouts to Goki's Things.

Aside from management, you can also easily disable loadouts with the Misc > Loadouts > Enabled option, and you can choose if you want to use the custom player sprites and capes that loadouts use. This is for player character skin compatibility.

There is another mod called Selectable Classes by Ruri (https://modworkshop.net/mod/26171) that spawns class pickups at the start of the run so you can choose the loadout you want instead of rerolling for it. If Misc > Loadouts > Selectable Classes Integration is enabled alongside Selectable Classes then Goki's Things will take all managed and enabled loadouts and add them as class pickups to the starting room.

### Loadouts
- **Alchemist**: Chaotic Transmutation Acid Ball, Water, Potions, Material Compression.
- **Blood**: Magic Arrow, Magic Missile, Blood Magic.
- **Bubble**: Gravity Bubble Spark, Bouncy Dropper Shot, Fast Swimmer.
- **Charge**: Magic Hand, Stored Shot, Sparkbolt, Critical Hit +.
- **Conjurer**: Living Death Cross, Boomerang Spells.
- **Default**: The standard loadout.
- **Demolition**: Dormant Crystal, Dormant Crystal Detonator, Demolition.
- **Duplication**: Spell Duplicated Sparkbolt Field, Spell Duplicated Energy Orb, Extra Projectile.
- **Glitter**: Long Distance Glittering Trail Stored Shot, Glitter Bomb.
- **Goo Mode**: Challenge Mode. Creates Creepy Liquid that floods the world at each Holy Mountain.
- **Heroic**: Luminous Drill, Energy Shield, Protagonist.
- **Kamikaze**: Explosive Teleport, Protective Enchantment Explosion, Fire Immunity.
- **Seeker**: Double Persistent Avoiding Drilling Bolts, TNT.
- **Spark**: Electric Charge Sparkbolt Timer Zap, Thunder Charge.
- **Speedrunning**: Teleport, Black Hole, Teleportitis.
- **Treasure Hunter**: Treasure Sense, Nugget Shot, Digging Bolt, Attract Gold.
- **Trickster**: Long Distance Cast Magicbolt / Sparkbolt split cast, Forward and Back Teleport, Passive Recharge.
- **Unstable**: Chaotic Burst, Unstable Crystal, Fragile Ego.
- **Wandsmith**: Default wands. Starts with 8 random spells and Edit Wands Everywhere.
- **Zoning**: Energy Sphere Mines, Giga Death Cross.

### Loadout Mod Support
*Make sure these are below Goki's Things in the mod list for proper support*
- **Starting Loadouts**: Base game mod.
- **More Loadouts**: https://modworkshop.net/mydownloads.php?action=view_down&did=25875
- **Kaelos Archetypes**: https://modworkshop.net/mydownloads.php?action=view_down&did=26084

## Champions
Champions Mode is a challenge mode intended for players familiar with Noita. The intention is to push the player into more difficult combat scenarios that even veteran players can find difficult.

Activating Misc > Champions > Enabled will allow enemies to randomly be upgraded with special attributes. Misc > Champions > Super Champions allows the chance for additional special attributes to be applied to champion enemies, resulting in multiple attributes. The chance increases the more champions are encountered. Misc > Champions > Champions Only ensures all enemies that can be champions are champions. Misc > Champions > Mini-Bosses gives any champion a chance to gain a preset choice of champion types to make it more diffiult as well as a substantial health boost. Mini-Bosses drop a chest upon defeat.

### Champion Types
- **Armoured**: 50% damage resistance, melee and knockback immunity.
- **Burning**: Fire immunity, set nearby things on fire. Projectiles set things they hit on fire.
- **Counter/Reflect**: Counter attack with a white projectile that explodes after some time.
- **Damage Buff**: Melee, projectile, and dash damage increased.
- **Matter Eater**: Projectiles dig through the world.
- **Eldritch**: Gain a mid-range tentacle attack.
- **Electric**: Electrocute nearby materials. Projectiles electrocute things they hit.
- **Energy Shield**: Gain a weak energy shield.
- **Faster Movement**: 200% additional walking speed, 100% additional flying and jumping speed.
- **Freezing**: Freeze nearby entities and materials. Projectiles freeze things they hit.
- **Healthy**: 50% additional health.
- **Hot Blooded**: Bleed lava.
- **Ice Burst**: Shoot a burst of freezing projectile upon taking damage.
- **Infested**: Spawn rats, spiders, and blobs upon death.
- **Invisible**: Invisible.
- **Jetpack**: Gain flight.
- **Leaping**: Gain a long-range dash attack.
- **Projectile Bounce**: Projectiles gain additional bounces (4 or 2x existing bounces, whichever is higher.)
- **Projectile Buff**: Additional projectiles, additional projectile range, predicts ranged attacks.
- **Projectile Repulsion Field**: Push projectiles away.
- **Rapid Attack**: 67% increase in melee, projectile, and dash rate.
- **Regenerating**: If damage hasn't been taken in the last second, rapidly recover missing health.
- **Revenge Explosion**: Explode upon death.
- **Reward**: Spawn a chest on death (used for mini-bosses.)
- **Teleporting**: Teleport around.
- **Toxic Trail**: Projectiles gain a trail of toxic slude.

## Hero Mode
Hero mode is a challenge mode intended for players familiar with Noita. The intention is to speed up the gameplay by giving a bonus to both the player and the enemies. It is faster paced and little unfair. Combined with Champions Mode it is my attempt to create a more interesting Nightmare Mode.

When activated by Misc > Hero Mode > Enabled the player will move more quickly, all wands gain a small stat buff, and enemies become more challenging. Misc > Hero Mode > Orbs Increase Difficulty adds enemy health scaling based on the amount of orbs you've collected in the current session. Misc > Hero Mode > Distance Increases Difficulty adds enemy health scaling based on total horizontal distance travelled, so backtracking and exploring results in healthier enemies.

Enemies in Hero Mode are more aggressive, don't run when attacked, don't fight their friends, have increased creature detection, attack more rapidly, move more quickly, and consider the player the greatest threat, focusing on kill them at all cost. Invisibility has no power here.

Carnage Mode is an extra unfair difficulty intended to be a challenge for those who have cleared Ultimate Hero Ultimate Champions mode. It removes the positive side effects of Hero Mode (wand buffs, extra movement speed) and increases the negative effects. Enemies can dash short distances, fly, are fire immune, ignore charm, and attack more quickly. You get less perk options, less shop items, and the gods are angered from the start.

## Legendary Wands
Legendary wands can rarely be found in place of normal altar wands. These wands are specifically crafted builds that may or may not be editable.

- **Wormhole**: A two-way teleport with a short delay between them. Useful for peeking around corners, getting into otherwise blocked spaces checking through thin walls, or temporarily escaping a dangerous situation.

## Random Start
Options to start runs with random changes. All of these can be used separately or together.

- **Random Wands**: Start with two randomly generated wands.
- **Alternative Wand Generation**: Use my custom wand generation logic. Less predictable, potentially less usable wands.
- **Random Cape Colour**: Start with a randomly coloured cape.
- **Random Starting Health**: Start with a random amount of health from 50 to 150.
- **Random Flasks**: Start with a random assortment of flasks.
- **Random Perk**: Start with a random perk.

## Utility
These options have an impact on general gameplay and are meant to be picked and chosen based on your preferred play style.

- **Any Spell On Any Wand**: Allows any standard spell to spawn on any generated wand, ignoring spawn level.
- **Auto-collect Gold**: Automatically collect gold nuggets.
- **Auto-hide Config Menu**: Hide the config menu 5 seconds after the start of the run or closing the menu.
- **Chaotic Wand Generation**: Replace all spells on a wand with random spells.
- **Charm Nerf**: Charmed enemies no longer drop gold nuggets.
- **Chests Can Contain Perks**: Chests have a chance (12% or 25% for a super chest) to spawn a perk instead of the usual drop table (one perk only.)
- **Combine Gold**: Automatically combine nearby gold nuggets (to reduce physics load.)
- **Disable Spells**: Disable 10% of spells chosen at random at the start of each run.
- **Extended Wand Generation**: Include unused spell types (static projectiles, materials, passives, other) in procedural wand generation. - *Required for some spells to show up if using Wand Shops Only.*
- **Fixed Camera**: Keep the camera centered on the player.
- **Gold Counter**: Add a message showing how much gold was recently collected.
- **Gold Decay**: Gold nuggets will turn into gold power instead of disappearing.
- **Heal On Max Health Up**: Heal for the amount gained when gaining max health.
- **Health Bars**: Show enemy health bars.
- **Invincibility Frames**: Become invincibile for a short time when damaged by enemies.
- **Less Particles**: Reduce or disable cosmetic particle emission (to reduce particle load.)
- **Limited Ammo**: Gives all unlimited projectile spells limited uses.
- **No Preset Wands**: Replace the preset wands in the first biome with procedural wands.
- **Passive Recharge**: Wands recharge while holstered.
- **Persistent Gold**: Gold nuggets no longer despawn.
- **Quick Swap (WIP)**: Use alt-fire to switch between hotbars.
- **Show Badges**: Show selected game mode options as UI icons.
- **Show FPS**: Add an FPS counter.
- **Spell Slot Machine**: Add a slot machine that you can buy spells from in the Holy Mountain.
- **Starting Perks**: Adds the ability to start with a selection of perks from all loaded mods.
- **Target Dummy**: Add a target dummy to each Holy Mountain.
- **Unimited Ammo**: Gives all limited spells unlimited uses.
- **Wand Shops Only**: All spell shops will be replaced with wand shops.

## Content
All content can be toggled on or off. Pick and choose what you like, or disable it all if you're only interested in the utility of Goki's Things.

### Tweaks
- **Chainsaw**: Now costs mana, reduces cast delay to 0.08 instead of 0 (unless it is already lower.)
- **Chain Bolt**: Fix targeting issues.
- **Damage Field**: Reduce damage tick rate (tick rate 1 -> 5 frames.)
- **Damage Plus**: Costs more mana, doubled recharge time.
- **Explosion of Thunder**: Fixes the interaction with Protective Enchantment.
- **Freeze Charge**: Remove the particle effects (affects gameplay.)
- **Glass Cannon**: You deal 3x damage, but take 3x damage.
- **Heavy Shot**: Costs more mana, reduce damage bonus, but increase critical chance. Lower average DPS, more useful across spells that can crit.
- **Increase Mana**: Disable.
- **Projectile Repulsion**: No longer rejects self projectiles, performance improvements.
- **Reduce Stun Lock**: Reduces the time the player can't fly for when taking a knockback hit.
- **Revenge Explosion**: No longer activates on environmental / self damage, fixes the explosions not proccing when taking rapid tick (fire) damage.
- **Revenge Tentacle**: No longer activates on environmental / self damage, fixes the tentacle not proccing when taking rapid tick (fire) damage.
- **Spiral Shot**: Complete rewrite to fix the extremely heavy performance cost.

### Perks
- **Always Cast**: Upgrade a random spell on the wand you're holding (or a random wand in your inventory if you're not holding one) to always cast.
- **Blood Magic**: Your life force is used in place of mana.
- **Demolition**: Your spells cause larger, more powerful explosions.
- **Demote Always Cast**: Demote a random always cast spell on the wand you're holding (or a random wand in your inventory if you're not holding one) to a standard cast.
- **Diplomatic Immunity**: You can no longer anger the gods.
- **Duplicate**: Duplicate the wand you're holding (or a random wand in your inventory if you're not holding one.)
- **Extra Projectile**: You fire an additional projectile when casting spells, but you cast them less quickly. Spell stats are not applied twice!
- **Fragile Ego**: Receive 75% less damage, but damage is dealt to maximum health.
- **Healthier Heart**: You heal for the amount gained when gaining maximum health.
- **Invincibility Frames**: You become immune to enemy damage for a short time after taking enemy damage.
- **Knockback Immunity**: Immunity to knockback and stunlock.
- **Lead Boots**: Immunity to recoil if you're on the ground.
- **Lost Treasure**: Any gold nuggets that despawned will reappear near you for collection (the counter then resets back to 0 and picking up the perk later will work again on any newly despawned gold nuggets.)
- **Mana Manipulation**: From now on wands you find will have their mana and mana charge speed stats swapped.
- **Mana Recovery**: Your wands charge more quickly.
- **Material Compression**: Your flasks can now hold twice as much. (Concept by curry_murmurs)
- **Megacast**: You cast all of your wand's spells at once.
- **Multicast**: You cast 2 additional spells per cast.
- **Passive Recharge**: Your wands recharge even when holstered.
- **Queue Casting**: Your spells now chain cast (all spells gain Trigger - Death.)
- **Protagonist**: Your damage increases the more damaged you are.
- **Rapid Fire**: Cast spells more rapidly, but less accurately.
- **Resilience**: Take reduced damage from status ailments (reduces damage taken from fire, radioactive, poison, and electricity by 67%.)
- **Short Temper**: Become Berserk for a short time after taking damage.
- **Swapper**: Switch places with your attacker upon taking damage.
- **Thrifty Shopper**: Holy Mountain shops carry two additional items.
- **Wandsmith**: From now on wands you find will have slightly better stats.

### Spells
- **Arcane Bouquet**: Cast 2 spells the first of which bursts into multiples of the second after a timer runs out.
- **Barrier Trail**: Projectiles gain a trail of barriers.
- **Bound Shot**: Cast a spell with unlimited duration. Casting another bound spell kills any other bound spells.
- **Break Cast**: Ignore all remaining spells. (Inspired by Kaizer0002)
- **Chain Cast**: Chain cast 4 spells.
- **Chaotic Burst**: Cast an uncontrolled burst of projectiles.
- **Circle of Divine Blessing**: A field of modification magic. (Concept by curry_murmurs, name by Gastogh)
- **Copy Spell**: Cast a copy of the next unlimited use, non-copy spell.
- **Damage Plus: Bounce**: Cast a spell that gains damage after each bounce (+50% initial damage per bounce up to 10 bounces.)
- **Damage Plus: Critical**: Cast a spell that gains critical damage (+100% initial critical damage.)
- **Damage Plus: Time**: Cast a spell that gains damage over time (+100% initial per half second up to 5 seconds.)
- **Destructive Shot**: The projectile causes larger, more destructive explosions.
- **Double Cast**: Cast the next spell and a copy of the next spell.
- **Extra Projectile**: Duplicate a projectile.
- **Feather Shot**: Cast a spell with reduced knockback, gravity, and terminal velocity.
- **Follow Shot**: Cast a spell that is influenced by your movements.
- **Formation - Stack**: Cast 3 spells in parallel.
- **Glittering Trail**: The projectile gains a trail of explosions.
- **Guided Shot**: The projectile is influenced by your aim.
- **Lock Shot**: The projectile locks onto a nearby target.
- **Magic Hand**: The projectile is held in place a set distance from the tip of your wand.
- **Magic Light**: Control a magic light that cuts through darkness.
- **Mana Recharge**: Your wand charges mana slightly faster.
- **Nugget Shot**: Hurl your hard earned gold at the enemy. Requires 10 gold.
- **Order Deck**: Your wand casts spells in order.
- **Passive Recharge**: Your wand recharges even when holstered.
- **Path Correction**: Projectiles redirect towards nearby enemies.
- **Persistent Shot**: Cast 2 spells that keep moving in the direction they were cast.
- **Power Shot**: The projectile has increased damage, mass, and material penetration.
- **Projectile Burst**: Duplicate a projectile multiple times.
- **Projectile Gravity Well**: Cast 2 spells of which the first attracts the second.
- **Projectile Orbit**: Cast 2 spells of which the second will orbit the first.
- **Protective Enchantment**: Cast a spell with greatly reduced damage that can not directly damage you.
- **Queued Cast**: Cast 3 spells, each triggering the next when it expires.
- **Spell Duplicator**: Summon a magical phenomenon that casts the next spell in a random direction 5 times.
- **Spell Merge**: Cast 2 spells of which the first is merged with the second.
- **Stored Cast**: Summon a magical phenomenon that casts the next spell when you stop casting.
- **Time Split**: Equalize current cast delay and recharge time.
- **Treasure Sense**: Treasure (wands, hearts, chests, potions, etc.) cast a visible trail towards themselves.
- **Trigger: Death**: Cast a spell that casts the next spell after it expires.
- **Trigger: Hit**: Cast a spell that casts the next spell upon collision.
- **Trigger: Time**: Cast a spell that casts the next spell after a short duration.
- **Zap**: A short lived bolt of electricity.

## Deprecated
These features were disabled or removed from the mod for one reason or another. Most can still be found in the code or enabled if config.lua is changed locally to show deprecated content.

- **Action: Arcane Buckshot**: A small volley of arcane energy. *(Official spell will probably exist)*
- **Action: Arcane Shot**: A fast bolt of arcane energy. *(Superceded officially by Triplicate Bolt)*
- **Action: Collision Detection**: Cast a spell that attempts to avoid world collisions. (Concept by Wanwan) *(Superceded officially by Avoding Arc)*
- **Action: Draw Deck**: Simultaneously cast all remaining spells. *(Multiple multicasts can achieve this)*
- **Action: Formation - N-gon**: Simultaneously cast all remaining spells in a circular pattern. *(Formation - Behind your back can achieve this)*
- **Action: Golden Blessing**: Cast a spell that blesses enemies causing them to bleed gold. *(Lots of issues I don't care to fix)*
- **Action: Micro Shield**: Projectiles reflect projectiles. *(Kinda janky, messes with self projectiles)*
- **Action: Perfect Critical**: Cast a spell that is guaranteed to deal critical damage. *(Superceded by Damage Plus - Critical)*
- **Action: Piercing Shot**: Cast a spell that penetrates entities. *(Superceded officially by Piercing Shot)*
- **Action: Revelation**: Cast a spell that reveals the area around the enemy it hits. *(Not very fun or interesting)*
- **Action: Shimmering Treasure**: Treasure (wands, gold nuggets, hearts, chests, potions, etc.) is revealed in the darkness. *(Superceded by Treasure Sense)*
- **Action: Spectral Shot**: Cast a spell that passes through terrain. *(Superceded officially by Drilling Shot)*
- **Action: Super Bounce**: Cast a spell that bounces more energetically. *(Not unique enough)*
- **Other: Shuffle Deck**: Randomize the order of all remaining spells. *(Has no real uses)*
- **Perk: Golden Blood**: You bleed gold. *(Not very good or interesting)*
- **Perk: Living Wand**: Turn a random wand in your inventory into a permanent familiar. *(Superceded by another mod)*
- **Perk/Action: Mana Efficiency**: Spells drain much less mana. *(Superceded by Mana Recharge)*
- **Perk/Action: Spell Efficiency**: Most spell casts are free. *(Abandoned until a better solution is found)*
- **Tweak: Shorten Blindness**: When affected by Blindness, limit that application to 10 seconds instead of 30 seconds. *(Official patched this)*

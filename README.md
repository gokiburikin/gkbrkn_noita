# Goki's Things
A collection of changes and additions to Noita. This mod contains an in-game config menu found at the top right of the screen. Use it to toggle options and custom content. **To install just download the latest release zip (not the Source code) from https://github.com/gokiburikin/gkbrkn_noita/releases and extract the gkbrkn_noita folder to your Noita mods folder.**

This mod has a loadout manager. Enable it to control loadouts, loadout skins (for player skin support) and the toggling of individual loadouts. Goki's Things must be loaded before (higher in the list than) other loadout mods!

## Loadouts
In the config menu you can enable loadout management under Misc > Loadouts > Manage. This will overwrite the loadout logic of supported mods and let Goki's Things handle loadouts in place of all of them, allowing compatibility between multiple loadout mods at once. Modders can also look at the loadouts file in this mod as an example of how to add new loadouts to Goki's Things.

Aside from management, you can also easily disable loadouts with the Misc > Loadouts > Enabled option, and you can choose if you want to use the custom player sprites and capes that loadouts use. This is for player character skin compatibility.

### Loadouts
- **Default**: The standard loadout.
- **Demolitionist**: Dormant Crystal, Dormant Crystal Detonator, Demolitionist.
- **Heroic**: Luminous Drill, Energy Shield, Protagonist.
- **Spark**: Chain Casted Triple Zap, Electric Charger Sparkbolt.
- **Speedrunner**: Teleport, Black Hole, Teleportitis.
- **Unstable**: Chaotic Burst, Unstable Crystal, Fragile Ego.

### Loadout Mod Support
*Make sure these are below Goki's Things in the mod list for proper support*
- **Starting Loadouts**: Base game mod.
- **More Loadouts**: https://modworkshop.net/mydownloads.php?action=view_down&did=25875
- **Kaelos Archetypes**: https://modworkshop.net/mydownloads.php?action=view_down&did=26084

## Champions
Activating Misc > Champions > Enabled will allow enemies to randomly be upgraded with special attributes. Misc > Champions > Super Champions allows the chance for additional special attributes to be applied to champion enemies, resulting in multiple attributes. The chance increases the more champions are encountered. Misc > Champions > Champions Only ensures all enemies that can be champions are champions.

### Champion Types
- **Damage Buff**: Melee, projectile, and dash damage increased.
- **Projectile Buff**: Additional projectiles, additional projectile range, predicts ranged attacks.
- **Rapid Attack**: 67% increase in melee, projectile, and dash rate.
- **Faster Movement**: 200% additional walking speed, 100% additional flying and jumping speed.
- **Teleporting**: Teleport around.
- **Burning**: Fire immunity, set nearby things on fire. Projectiles set things they hit on fire.
- **Freezing**: Freeze nearby entities and materials. Proejctiles freeze things they hit.
- **Invisible**: Invisible.
- **Regenerating**: If damage hasn't been taken in the last second, rapidly recover missing health.
- **Revenge Explosion**: Explode upon death.
- **Energy Shield**: Gain a weak energy shield.
- **Electric**: Electrocute nearby materials. Projectile electrocute things they hit.
- **Projectile Repulsion Field**: Push projectiles away.
- **Healthy**: 50% additional health.
- **Hot Blooded**: Bleed lava.
- **Projectile Bounce**: Projectiles gain additional bounces (4 or 2x existing bounces, whichever is higher.)
- **Eldritch**: Gain a mid-range tentacle attack.
- **Armoured**: 50% damage resistance and knockback immunity.
- **Toxic Trail**: Projectiles gain a trail of toxic slude.
- **Counter/Reflect**: Counter attack with a white projectile that explodes after some time.
- **Infested**: Spawn rats, spiders, and blobs upon death.
- **Digging Projectile**: Projectiles gain material penetration.
- **Ice Burst**: Shoot a burst of freezing projectile upon taking damage.
- **Leaping**: Gain a long-range dash attack.

## Hero Mode
Hero mode is a challenge mode. When activated by Misc > Hero Mode > Enabled the player will move more quickly, all wands gain a small stat buff, and enemies become more challenging. Misc > Hero Mode > Orbs Increase Difficulty adds enemy health scaling based on the amount of orbs you've collected in the current session. Misc > Hero Mode > Distance Increases Difficulty adds enemy health scaling based on total horizontal distance travelled, so backtracking and exploring results in healthier enemies.

Enemies in Hero Mode are more aggressive, don't run when attacked, don't fight their friends, have increase creature detection, attack more rapidly, move more quickly, and consider the player the greatest threat, focusing on kill them at all costs.

## Content
All content can be toggled on or off. Pick and choose what you like, or disable it all if you're only interested in the utility of Goki's Things.

### Misc Features
- **Any Spell On Any Wand**: Allows any standard spell to spawn on any generated wand, ignoring spawn level.
- **Auto-collect Gold**: Automatically collect gold nuggets.
- **Auto-hide Config Menu**: Hide the config menu 5 seconds after the start of the run or closing the menu.
- **Chaotic Wand Generation**: Replace all spells on a wand with random spells.
- **Charm Nerf**: Charmed enemies no longer drop gold nuggets.
- **Combine Gold**: Automatically combine nearby gold nuggets to reduce physics load.
- **Disable Spells**: Disable 10% of spells chosen at random at the start of each run.
- **Extended Wand Generation**: Include unused spell types (static projectiles, materials, passives, other) in procedural wand generation. - *Required for some spells to show up if using Wand Shops Only.*
- **Gold Counter**: Add a message showing how much gold was picked recently.
- **Gold Decay**: When Gold Nuggets despawn, material Gold will appear in their place.
- **Heal On Max Health Up**: Heals the health gained from max health pickups.
- **Health Bars**: Show enemy health bars.
- **Invincibility Frames**: Adds invincibility frames to damage dealt by enemies.
- **Less Particles**: Reduce or disable cosmetic particle emission for extra performance.
- **Limited Ammo**: Gives all unlimited projectile spells limited uses.
- **No Preset Wands**: Replace the preset wands in the first biome with procedural wands.
- **Passive Recharge**: Wands recharge while holstered.
- **Persistent Gold**: Gold nuggets no longer despawn.
- **Quick Swap (WIP)**: Use alt-fire to switch between hotbars.
- **Random Start**: Options to start runs with random wands, perks, flasks, cape colours, and health.
- **Show Badges**: Show selected game mode options as UI icons.
- **Show FPS**: Add an FPS counter.
- **Starting Perks**: Adds the ability to start with a selection of perks from all loaded mods.
- **Target Dummy**: Add a target dummy to each Holy Mountain.
- **Unimited Ammo**: Gives all limited spells unlimited uses.
- **Wand Shops Only**: All spell shops will be replaced with wand shops.

### Tweaks
- **Chainsaw**: Now costs mana, reduces cast delay to 0.08 instead of 0 (unless it is already lower.)
- **Chain Bolt**: Fixes targeting issues.
- **Damage Field**: Reduce damage tick rate (tick rate 1 -> 5 frames.)
- **Damage Plus**: Costs more mana, doubled recharge time.
- **Freeze Charge**: Remove the particle effects (affects gameplay.)
- **Glass Cannon**: You deal 3x damage, but take 3x damage.
- **Heavy Shot**: Costs more mana, reduce damage bonus, but increase critical chance. Lower average DPS, more useful across spells that can crit.
- **Increase Mana**: Disable.
- **Revenge Explosion**: No longer activates on environmental / self damage, fixes the explosions not proccing when taking rapid tick (fire) damage.
- **Revenge Tentacle**: No longer activates on environmental / self damage, fixes the tentacle not proccing when taking rapid tick (fire) damage.

### Perks
- **Always Cast**: Upgrade a random spell on the wand you're holding (or a random wand in your inventory if you're not holding one) to always cast.
- **Chain Casting**: Your spells now chain cast (all spells gain Trigger - Death.)
- **Demolitionist**: Your spells cause larger, more powerful explosions.
- **Duplicate**: Duplicate the wand you're holding (or a random wand in your inventory if you're not holding one.)
- **Extra Projectile**: Your spells gain an additional projectile, but are less accurate and cast less quickly (their other effects aren't applied.)
- **Fragile Ego**: Receive 50% less damage, but damage is permanent (damage is dealt to maximum health.)
- **Healthier Heart**: You heal for the amount gained when gaining maximum health.
- **Invincibility Frames**: You become immune to enemy damage for a short time after taking enemy damage.
- **Knockback Immunity**: Immunity to knockback.
- **Lost Treasure**: Any gold nuggets that despawned will reappear near you for collection (the counter then resets back to 0 and picking up the perk later will work again on any newly despawned gold nuggets.)
- **Mana Recovery**: Your wands charge more quickly.
- **Material Compression**: Your flasks can now hold twice as much. (Concept by curry_murmurs)
- **Multicast**: You cast 2 additional spells per cast.
- **Passive Recharge**: Your wands recharge even when holstered.
- **Protagonist**: Your damage increases the more damaged you are.
- **Rapid Fire**: Cast spells more rapidly, but less accurately.
- **Resilience**: Take reduced damage from status ailments.
- **Short Temper**: Become Berserk for a short time after taking damage.
- **Thrifty Shopper**: Holy Mountain shops carry two additional items.
- **Swapper**: Switch places with your attacker upon taking damage.

### Projectile Spells
- **Chaotic Burst**: Cast an uncontrolled burst of projectiles.
- **Zap**: A short lived spark of electricity.

### Projectile Modifier Spells
- **Barrier Trail**: Projectiles gain a trail of barriers.
- **Break Cast**: Skip casting all remaining spells. (Inspired by Kaizer0002)
- **Damage Plus: Bounce**: Cast a spell that gains damage after each bounce.
- **Damage Plus: Time**: Cast a spell that gains damage over time.
- **Extra Projectile**: Duplicate a projectile.
- **Glittering Trail**: Projectiles gain a trail of explosions.
- **Projectile Burst**: Duplicate a projectile multiple times.
- **Path Correction**: Projectiles target enemies within a short line of sight.
- **Perfect Critical**: Cast a spell that is guaranteed to deal critical damage.
- **Power Shot**: Cast a spell with increased damage, mass, and material penetration.
- **Revelation**: Cast a spell that reveals the area around the enemy it hits.
- **Super Bounce**: Cast a spell that bounces more energetically.
- **Time Split**: Equalize current cast delay and recharge time.
- **Trigger: Hit**: Cast another spell upon collision.
- **Trigger: Time**: Cast another spell after a short duration.
- **Trigger: Death**: Cast another spell after the spell expires.

### Static Projectile Spells
- **Modification Field**: A field of modification magic. (Concept by curry_murmurs)

### Passive Spells
- **Magic Light**: Control a magic light that cuts through darkness.
- **Mana Recharge**: Your wand charges mana slightly faster.
- **Order Deck**: Your wand casts spells in order.
- **Passive Recharge**: Your wand recharges even when holstered.
- **Shimmering Treasure**: Treasure (wands, gold nuggets, hearts, chests, potions, etc.) catches your eye.

### Multicast Spells
- **Formation - Stack**: Cast 3 spells stacked vertically.
- **Projectile Gravity Well**: Cast 2 spells of which the first attracts the second.
- **Projectile Orbit**: Cast 2 spells of which the second will orbit the first.
- **Spell Merge**: Cast 2 spells of which the first is merged with the second.

### Other Spells
- **Copy Spell**: Cast a copy of the next unlimited use, non-copy spell.
- **Double Cast**: Cast the next spell and a copy of the next spell.

## Deprecated
These features were disabled or removed from the mod for one reason or another. Most can still be found in the code or enabled if config.lua is changed locally to show deprecated content.

- **Action: Arcane Buckshot**: A small volley of arcane energy. *(Official spell will probably exist)*
- **Action: Arcane Shot**: A fast bolt of arcane energy. *(Superceded officially by Triplicate Bolt)*
- **Action: Micro Shield**: Projectiles reflect projectiles. *(Kinda janky, messes with self projectiles)*
- **Perk/Action: Mana Efficiency**: Spells drain much less mana. *(Superceded by Mana Recharge)*
- **Perk/Action: Spell Efficiency**: Most spell casts are free. *(Abandoned until a better solution is found)*
- **Perk: Living Wand**: Turn a random wand in your inventory into a permanent familiar. *(Superceded by another mod)*
- **Tweak: Shorten Blindness**: When affected by Blindness, limit that application to 10 seconds instead of 30 seconds. *(Official patched this)*
- **Perk: Golden Blood**: You bleed gold. *(Not very good or interesting)*
- **Action: Golden Blessing**: Cast a spell that blesses enemies causing them to bleed gold. *(Lots of issues I don't care to fix)*
- **Other: Shuffle Deck**: Randomize the order of all remaining spells. *(Has no real uses)*
- **Formation - N-gon**: Simultaneously cast all remaining spells in a circular pattern. *(Formation - Behind your back can achieve this)*
- **Draw Deck**: Simultaneously cast all remaining spells. *(Multiple multicasts can achieve this)*
- **Piercing Shot**: Cast a spell that penetrates entities. *(Superceded officially by Piercing Shot)*
- **Spectral Shot**: Cast a spell that passes through terrain. *(Superceded officially by Drilling Shot)*
- **Collision Detection**: Cast a spell that attempts to avoid world collisions. (Concept by Wanwan) *(Superceded officially by Avoding Arc)*

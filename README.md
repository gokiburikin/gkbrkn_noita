# Goki's Things
**Do not click the Clone or download button. Check the Releases tab (https://github.com/gokiburikin/gkbrkn_noita/releases).**

**This readme is outdated. Descriptions can be found in game.**

A collection of changes and additions to Noita. **This mod contains an in-game config menu. Click the button found at the top right of the screen in-game to open the configuration menu** and use it to toggle options and custom content. **To install just download the latest release zip (not the Source code) from https://github.com/gokiburikin/gkbrkn_noita/releases and extract the gkbrkn_noita folder to your Noita mods folder.**

**I highly recommend taking the time to tailor the mod to your liking.** My intention is to offer a selection of options for the player to choose from, not for every option to be enabled. Every change this mod makes can be toggled on or off in the config menu.

## Loadouts
This mod includes a loadout manager. Enable it to control loadouts, loadout skins (for player skin support) and the toggling of individual loadouts. Goki's Things must be loaded before (higher in the list than) other loadout mods!

In the config menu you can enable loadout management under Options > Loadouts > Manage. This will overwrite the loadout logic of supported mods and let Goki's Things handle loadouts in place of all of them, allowing compatibility between multiple loadout mods at once. Modders can also look at the loadouts file in this mod as an example of how to add new loadouts to Goki's Things.

Aside from management, you can also easily disable loadouts with the Options > Loadouts > Enabled option, and you can choose if you want to use the custom player sprites and capes that loadouts use. This is for player character skin compatibility.

There is another mod called Selectable Classes by Ruri (https://modworkshop.net/mod/26171) that spawns class pickups at the start of the run so you can choose the loadout you want instead of rerolling for it. If Options > Loadouts > Selectable Classes Integration is enabled alongside Selectable Classes then Goki's Things will take all managed and enabled loadouts and add them as class pickups to the starting room.

### Loadouts
- **Alchemist**: Chaotic Transmutation Acid Ball, Water, Potions, Material Compression.
- **Blood**: Following Blood Cloud, Multi-cast Sparkbolts, More Blood.
- **Bomb**: Firecracker TNT, Unstable Crystals, Pocket Holy Bombs, Bombs Materialized.
- **Bubble**: Gravity Bubble Spark, Bouncy Dropper Shot, Fast Swimmer.
- **Charge**: Magic Hand, Stored Shot, Sparkbolt, Critical Hit +.
- **Combustion**: Bouncy Laser, Flaming Bouncing Burst, Revenge Explosion.
- **Conjurer**: Living Death Cross, Boomerang Spells.
- **Convergent**: Trigger Spark Bolt into converging Spark Bolts.
- **Default**: The standard loadout.
- **Demolition**: Dormant Crystal, Dormant Crystal Detonator, Demolition.
- **Duplication**: Spell Duplicated Sparkbolt Field, Spell Duplicated Energy Orb, Extra Projectile.
- **Event Horizon**: A challenge mode loadout. Clear the game with only an Always Cast Giga Black Hole wand!
- **Poison**: Triggered Poison Explosion, Circle of Stillness, Freeze Field.
- **Geomancer**: Soil Egg, Holy Bomb Egg, Dissolve Powders.
- **Glitter**: Long Distance Glittering Trail Stored Shot, Glitter Bomb.
- **Goo Mode**: A loadout designed for the Goo Mode and Hot Goo Mode Game Modifiers.
- **Grease**: Crit on Oil and Burning Sparkbolts, Long Distance Cast Oil Trail, Oil Blood.
- **Heroic**: Luminous Drill, Energy Shield, Protagonist.
- **Hydromancy**: Light Shot Water to Point Glowing Lance, Water conjuration, Very Fast Swimming.
- **Kamikaze**: Explosive Teleport, Protective Enchantment Explosion, Fire Immunity.
- **Knockback**: Super Burst of Air, Bomb, Lead Boots.
- **Legendary**: Starts with a random Legendary Wand.
- **Light**: Lasers, Lasers, Lasers!
- **Melting**: 
- **Rapid**: 
- **Seeker**: Double Persistent Avoiding Drilling Bolts, TNT.
- **Spark**: Electric Charge Sparkbolt Timer Zap, Thunder Charge.
- **Speed**: 
- **Speedrunning**: Teleport, Black Hole, Teleportitis.
- **Spellsword**: 
- **Taikasauva Terror**: 
- **Tentacle**: 
- **Toxic**: 
- **Treasure Hunter**: Treasure Sense, Nugget Shot, Digging Bolt, Attract Gold.
- **Trickster**: Long Distance Cast Magicbolt / Sparkbolt split cast, Forward and Back Teleport, Passive Recharge.
- **Unstable**: Chaotic Burst, Unstable Crystal, Fragile Ego.
- **Vampiric**: 
- **Wandsmith**: Default wands. Starts with 8 random spells and Edit Wands Everywhere.
- **Zoning**: Energy Sphere Mines, Giga Death Cross.

### Loadout Mod Support
*Make sure these are below Goki's Things in the mod list for proper support*
- **Starting Loadouts**: Base game mod.
- **More Loadouts**: https://modworkshop.net/mydownloads.php?action=view_down&did=25875
- **Kaelos Archetypes**: https://modworkshop.net/mydownloads.php?action=view_down&did=26084

## Champions
Champions Mode is a challenge mode intended for players familiar with Noita. The intention is to push the player into more difficult combat scenarios that even veteran players can find difficult.

Activating Options > Champions > Enabled will allow enemies to randomly be upgraded with special attributes. Options > Champions > Super Champions allows the chance for additional special attributes to be applied to champion enemies, resulting in multiple attributes. The chance increases the more champions are encountered. Options > Champions > Champions Only ensures all enemies that can be champions are champions. Options > Champions > Mini-Bosses gives any champion a chance to gain a preset choice of champion types to make it more diffiult as well as a substantial health boost. Mini-Bosses drop a chest upon defeat.

### Champion Types
- **Armoured**: 50% damage resistance, melee and knockback immunity.
- **Burning**: Fire immunity, set nearby things on fire. Projectiles set things they hit on fire.
- **Counter/Reflect**: Counter attack with a white projectile that explodes after some time.
- **Damage Buff**: Melee, projectile, and dash damage increased.
- **Eldritch**: Gain a mid-range tentacle attack.
- **Electric**: Electrocute nearby materials. Projectiles electrocute things they hit.
- **Energy Shield**: Gain a weak energy shield.
- **Faster Movement**: 200% additional walking speed, 100% additional flying and jumping speed.
- **Freezing**: Freeze nearby entities and materials. Projectiles freeze things they hit.
- **Frozen Blood**: Bleed freezing vapour.
- **Gunpowder Blooded**: Bleed unstable gunpowder.
- **Healthy**: 50% additional health.
- **Hot Blooded**: Bleed lava.
- **Ice Burst**: Shoot a burst of freezing projectile upon taking damage.
- **Infested**: Spawn rats, spiders, and blobs upon death.
- **Invisible**: Gain invisibility.
- **Jetpack**: Gain flight.
- **Leaping**: Gain a long-range dash attack.
- **Matter Eater**: Projectiles dig through the world.
- **Projectile Bounce**: Projectiles gain additional bounces (4 or 2x existing bounces, whichever is higher.)
- **Projectile Buff**: Additional projectiles, additional projectile range, predicts ranged attacks.
- **Projectile Repulsion Field**: Push projectiles away.
- **Rapid Attack**: 67% increase in melee, projectile, and dash rate.
- **Regenerating**: If damage hasn't been taken in the last second, rapidly recover missing health.
- **Revenge Explosion**: Explode upon death.
- **Reward**: Spawn a chest on death (used for mini-bosses.)
- **Sparkbolt**: Gain a basic sparkbolt projectile attack.
- **Teleporting**: Teleport randomly or when taking damage (must be near the player.)
- **Toxic Trail**: Projectiles gain a trail of toxic sludge.

## Hero Mode
Hero mode is a challenge mode intended for players familiar with Noita. The intention is to speed up the gameplay by giving a bonus to both the player and the enemies. It is faster paced and little unfair. Combined with Champions Mode it is my attempt to create a more interesting Nightmare Mode.

When activated by Options > Hero Mode > Enabled the player will move more quickly, all wands gain a small stat buff, and enemies become more challenging. Options > Hero Mode > Orbs Increase Difficulty adds enemy health scaling based on the amount of orbs you've collected in the current session. Options > Hero Mode > Distance Increases Difficulty adds enemy health scaling based on the zones encountered, so backtracking and exploring results in healthier enemies.

Enemies in Hero Mode are more aggressive, don't run when attacked, don't fight their friends, have increased creature detection, attack more rapidly, move more quickly, and consider the player the greatest threat, focusing on kill them at all cost. Invisibility has no power here.

Carnage Mode is an extra unfair difficulty intended to be a challenge for those who have cleared Ultimate Hero Ultimate Champions mode. It removes the positive side effects of Hero Mode (extra movement speed) and increases the negative effects. Enemies can dash short distances, fly, are fire immune, ignore charm, and attack more quickly. You get less perk options, less shop items, and the gods are angered from the start.

## Unique Wands
Unique wands can rarely be found in place of normal altar wands. These wands are specifically crafted builds that may or may not be editable.

- **Alchemic Lance**: Convert local materials at a cost.
- **Arcane Volley**: Rain magic down onto your enemies.
- **Auto Spell**: Summon a static phenomenon that casts guided copies of the chosen spell.
- **Bubble Burst**: Bubbles orbiting bubbles.
- **Emerald Splash**: A sudden release of many bouncing bursts.
- **Endless Alchemy**: Free chaotic transmutation. Maybe you'll strike gold?
- **Frost Wall**: Create an (inconsistent) wall of frost in an instant!
- **Magic Popcorn**: Magical gravity-defying popcorn.
- **Matra Magic**: Rapid-fire enemy seeking lasers.
- **Meat Grinder**: Slice and dice.
- **Noitius**: A powerful volley of basic spells in a pleasing formation.
- **Pocket Black Hole**: A black hole that goes wherever you do.
- **Slime Rocket**: A player-guided, explosive slime ball.
- **Soulshot**: Summon a guardian to deal with enemies that close the distance.
- **Spark Swarm**: Let loose a swarm of angry electric flies.
- **Sparkler**: An explosive sparkler. Don't hurt yourself!
- **Spirit Familiar**: Summon a powerful explosive familiar that seeks out your enemies and latches onto them.
- **Tabula Rasa**: A powerful wand with no natural mana recharge speed. Make your wildest dreams come true.
- **Telefragger**: A triggered triple cast teleport casted damage buffed teleport projectile. Shoot it near enemies to telefrag them.
- **The Atomizer**: A powerful bloom of piercing Sparkbolts gravitating around a Death Cross.
- **Trash Bazooka**: Shoot a bunch of weak spells with high spread.
- **Twin Spiral**: Spiral Shot and an orbit of Death Crosses.
- **Wavecast Whip**: A wavy, destructive stream of projectiles.
- **Wormhole**: A two-way teleport with a short delay between them. Useful for peeking around corners, getting into otherwise blocked spaces checking through thin walls, or temporarily escaping a dangerous situation.
- **Wormy**: A trail of matter eating, piercing, path correcting Energy Spheres.

## Random Start
Options to start runs with random changes. All of these can be used separately or together.

- **Random Wands**: Start with two randomly generated wands.
- **Alternative Wand Generation**: Generate random starting wands using less repetitive custom wand generation logic.
- **Random Starting Health**: Start with a random amount of health from 50 to 150.
- **Random Cape Colour**: Start with a randomly coloured cape.
- **Random Flasks**: Start with a random assortment of flasks.
- **Random Perk**: Start with a random perk.
- **Disable Random Spells**: Disable 10% of spells chosen at random at the start of each run.
- **Generate Random Spellbooks**: Generate 10 spellbooks that are a combination of 3-6 random spells.

## Utility
These options have an impact on general gameplay and are meant to be picked and chosen based on your preferred play style.

- **Log Collected Gold**: Add a message showing how much gold was recently collected.
- **Count Collected Gold**: Add an in-world ui element showing how much gold was recently collected.
- **Gold Nuggets -> Gold Powder**: Gold nuggets will turn into gold power instead of disappearing.
- **Persistent Gold**: Gold nuggets no longer despawn.
- **Auto-collect Gold**: Automatically collect all gold nuggets (even ones you didn't personally earn.)
- **Combine Gold**: Automatically combine nearby gold nuggets (to reduce physics load.)
- **Invincibility Frames**: Become invincibile for a short time when damaged by enemies. Optional: Show character invincibility flashing.
- **Heal New Health**: Heal for the amount gained when gaining max health. Optional: Full heal when collecting max health.
- **Less Particles**: Reduce or disable cosmetic particle emission (to reduce particle load.)
- **Any Spell On Any Wand**: Allows any standard spell to spawn on any generated wand, ignoring spawn level.
- **Extended Wand Generation**: Include unused spell types (static projectiles, materials, passives, other) in procedural wand generation. - *Required for some spells to show up if using Wand Shops Only.*
- **Chaotic Wand Generation**: Replace all spells on a wand with random spells.
- **No Preset Wands**: Replace the preset wands in the first biome with procedural wands.
- **Passive Recharge**: Wands recharge while holstered.
- **Health Bars**: Show enemy health bars. Optional: Slightly better looking health bars.
- **Show Entity Names**: Show the names of entities you target.
- **Show Perk Descriptions**: Show the descriptions of perks you target.
- **Show Damage Numbers**: Show custom grouped damage numbers. Much better performance when causing rapid tick damage (disable default damage numbers.)
- **Show FPS**: Add an FPS counter.
- **Show Badges**: Show selected game mode options as UI icons.
- **Auto-hide Config Menu**: Hide the config menu 5 seconds after the start of the run or closing the menu.

- **Rainbow Projectiles**: Projectiles you fire have their colours randomized.
- **Quick Swap (WIP)**: Use alt-fire to switch between hotbars.
- **Chests Can Contain Perks**: Chests have a chance (12% or 25% for a super chest) to spawn a perk instead of the usual drop table (one perk only.)
- **Target Dummy**: Add a target dummy to each Holy Mountain.
- **Spell Slot Machine**: Add a slot machine that you can buy spells from in the Holy Mountain.
- **Shop Reroller**: Add a shop reroller that will reroll items in the shop to new items of the same type.
- **Fixed Camera**: Keep the camera centered on the player.
- **Show Deprecated Content**: Allows you to enable content that was removed from Goki's Things.

### Starting Perks
Goki's Things registers all perks as potential starting perks. Toggling any perk on in the Starting Perks menu will give you one copy of that perk at the start of your run.

## Content
All content can be toggled on or off. Pick and choose what you like, or disable it all if you're only interested in the utility of Goki's Things.

### Tweaks
- **Chain Bolt**: Fix targeting issues.
- **Chainsaw**: Now costs mana, reduces cast delay to 0.08 instead of 0 (unless it is already lower.)
- **Damage Field**: Reduce damage tick rate (tick rate 1 -> 5 frames.)
- **Damage Plus**: Costs more mana, doubled recharge time.
- **Explosion of Thunder**: Fixes the interaction with Protective Enchantment.
- **Freeze Charge**: Remove the particle effects (affects gameplay.)
- **Glass Cannon**: You deal 3x damage, but take 3x damage.
- **Heavy Shot**: Costs more mana, reduce damage bonus, but increase critical chance. Lower average DPS, more useful across spells that can crit.
- **Increase Mana**: Disable.
- **Projectile Repulsion**: No longer rejects self projectiles, performance improvements.
- **Reduce Blood Amount**: Reduces the amount of blood enemies have every time they take damage so they don't flood the world.
- **Reduce Stun Lock**: Reduces the time the player can't fly for when taking a knockback hit.
- **Revenge Explosion**: No longer activates on environmental / self damage, fixes the explosions not proccing when taking rapid tick (fire) damage.
- **Revenge Tentacle**: No longer activates on environmental / self damage, fixes the tentacle not proccing when taking rapid tick (fire) damage.
- **Spiral Shot**: Complete rewrite to fix the extremely heavy performance cost.
- **Teleport Cast**: Cast on hitbox centre instead of entity origin.

### Game Modifiers
Options to spice up your runs. Most of these require a new game to activate and are active for the entire game (can't be disabled halfway) so use them to create challenge runs! Many of them can be mixed and matched to create even more crazy combinations.

*Generated wands do not include the preset wands that spawn in the first biome. You can remove those wands by using the No Preset Wands option on page 2 of the Options tab!*

- **Disintegrate Corpses**: Your kills leave no corpses behind.
- **Floor is Lava**: You take damage while grounded.
- **Free Shops**: Items in the shop will cost 0 gold.
- **Guaranteed Always Cast**: Generated wands will have at least 1 Always Cast spell.
- **Keep Moving**: Deadly barriers spawn where you've recently been. Stay clear of them!
- **Limited Ammo**: Unlimited use spells become limited.
- **Limited Mana**: Wands have more mana, but do not recharge mana.
- **No Hit**: You die in one hit.
- **No Wand Editing**: You can not edit wands.
- **Order Wands Only**: Generated wands will be Shuffle: No.
- **Remove Generic Wands**: Wands that aren't considered special (loadouts, challenges, duplicates, merged, etc.) are removed from the world.
- **Shuffle Wands Only**: Generated wands will be Shuffle: Yes.
- **Spell Shops Only**: Shops will only have spells in them.
- **Unlimited Ammo**: Limited use spells become unlimited.
- **Unlimited Levitation**: You can levitate freely.
- **Wand Shops Only**: Shops will only have wands in them.

#### Goo Modes
These modes are challenge runs that are meant to be played with the Goo Loadout! You can enable that loadout by enabling Loadouts -> Enable Loadouts on the first page of the Options tab and disabling all loadouts but the Goo Mode loadout from the Loadouts tab!

- **Corruption Goo Mode**: Corruption is spreading and converting the world. Don't get caught up in it!
- **Goo Mode**: Try to outrun the ever expanding goo! You'll drown if you get stuck in it, so move quickly!
- **Hot Goo Mode**: The floor is lava? How about the world is lava! Get away from that hot goo!
- **Killer Goo Mode**: A mysterious killer goo is consuming everything it touches! Avoid it at all cost!
- **Poly Goo Mode**: Some pretty pink goo is making everything cute and fluffy. Will this be your fate, too?

#### Hard Mode
This mode disables certain perks and spell that remove game mechanics / trivialize combat as you progress through the game.

Current changes:
- Disable the spells Freeze Charge, Increase Mana, Piercing Shot, Circle of Transmutation, and Circle of Stillness
- Disable the perks Electricity, Fire Immunity, Explosion Immunity, Melee Immunity, Electric Immunity, Invisibility, Teleportitis, More Love, Always Cast, and Edit Wands Everywhere

### Perks
- **Always Cast+**: Upgrade a random spell on the wand you're holding (or a random wand in your inventory if you're not holding one) to always cast.
- **Demolition**: Your spells cause larger, more powerful explosions.
- **Demote Always Cast**: Demote a random always cast spell on the wand you're holding (or a random wand in your inventory if you're not holding one) to a standard cast.
- **Diplomatic Immunity**: You can no longer anger the gods.
- **Duplicate Wand**: Duplicate the wand you're holding (or a random wand in your inventory if you're not holding one.)
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
- **Wand Fusion**: Fuse all of your wands into one.
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
- **Damage Plus: Bounce**: Cast a spell that gains damage after each bounce (+50% initial damage per bounce up to 10 bounces.)
- **Damage Plus: Critical**: Cast a spell that gains critical damage (+100% initial critical damage.)
- **Damage Plus: Time**: Cast a spell that gains damage over time (+100% initial per half second up to 5 seconds.)
- **Destructive Shot**: The projectile causes larger, more destructive explosions.
- **Double Cast**: The next spell cast is doubled.
- **Extra Projectile**: Duplicate a projectile.
- **Feather Shot**: Cast a spell with reduced knockback, gravity, and terminal velocity.
- **Follow Shot**: Cast a spell that is influenced by your movements.
- **Formation - Stack**: Cast 3 spells in parallel.
- **Glittering Trail**: The projectile gains a trail of explosions.
- **Guided Shot**: The projectile is influenced by your aim.
- **Imitation**: Cast a copy of the next unlimited use spell (or cast the next spell if no valid spell exists.)
- **Link Shot**: Cast 2 spells the second of which will expire when the first expires.
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
- **Projectile Gravity Well**: Cast 3 spells of which the first has the others orbit around it.
- **Projectile Orbit**: Cast 4 spells of which the first will have the others orbit it.
- **Protective Enchantment**: Cast a spell with greatly reduced damage that can not directly damage you.
- **Queued Cast**: Cast 3 spells, each triggering the next when it expires.
- **Spell Duplicator**: Summon a magical phenomenon that casts the next spell in a random direction 5 times.
- **Spell Merge**: Cast 2 spells of which the first is merged with the second.
- **Stored Cast**: Summon a magical phenomenon that casts the next spell when you stop casting.
- **Time Split**: Equalize current cast delay and recharge time.
- **Trailing Shot**: Cast 4 spells, each one following the previous.
- **Treasure Sense**: Treasure (wands, hearts, chests, potions, etc.) cast a visible trail towards themselves.
- **Trigger: Death**: Cast a spell that casts the next spell after it expires.
- **Trigger: Hit**: Cast a spell that casts the next spell upon collision.
- **Trigger: Time**: Cast a spell that casts the next spell after a short duration.
- **Triple Cast**: The next spell cast is tripled.
- **Zap**: A short lived bolt of electricity.

## Development Mode Options
- **Infinite Mana**: Rapidly recover wand mana.
- **recover Health**: Rapidly recover health.

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
- **Perk: Blood Magic**: Your life force is used in place of mana. *(Too buggy of an implementation)*
- **Perk: Golden Blood**: You bleed gold. *(Not very good or interesting)*
- **Perk: Living Wand**: Turn a random wand in your inventory into a permanent familiar. *(Superceded by another mod)*
- **Perk/Action: Mana Efficiency**: Spells drain much less mana. *(Superceded by Mana Recharge)*
- **Perk/Action: Spell Efficiency**: Most spell casts are free. *(Abandoned until a better solution is found)*
- **Tweak: Shorten Blindness**: When affected by Blindness, limit that application to 10 seconds instead of 30 seconds. *(Official patched this)*

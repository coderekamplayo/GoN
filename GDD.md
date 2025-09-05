Game Design Document (GDD): Guardian of Nature

Version: 1.1
Game Title: Guardian of Nature

1. Logline:
Guardian of Nature is a cozy 2D RPG about restoring a polluted valley to its former glory by farming the land, crafting tools, and rebuilding the community, all while using wits to avoid the Goblins and Skeletons left behind by a greedy corporation.

2. Game Overview:
Guardian of Nature is a top-down RPG focused on life-sim and crafting. The player is the Guardian of a polluted valley, and the core gameplay loop is Farming, Building, and Exploration. The primary conflict is avoiding the hostile creatures that roam the valley and cleaning up the remnants of pollution.

3. Art Style:
The game will be built exclusively using the "Sunnyside" asset pack, leveraging its vibrant 16-bit pixel art style for all characters, tiles, UI, and items.

4. Gameplay Mechanics (Revised)
This section has been updated to leverage the specific assets in the 
Sunnyside World pack.

Pillars of Restoration:

Farming & Reforestation: The land is scarred and filled with dead soil and tree stumps. The player must restore it.

Tilling & Planting: Use tools (like a hoe) to till barren dirt into fertile soil. Plant seeds from the 11 crop types provided in the asset pack.

Crop Growth: Crops will progress through their 5 stages of growth, requiring watering. The player can harvest them for food or resources.

Tree Chopping & Planting: Use an axe to clear dead tree stumps. This yields wood for crafting. The player can then plant new, healthy trees from the Sunnyside nature sprites.

Cleaning & Debris Removal: The valley is littered with industrial junk and pollution left by the G.R.I.M.E. corporation.

Junk Removal: Instead of "polluted tiles," there will be debris objects (e.g., broken barrels, scrap piles created from asset pack items) scattered on the land and in the water. The player crafts a "Cleaning Kit" (or a crowbar) to break these down into scrap materials for crafting.

Land Healing: Removing debris from a tile will automatically transform the underlying tile from barren dirt to regular grass, visually showing the land healing.


Building & Wildlife Habitats: The player can rebuild the valley's infrastructure and encourage nature to return.
Crafting & Building: Using a crafting station (workbench), the player can use gathered resources (wood, stone, scrap) to build items from the asset pack, such as fences, paths, and decorative items.
Habitat Creation: The player can build specific structures to attract wildlife. For example, building a Chicken Coop will allow chickens to spawn and roam, providing eggs. Planting flowers can spawn cosmetic butterflies.

The Antagonists (Goblins & Skeletons):
The G.R.I.M.E. corporation has left behind mischievous Goblins and mindless Skeletons (using the character sprites from the asset pack).
They follow simple patrol paths. The player must use stealth to avoid them. The game remains non-violent; the player doesn't kill them.
Getting caught sends the player back to a safe point with a minor resource penalty.
The player can craft non-lethal tools like smoke bombs (to block line of sight) or simple traps (to temporarily hold an enemy in place).

Inventory and Crafting:
A simple grid-based inventory for resources (wood, stone, crops) and tools. The UI will use the icons and elements from the Sunnyside pack.
Crafting is done at specific workbenches using simple recipes discovered through quests and exploration.


5. Story & World:
The player is the grandchild of the last Guardian of the Verdant Valley. Their goal is to restore the valley's heart, a giant, wilting tree, and drive out the remnants of the faceless "G.R.I.M.E." corporation, taking up their mantle as the new Guardian of Nature.


Development Roadmap (Revised)
This roadmap is updated to reflect the new mechanics.


Phase 1: Foundation Setup
Task 1.1: Project & File Structure
Task 1.2: Player Controller (using a Sunnyside character sprite. Implement Idle, Walk, and Run animations for 4-directions).
Task 1.3: World Creation (Use the Sunnyside tileset to create a TileMap with layers for ground, water, cliffs, and placeable foliage).


Phase 2: World Restoration System (Revised)

Task 2.1: Farming System:
Implement a tool system (hoe, watering can).
Create logic for tilling dirt tiles.
Create a "Crop" scene that progresses through its 5 growth stages (using the Sunnyside crop sprites) over time when watered.

Task 2.2: Debris & Cleaning System:
Create several "Debris" scenes that can be placed in the world.
Implement logic for the player to destroy these objects using a tool.
When destroyed, the debris should drop resources and change the underlying TileMap tile to a "healed" state (e.g., grass).

Task 2.3: Building System:
Create a simple crafting recipe system.
Allow the player to select a placeable item (like a fence) and place it on a grid in the world.


Phase 3: Quest & Inventory System
Task 3.1: Basic Inventory System
Task 3.2: Simple Crafting UI
Task 3.3: Basic UI (HUD) (using Sunnyside UI elements and icons for health, tools, etc.)
Task 3.4: NPC and Quest System (using Sunnyside character sprites)


Phase 4: Antagonist AI & Stealth
Task 4.1: Enemy AI: Create AI for the Goblins and Skeletons using their Sunnyside sprites. Implement a simple patrol path system (Path2D).
Task 4.2: Player Stealth & Non-Lethal Tools: Implement a line-of-sight system for enemies and the "getting caught" logic.


Phase 5 & 6: Polish, UI, and Finalization
Task 5.1: Save/Load System
Task 5.2: UI Screens (Title, Menus)
Task 5.3: Final Polish (Sound, Music, etc.)
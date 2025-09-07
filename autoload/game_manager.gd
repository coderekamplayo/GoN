extends Node

const PLAYER_SCENE := preload("res://actors/player/player.tscn")

var player: CharacterBody2D
var current_level: Node

func _ready() -> void:
	# Create one player for the whole game.
	player = PLAYER_SCENE.instantiate()
	player.visible = false
	# Add it AFTER current frame so the tree isn’t “busy setting up children”.
	get_tree().root.add_child.call_deferred(player)
	await get_tree().process_frame
	# Optional: ensure the player draws over maps
	if player is CanvasItem:
		(player as CanvasItem).z_index = 5

func load_level(scene_path: String) -> void:
	# Remove previous level
	if is_instance_valid(current_level):
		current_level.queue_free()
		await get_tree().process_frame

	# Instance the new level
	current_level = load(scene_path).instantiate()
	get_tree().root.add_child.call_deferred(current_level)
	await get_tree().process_frame

	# Find a Spawn marker (Marker2D named "Spawn" at level root)
	var spawn: Node2D = current_level.get_node_or_null("Spawn")

	# Reparent the player under the level (Godot 4 has Node.reparent)
	if player.get_parent() != current_level:
		player.reparent(current_level)  # safe & clean in 4.x
		await get_tree().process_frame

	# Place & show the player
	if spawn:
		player.global_position = spawn.global_position
	else:
		push_warning("[GameManager] No 'Spawn' node found in level. Player at (0,0).")
		player.global_position = Vector2.ZERO

	player.visible = true

	# Clamp camera if the Player has one
	var cam: Camera2D = player.get_node_or_null("Camera2D")
	if cam:
		_set_camera_limits_from_level(cam, current_level)

func _set_camera_limits_from_level(cam: Camera2D, level: Node) -> void:
	# Collect TileMaps by name (skip missing ones)
	var maps: Array[TileMap] = []
	for nm in ["TileMap_Terrain", "TileMap_Buildings", "TileMap_Foliage", "TileMap_Extras"]:
		var tm := level.get_node_or_null(nm)
		if tm is TileMap:
			maps.append(tm)

	if maps.is_empty():
		return

	# Merge used rects
	var merged: Rect2i = maps[0].get_used_rect()
	for i in range(1, maps.size()):
		var r: Rect2i = maps[i].get_used_rect()
		merged = merged.merge(r)

	# Use the level’s tile size if available; fallback to 16x16
	var tile_size := Vector2i(16, 16)
	for tm in maps:
		if tm.tile_set:
			tile_size = tm.tile_set.tile_size
			break

	cam.limit_left   = merged.position.x * tile_size.x
	cam.limit_top    = merged.position.y * tile_size.y
	cam.limit_right  = (merged.position.x + merged.size.x) * tile_size.x
	cam.limit_bottom = (merged.position.y + merged.size.y) * tile_size.y

extends CharacterBody2D

const SPEED := 120.0
const SPRINT_SPEED := 200.0
const JUMP_DISTANCE := 80.0
const JUMP_DURATION := 0.4
const ROLL_DISTANCE := 60.0
const ROLL_DURATION := 0.35

@onready var spr_base: AnimatedSprite2D = $Base
@onready var spr_hair: AnimatedSprite2D = $Hair
@onready var spr_tool: AnimatedSprite2D = $Tool

var _flip_h := false
var is_attacking := false
var is_jumping := false
var is_rolling := false
var last_move_direction := Vector2.DOWN

func _ready() -> void:
	_play_all("idle")
	if spr_base:
		spr_base.frame_changed.connect(_on_base_frame_changed)
		spr_base.animation_finished.connect(_on_animation_finished)

func _physics_process(_delta: float) -> void:
	# Prevent actions if the player is locked in a state
	if is_attacking or is_jumping or is_rolling:
		return

	# Handle Inputs for Actions that lock movement
	if Input.is_action_just_pressed("roll"):
		_perform_roll()
		return

	if Input.is_action_just_pressed("jump"):
		_perform_jump()
		return

	if Input.is_action_just_pressed("use_tool"):
		is_attacking = true
		_play_all("attack")
		return

	# --- Handle Regular Movement ---

	# Get movement input
	var dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")  - Input.get_action_strength("move_up")
	).normalized()
	
	if dir != Vector2.ZERO:
		last_move_direction = dir

	# Sprint
	var running := Input.is_action_pressed("sprint")
	var current_speed := (SPRINT_SPEED if running else SPEED)

	velocity = dir * current_speed
	move_and_slide()

	# --- RE-ADDED: The Interact action ---
	# We place it here so you can interact while moving or standing still.
	# It does NOT have a "return" because it shouldn't stop movement.
	if Input.is_action_just_pressed("interact"):
		print("Interact pressed") # This is now working again!

	# Update animation based on movement
	if dir != Vector2.ZERO:
		_play_all("run" if running else "walk")
	else:
		_play_all("idle")

	# Flipping logic
	if dir.x != 0.0:
		_flip_h = (dir.x < 0.0)

	for s in _layers():
		if s:
			s.flip_h = _flip_h


func _perform_roll() -> void:
	is_rolling = true
	_play_all("roll")
	
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "global_position", global_position + last_move_direction * ROLL_DISTANCE, ROLL_DURATION)


func _perform_jump() -> void:
	is_jumping = true
	_play_all("jump")
	
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "global_position", global_position + last_move_direction * JUMP_DISTANCE, JUMP_DURATION)


func _play_all(anim: String) -> void:
	for s in _layers():
		if s and s.sprite_frames and s.sprite_frames.has_animation(anim):
			if s.animation != anim or !s.is_playing():
				s.play(anim)


func _layers() -> Array:
	return [spr_base, spr_hair, spr_tool]


func _on_base_frame_changed() -> void:
	if spr_hair:
		spr_hair.frame = spr_base.frame
	if spr_tool:
		spr_tool.frame = spr_base.frame


func _on_animation_finished() -> void:
	if spr_base.animation == "attack":
		is_attacking = false
		_play_all("idle")
	elif spr_base.animation == "jump":
		is_jumping = false
		_play_all("idle")
	elif spr_base.animation == "roll":
		is_rolling = false
		_play_all("idle")

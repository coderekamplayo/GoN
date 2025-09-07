extends CharacterBody2D

const SPEED := 120.0
const SPRINT_SPEED := 200.0
const JUMP_DISTANCE := 80.0
const JUMP_DURATION := 0.4

@onready var spr_base: AnimatedSprite2D = $Base
@onready var spr_hair: AnimatedSprite2D = $Hair
@onready var spr_tool: AnimatedSprite2D = $Tool

var _flip_h := false
var is_attacking := false
var is_jumping := false
var last_move_direction := Vector2.DOWN

func _ready() -> void:
	_play_all("idle")
	if spr_base:
		spr_base.frame_changed.connect(_on_base_frame_changed)
		spr_base.animation_finished.connect(_on_animation_finished)

func _physics_process(_delta: float) -> void:
	# First, check if the player is in a state that locks them out of control.
	# If they are attacking or jumping, we do nothing else. The tween or animation
	# has full control, and we skip all physics and input checks below.
	if is_attacking or is_jumping:
		return

	# --- Handle Inputs for Actions ---
	# Check for actions that will change our state.

	# Check for Jump input
	if Input.is_action_just_pressed("jump"):
		_perform_jump()
		return # Stop processing this frame to ensure the jump is instant

	# Check for Tool Use input
	if Input.is_action_just_pressed("use_tool"):
		is_attacking = true
		_play_all("attack")
		return # Stop processing this frame

	# --- Handle Regular Movement ---
	# This code will ONLY run if the player is not attacking or jumping.

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
	
	# THIS IS THE KEY: move_and_slide() is now only called during normal movement.
	move_and_slide()

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

func _perform_jump() -> void:
	is_jumping = true
	_play_all("jump")
	
	var tween = create_tween()
	# This ensures the tween is not affected by physics process pauses
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "global_position", global_position + last_move_direction * JUMP_DISTANCE, JUMP_DURATION)

# --- The rest of your script is unchanged and correct ---

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

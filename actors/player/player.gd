extends CharacterBody2D

const SPEED := 120.0
const SPRINT_SPEED := 200.0

@onready var spr_base: AnimatedSprite2D = $Base
@onready var spr_hair: AnimatedSprite2D = $Hair
@onready var spr_tool: AnimatedSprite2D = $Tool

var _flip_h := false  # remembers last horizontal facing

func _ready() -> void:
	_play_all("idle")
	if spr_base:
		spr_base.frame_changed.connect(_on_base_frame_changed)

func _physics_process(_delta: float) -> void:
	# Movement input
	var dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")  - Input.get_action_strength("move_up")
	).normalized()

	# Sprint
	var running := Input.is_action_pressed("sprint")
	var current_speed := (SPRINT_SPEED if running else SPEED)

	velocity = dir * current_speed
	move_and_slide()

	# Choose animation
	if dir != Vector2.ZERO:
		_play_all("run" if running else "walk")
	else:
		_play_all("idle")

	# Flipping:
	# Update facing only when there is horizontal input; otherwise keep last.
	if dir.x != 0.0:
		_flip_h = (dir.x < 0.0)  # if your art faces LEFT by default, use (dir.x > 0.0)

	for s in _layers():
		if s:
			s.flip_h = _flip_h

	# Extra actions (hooks)
	if Input.is_action_just_pressed("interact"):
		print("Interact pressed")
	if Input.is_action_just_pressed("use_tool"):
		print("Use tool pressed")

# --- helpers ---
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

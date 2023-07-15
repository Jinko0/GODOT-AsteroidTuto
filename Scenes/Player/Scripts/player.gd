extends CharacterBody2D
class_name Player

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var fire_cooldown_timer = $FireCooldownTimer
@onready var gun = $Gun
@onready var invincible_frame_timer = $InvincibleFrameTimer

@export_range(0.0, 1.0) var accel_factor : float = 0.1
@export_range(0.0, 1.0) var rotation_accel_factor : float = 0.1

@export var projectile_scene : PackedScene
@export var max_speed : float = 200.0

@export var fire_cooldown : float = 0.5

var speed : float = 0.0
var direction := Vector2.ZERO
var last_direction := Vector2.ZERO

signal destroyed

func _process(delta):
	if Input.is_action_pressed("fire") && fire_cooldown_timer.is_stopped():
		fire()


func _physics_process(delta: float) -> void:
	move()
	rotate_toward_mouse()


func _input(event: InputEvent) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		last_direction = direction


func fire() -> void:
	fire_cooldown_timer.start(fire_cooldown)
	
	var projectile = projectile_scene.instantiate()
	projectile.position = gun.global_position
	projectile.rotation = rotation
	EVENTS.projectile_fired.emit(projectile)


func move() -> void:
	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, accel_factor)
	else:
		speed = lerp(speed, max_speed, accel_factor)
	
	velocity = last_direction * speed
	move_and_slide()


func rotate_toward_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	var angle = global_position.angle_to_point(mouse_pos)
	rotation = lerp_angle(rotation, angle, rotation_accel_factor)


func hit() -> void:
	animation_player.play("flash")
	invincible_frame_timer.start()


func destroy() -> void:
	destroyed.emit()
	queue_free()


func _on_invincible_frame_timer_timeout():
	animation_player.play("RESET")

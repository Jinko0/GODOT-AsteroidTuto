extends CharacterBody2D

var speed : float= 200.0
var direction := Vector2.ZERO


func _physics_process(delta: float) -> void:
	# Move the ship
	velocity = direction * speed
	move_and_slide()
	
	# Rotate the ship toward the mouse
	var mouse_pos = get_global_mouse_position()
	var angle = global_position.angle_to_point(mouse_pos)
	rotation = angle

func _input(event: InputEvent) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

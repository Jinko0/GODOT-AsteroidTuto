extends Area2D

var direction := Vector2.RIGHT

@export var speed : float = 200.0
@export var torque : float = 50.0 #torque = force de rotation sur sois même

func _physics_process(delta: float) -> void:
	var velocity = speed * direction * delta
	global_position += velocity
	rotation_degrees += torque * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.destroy()

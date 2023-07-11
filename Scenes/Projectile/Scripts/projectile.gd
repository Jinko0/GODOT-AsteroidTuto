extends Area2D
class_name Projectile

@export var speed : float = 400.0

@onready var direction := Vector2.RIGHT.rotated(rotation)

func _physics_process(delta: float) -> void:
	var velocity = direction * speed * delta
	global_position += velocity


func _on_area_entered(area):
	if area is Asteroid:
		if !self.is_queued_for_deletion():
			area.destroy()
			queue_free()

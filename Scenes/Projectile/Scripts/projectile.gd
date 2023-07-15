extends Area2D
class_name Projectile

@export var speed : float = 400.0

@onready var direction := Vector2.RIGHT.rotated(rotation)

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var damage : int = 1

func _physics_process(delta: float) -> void:
	var velocity = direction * speed * delta
	global_position += velocity
	
	if global_position > Vector2(screen_width, screen_height) or global_position < Vector2(0,0):
		queue_free()


func _on_area_entered(area):
	if area is Asteroid:
		if !self.is_queued_for_deletion():
			area.hit(damage, global_position)
			queue_free()

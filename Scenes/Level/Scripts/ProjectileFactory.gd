extends Node

func _ready() -> void:
	EVENTS.projectile_fired.connect(spawn_projectile)

func spawn_projectile(projectile) -> void:
	add_child(projectile)

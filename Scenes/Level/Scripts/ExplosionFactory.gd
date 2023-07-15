extends Node


func _ready() -> void:
	EVENTS.explosion_emited.connect(spawn_explosion)


func spawn_explosion(explosion) -> void:
	add_child(explosion)


@tool 
extends Area2D
class_name Asteroid

var direction := Vector2.RIGHT

enum SIZE {
	SMALL,
	MEDIUM,
	BIG
}

@onready var sprite := $Sprite2D
@onready var collision_shape := $CollisionShape2D

@export var size : SIZE = SIZE.BIG:
	set(value):
		if value != size:
			size = value
			size_changed.emit()

@export var asteroid_properties_array : Array[AsteroidProperties]
var speed : float
var torque : float #torque = force de rotation sur sois même.

signal size_changed
signal destroyed

func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process(false)
		
	size_changed.connect(update_asteroid_properties)
	update_asteroid_properties()


func _physics_process(delta: float) -> void:
	var velocity = speed * direction * delta
	global_position += velocity
	rotation_degrees += torque * delta


func update_asteroid_properties() -> void:
	assert(size in range(asteroid_properties_array.size()), "the given size " + str(size) + " value isn't a valid asteroid properties index")
	var asteroid_properties = asteroid_properties_array[size]
	
	sprite.texture = asteroid_properties.texture
	collision_shape.shape = asteroid_properties.shape
	speed = asteroid_properties.speed
	torque = asteroid_properties.torque


func destroy() -> void:
	destroyed.emit()
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.destroy()

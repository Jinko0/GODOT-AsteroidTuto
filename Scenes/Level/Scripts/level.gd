extends Node2D
class_name Level

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
var screen_size := Vector2(screen_width, screen_height)

@onready var asteroids_container = %Asteroids
@onready var border_rect = %BorderRect

@export var asteroid_scene : PackedScene
@export var spawn_circle_radius : float = 350.0
@export var asteroid_direction_variance : float = 25.0

func spawn_asteroid() -> void:
	# Pour les explications détaillées de la logique du spawn des asteroids voir la vidéo de BabaDesBois "Votre premier jeu avec Godot 4! - Partie 3"
	var screen_center = screen_size / 2.0
	
	# On prend un angle aléatoire entre 0 et 360 degrés et on le convertit en radians
	var angle = deg_to_rad(randf_range(0.0, 360.0))
	
	# On créer un vecteur qui pointe vers l'angle précdemment déterminé
	var dir_to_point = Vector2.RIGHT.rotated(angle) 
	
	# En partant du centre de l'écran et dans la direction du vecteur précedemment déterminé, on prend un point sur un cercle en dehors de l'écran
	var point = screen_center + dir_to_point * spawn_circle_radius
	
	# On détermine le point le plus en haut à gauche où pourra spawn un asteroid. Pareil pour le point en bas à droite.
	# On clamp le point qu'on avait determiné sur un cercle qui entoure l'écran pour le placer au plus proche sur le rectangle qui entoure l'écran
	var top_left = border_rect.global_position
	var bottom_right = border_rect.global_position + border_rect.size
	point = point.clamp(top_left, bottom_right)
	
	# On instancie l'asteroid et on l'ajoute à la scene
	var asteroid = asteroid_scene.instantiate()
	asteroids_container.add_child(asteroid)
	
	# On détermine un vecteur qui part de l'asteroid et qui pointe vers le centre de l'écran
	var dir_to_center = point.direction_to(screen_center)
	
	# On ajoute un peu de variance dans la direction de l'asteroid
	var dir_rotation = randfn(0.0, deg_to_rad(asteroid_direction_variance)) #randfn pour une distribution normalisée
	asteroid.direction = dir_to_center.rotated(dir_rotation)
	
	# On place l'asteroid sur le point précedemment déterminé autour de l'écran
	asteroid.position = point

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		spawn_asteroid()

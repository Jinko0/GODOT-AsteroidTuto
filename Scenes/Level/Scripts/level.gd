extends Node2D
class_name Level

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
var screen_size := Vector2(screen_width, screen_height)

@onready var asteroids_container = %Asteroids
@onready var border_rect = %BorderRect
@onready var gameover = %Gameover

@export var asteroid_scene : PackedScene
@export var spawn_circle_radius : float = 350.0
@export var asteroid_direction_variance : float = 45.0


func spawn_asteroid_on_border() -> void:
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
	
	
	# On détermine un vecteur qui part de l'asteroid et qui pointe vers le centre de l'écran
	var dir_to_center = point.direction_to(screen_center)
	
	# On ajoute un peu de variance dans la direction de l'asteroid
	var dir_rotation = randfn(0.0, deg_to_rad(asteroid_direction_variance)) #randfn pour une distribution normalisée
	var asteroid_dir = dir_to_center.rotated(dir_rotation)
	
	# On determine une taille d'asteroid aléatoire à partir de l'enum présente dans la classe Asteroid
	var asteroid_size = randi_range(0, Asteroid.SIZE.size() - 1)
	
	spawn_asteroid(point, asteroid_dir, asteroid_size)


func spawn_asteroid(pos: Vector2, dir : Vector2, size: Asteroid.SIZE) -> void:
	# On instancie l'asteroid et on l'ajoute à la scene
	var asteroid = asteroid_scene.instantiate()
	asteroids_container.add_child.call_deferred(asteroid)
	
	asteroid.direction = dir
	asteroid.position = pos
	asteroid.size = size
	
	# On connect la fonction _on_asteroid_destroyed au signal "destroyed" de l'asteroid, en ajoutant la référence de l'asteroid qui a émit le signal grâce au bind
	asteroid.destroyed.connect(_on_asteroid_destroyed.bind(asteroid))


func _on_asteroid_destroyed(asteroid: Asteroid) -> void:
	if asteroid.size > 0:
		var nb_spawn = randi_range(2,3)
		
		for i in range(nb_spawn):
			var rot_deg = 90.0 + randfn(0.0, asteroid_direction_variance)
			var rnd_sign = [-1, 1].pick_random()
			var rot = deg_to_rad(rot_deg * rnd_sign)
			
			var dir = asteroid.direction.rotated(rot)
			
			spawn_asteroid(asteroid.global_position, dir, asteroid.size - 1)


func _on_spawn_timer_timeout():
	spawn_asteroid_on_border()


func _on_retry_button_pressed():
	get_tree().reload_current_scene()


func _on_player_destroyed():
	gameover.set_visible(true)

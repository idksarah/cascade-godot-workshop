extends Node2D

var obstacle = preload("res://obstacle.tscn")

const player_start_pos := Vector2i(150, 485)
const camera_start_pos := Vector2i(193, 324)
const ground_start_pos := Vector2(9, 618)

var speed : float
const start_speed : float  = 12.0
const max_speed : float = 25
const speed_modifier : float = 50

var screen_size : Vector2i
var ground_height : int

var score : float

var game_running = false
var last_obs_position : Vector2i
var start = true
var should_restart = false

func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	create_obstacles()
	
func new_game():
	score = 0
	$Player.position = player_start_pos
	$Player.velocity = start_speed
	$Player.position = camera_start_pos
	$Ground.position = ground_start_pos
	
func _process(delta):
	if game_running:
		speed = start_speed + score / speed_modifier
		if speed > max_speed:
			speed = max_speed
		
		score+= .5
		show_score()
	
		$Player.position.x += speed
		$Camera2D.position.x += speed

		if $Camera2D.position.x - $Ground.position.x > screen_size.x:
			$Ground.position.x += screen_size.x
		
		create_obstacles()
		print(should_restart)
		if should_restart:
			restart()
	else:
		if Input.is_action_just_pressed("Jump"):
			game_running = true
			$HUD.get_node("Start").queue_free()
			
func show_score():
	$HUD.get_node("Score").text = "SCORE: " + str(round(score))
	
func create_obstacles():
	if start or last_obs_position.x < $Player.position.x  + randi_range(100, 200):
		start = false
		var obs = obstacle.instantiate()
		
		var obs_x = $Player.position.x + randi_range(600, 2000)
		
		# Get the obstacle's height and scale to p	osition it correctly
		var obs_height = obs.get_node("Sprite2D").texture.get_height()
		var obs_scale = obs.get_node("Sprite2D").scale
		var obs_y = screen_size.y - (obs_height * obs_scale.y / 2) - 20
		
		# Call function to add the obstacle to the scene
		add_obstacles(obs, obs_x, obs_y)

func add_obstacles(obs, x, y):
	obs.position = Vector2i(x, y)
	add_child(obs)
	obs.body_entered.connect(restart)
	last_obs_position = obs.position  # Update last obstacle position
	
func restart():
	score = 0
	$Player.position = player_start_pos
	$Camera2D.position = camera_start_pos
	$Player.velocity = Vector2i(0,0)
	$Ground.position = ground_start_pos
	should_restart = false
	#$Player.velocity = start_speed

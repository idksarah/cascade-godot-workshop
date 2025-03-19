extends CharacterBody2D

var gravity = 4200
var jump_speed : int =  -1500

func _physics_process(delta):
	velocity.y += gravity * delta
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = jump_speed
	move_and_slide()

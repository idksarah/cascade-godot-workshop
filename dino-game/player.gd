extends CharacterBody2D

var gravity = 600
var jump_weight = 400

func _physics_process(delta):
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y -= jump_weight
	velocity.y += gravity * delta
	move_and_slide()

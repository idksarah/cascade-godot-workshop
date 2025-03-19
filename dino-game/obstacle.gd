extends Area2D

@onready var main = $"../"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		main.should_restart = true	

extends Node2D

@export var player : Player

func _process(_delta) -> void:
	if (player.currentItem != null and player.currentItem.has_method("shoot")) and Input.is_action_just_pressed("shoot"):
		player.currentItem.shoot(get_global_mouse_position())

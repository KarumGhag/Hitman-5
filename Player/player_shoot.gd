extends Node2D

@export var player : Player

func _process(_delta) -> void:

	if (player.currentItem != null and player.currentItem.has_method("shoot")):
		if player.currentItem is GunClass and player.currentItem.auto and Input.is_action_pressed("shoot"):
			player.currentItem.shoot(get_global_mouse_position(), true)
		elif (player.currentItem is GunClass and (not player.currentItem.auto)) and Input.is_action_just_pressed("shoot"):
			player.currentItem.shoot(get_global_mouse_position(), true)

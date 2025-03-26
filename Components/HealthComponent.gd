
extends Node

class_name HealthComponent

@export var parent : Node2D
@export var maxHealth : float
var currentHealth : float = maxHealth

func _ready() -> void:
	currentHealth = maxHealth

	if parent == null:
		print_debug("No parent")

	if maxHealth == 0 or maxHealth == null:
		print_debug("No max health")

func damage(dmg : float) -> void:
	
	currentHealth -= dmg
	
	if currentHealth < 0:
		if parent.has_method("die"):
			parent.die()
			return

		die()

func die() -> void:
	parent.queue_free()

extends Area2D

class_name HitboxComponent

@export var healthComponent : HealthComponent
@export var parent : Node2D

@export var takeKB : bool = true

func damage(attack : Attack) -> void:
	if healthComponent != null:
		healthComponent.damage(attack.damage)
	
	if takeKB:
		parent.velocity -= (global_position - attack.attackPos).normalized() * attack.knockback
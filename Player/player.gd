extends CharacterBody2D

class_name Player

@export_subgroup("Stats")
@export var speed : float = 600
@export var accel : float = 20
var direction : Vector2
var steering : Vector2
var mass : float = 3


@export_subgroup("Visuals")
@export var animator : AnimationPlayer


func _process(_delta) -> void:

	direction = Input.get_vector("left", "right", "up", "down")

	direction = direction.normalized() * speed

	steering = (direction - velocity) / mass

	velocity += steering * accel

	if direction:
		animator.play("Walk")
	else:
		animator.play("Idle")


	move_and_slide()

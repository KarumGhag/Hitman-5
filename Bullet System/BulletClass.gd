extends CharacterBody2D

class_name BulletClass

#for destroying
var fireDist : float
var originPoint : Vector2
var distTravelled : float

#stats
var damage : float
var speed : float
var direction : Vector2
var knockback : float

@export var hitbox : Area2D


func _ready() -> void:
	originPoint = global_position
	hitbox.connect("body_entered", hitboxBody)
	hitbox.connect("area_entered", hitboxArea)
	
	velocity = speed * direction



#if it collides with a body then it will either be a bullet so it should carry on or it should be destroyed
func hitboxBody(body) -> void:
	var tempVel : Vector2 = velocity
	velocity = Vector2.ZERO

	if body is BulletClass:
		velocity = tempVel
		return
	
	queue_free()

func hitboxArea(area) -> void:
	if area is HitboxComponent:

		var attack : Attack = Attack.new()

		attack.damage = damage
		attack.knockback = knockback
		attack.attackPos = global_position

		area.damage(attack)
		

		queue_free()



func _process(_delta) -> void:
	distTravelled = global_position.distance_to(originPoint)

	if (fireDist != 0) and distTravelled >= fireDist:
		queue_free()


	move_and_slide()

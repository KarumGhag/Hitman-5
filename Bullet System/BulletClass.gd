extends CharacterBody2D

class_name BulletClass

var fireDist : float
var orignPoint : Vector2
var distTravelled : float

var damage : float
var speed : float
var direction : Vector2

@export var hitbox : Area2D

#if it collides with a body then it will either be a bullet so it should carry on or it should be destroyed
func hitboxBody(body) -> void:
    var tempVel : Vector2 = velocity
    velocity = Vector2.ZERO

    if body is BulletClass:
        velocity = tempVel
        return
    
    queue_free()

func hitboxArea(area) -> void:
    pass
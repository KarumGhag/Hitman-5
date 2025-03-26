extends Item

class_name GunClass

@export_group("Nodes")
@export var bullet : PackedScene
@export var shootPoint : Node2D
@export var animationPlayer : AnimationPlayer
@export var shootVectorPoint : Node2D

@export_group("Stats")

@export var damage : float
@export var bulletSpeed : float = 1000
@export var knockback : float

#basic gun stats
@export var auto : bool
@export var shotgun : bool

## Time between each shot
@export var fireCoolDown : float = 0.1
var fireCoolDownTimer : Timer
## How far the bullet goes before despawning
## If 0 it is until it hits a wall
@export var fireDistance : float
## How much the bullets can spread away from the mouse
@export var spread : float
## Amount of bullet shot per click
## Must be at least 1
@export var multiBulletNum : int = 1
## Only use if above is above 1
## After a bullet is shot it waits this much time for the next bullet to be shot
@export var multiBulletWait : float = 0.05


@export_subgroup("reload")
## max bullets
@export var magSize : int = 16
var bulletsLeft : int
@export var reloadTime : float = 2
var reloadTimer : Timer
var isReloading : bool = false


var canShoot : bool = true
var target : Vector2



@export_subgroup("Camera")
@export var shakeAmount : float = 5


func itemReady() -> void:
	bulletsLeft = magSize
	

	#makes a timer that will let you shoot again after its up
	fireCoolDownTimer = Timer.new()
	fireCoolDownTimer.one_shot = true
	fireCoolDownTimer.autostart = false

	fireCoolDownTimer.connect("timeout", canShootAgain)

	add_child(fireCoolDownTimer)


func canShootAgain() -> void:
	canShoot = true


func shootLocation(callerTarget) -> Vector2:
	var innacuracy = randf_range(-spread, spread)
	target = Vector2.from_angle(shootVectorPoint.global_position.angle_to_point(callerTarget) + innacuracy)

	return target.normalized()


#caller target needed so that the player can pass in mouse position and enemy can pass in the player, manage the enemy target setting from them and let the spread apply here
func shoot(callerTarget : Vector2) -> void:

	if bulletsLeft <= 0:
		reload()
		return

	if not canShoot:
		
		return
	


	canShoot = false

	for i in range(multiBulletNum):
			if bulletsLeft <= 0:
				reload()
				break


			if animationPlayer != null:
				animationPlayer.play("Pump")




			var bulletDirection : Vector2 = shootLocation(callerTarget)
			var bulletInstance = bullet.instantiate()
			bulletInstance.global_position = shootPoint.global_position
			bulletInstance.direction = bulletDirection

			bulletInstance.look_at(get_global_mouse_position())

			bulletInstance.fireDist = fireDistance
			bulletInstance.damage = damage
			bulletInstance.speed = bulletSpeed
			bulletInstance.knockback = knockback



			get_tree().get_root().add_child(bulletInstance)

			camera.shakeCam(shakeAmount)
			bulletsLeft -= 1


			if shotgun or multiBulletWait == 0:
				continue
			
			if multiBulletNum == 1:
				break

			await wait(multiBulletWait)


	fireCoolDownTimer.start(fireCoolDown)



func wait(seconds : float) -> void:
	await get_tree().create_timer(seconds).timeout

func reload() -> void:
	if isReloading:
		return
	
	isReloading = true

	await wait(reloadTime)
	bulletsLeft = magSize
	print("reload, now have: " + str(bulletsLeft) + " bullets")

	isReloading = false

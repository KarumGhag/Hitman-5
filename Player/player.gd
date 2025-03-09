extends CharacterBody2D

class_name Player

var mousePosition : Vector2

@export_subgroup("Stats")
@export var speed : float = 600
@export var accel : float = 20
var direction : Vector2
var steering : Vector2
@export var mass : float = 3


@export_subgroup("Visuals")
@export var animator : AnimationPlayer
@export var otherAnimator : AnimationPlayer

@export_subgroup("Bones")
@export var skeleton : Skeleton2D
@export var rightArm : Bone2D
@export var leftArm : Bone2D

#Getting direction to face
var facing : Array[String] = ["Right", "Left", "Up", "Down", "BotRight", "BotLeft", "TopRight", "TopLeft"]

var currentFacing : String
var directionVectors : Array[Vector2] = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN, Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]
var dotProducts : Array[float] = [0, 0, 0, 0, 0, 0, 0, 0]
var biggestDotIndex : int
var directionToMouse : Vector2


@export_subgroup("Debug")
@export var debugText : Label

func _ready() -> void:
	for i in range(len(directionVectors)):
		directionVectors[i] = directionVectors[i].normalized()

func _process(_delta) -> void:

	mousePosition = get_global_mouse_position()

	direction = Input.get_vector("left", "right", "up", "down")

	direction = direction.normalized() * speed

	steering = (direction - velocity) / mass

	velocity += steering * accel


	rightArm.look_at(get_global_mouse_position())

	if direction:
		animator.play("Walk")
		otherAnimator.play("FrontWalk")
		
	else:
		animator.play("Idle")
		otherAnimator.play("Idle")
	

	if get_global_mouse_position().x < global_position.x:
		skeleton.scale.x = -1
	else:
		skeleton.scale.x = 1


	directionToMouse = (global_position.direction_to(mousePosition)).normalized()
	for i in range(len(dotProducts)):
		dotProducts[i] = directionToMouse.dot(directionVectors[i])
	
	biggestDotIndex = getLargest(dotProducts)

	currentFacing = facing[biggestDotIndex]

	debugText.text = "To Mouse: " + str(directionToMouse) + "\nLargest dot: " + str(biggestDotIndex) + "\nDots: " + str(dotProducts) + "\nDirection: " + str(currentFacing)





	move_and_slide()

func getLargest(arr : Array[float]) -> int:
	var highest : float = -1
	var index : int = -1

	for i in range(len(arr)):
		if arr[i] > highest:
			highest = arr[i]
			index = i
	

	return index
extends Node2D

class_name PlayerAnimation

@export var enabled : bool

@export var player : Player
@export var debugText : Label

@export var headSprite : Sprite2D
@export var bodySprite : Sprite2D
@export var bodyAnimator : AnimationPlayer
@export var headAnimator : AnimationPlayer

var direction

var directionToMouse : Vector2
var mousePosition : Vector2

#Getting direction to face
var facing : Array[String] = ["Right", "Left", "Up", "Down", "BotRight", "BotLeft", "TopRight", "TopLeft"]

var currentFacingInt : int
var currentFacing : String
var directionVectors : Array[Vector2] = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN, Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]
var dotProducts : Array[float] = [0, 0, 0, 0, 0, 0, 0, 0]
var biggestDotIndex : int

func _ready() -> void:
	

	for i in range(len(directionVectors)):
		directionVectors[i] = directionVectors[i].normalized()

func _process(_delta) -> void:
	if not enabled:
		return

	direction = player.direction
	
	mousePosition = get_global_mouse_position()
	directionToMouse = (player.global_position.direction_to(mousePosition)).normalized()

	for i in range(len(dotProducts)):
		dotProducts[i] = directionToMouse.dot(directionVectors[i])
	
	biggestDotIndex = getLargest(dotProducts)

	currentFacing = facing[biggestDotIndex]
	currentFacingInt = biggestDotIndex

	if direction:
		bodyAnimator.play("Walk")
	else:
		bodyAnimator.play("Idle")

	#if they arent facing up or down the head looks to the side
	if currentFacingInt == 2 or currentFacingInt == 3:
		headAnimator.play("Front")
	else:
		headAnimator.play("Side")
	
	#this means they are facing left
	if currentFacingInt == 1 or currentFacingInt == 7 or currentFacingInt == 5:
		headSprite.flip_h = true
		bodySprite.flip_h = true
	else:
		headSprite.flip_h = false
		bodySprite.flip_h = false
	
	debugText.text = "To Mouse: " + str(directionToMouse) + "\nLargest dot: " + str(biggestDotIndex) + "\nDots: " + str(dotProducts) + "\nDirection: " + str(currentFacing)

func getLargest(arr : Array[float]) -> int:
	var highest : float = -1
	var index : int = -1

	for i in range(len(arr)):
		if arr[i] > highest:
			highest = arr[i]
			index = i

	return index

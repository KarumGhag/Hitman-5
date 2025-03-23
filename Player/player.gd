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
@export var bodyAnimator : AnimationPlayer
@export var headAnimator : AnimationPlayer
@export var bodySprite : Sprite2D
@export var headSprite : Sprite2D


@export_subgroup("Inventory")
@export var holdFlipper : Node2D
@export var holdNode : Node2D
var holdPos : Vector2
@export var inventory : PlayerInv
var currentItem : Item

#Getting direction to face
var facing : Array[String] = ["Right", "Left", "Up", "Down", "BotRight", "BotLeft", "TopRight", "TopLeft"]

var currentFacingInt : int
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
	holdPos = holdNode.global_position	
	currentItem = inventory.currentItem


	mousePosition = get_global_mouse_position()

	direction = Input.get_vector("left", "right", "up", "down")

	direction = direction.normalized() * speed

	steering = (direction - velocity) / mass

	velocity += steering * accel

	
	print(currentItem)
	

	directionToMouse = (global_position.direction_to(mousePosition)).normalized()
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
		if currentItem != null:
			currentItem.itemSprite.flip_h = true
		holdFlipper.rotation_degrees = 180
	else:
		headSprite.flip_h = false
		bodySprite.flip_h = false
		if currentItem != null:
			currentItem.itemSprite.flip_h = false
		holdFlipper.rotation_degrees = 0

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

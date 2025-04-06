extends CharacterBody2D

class_name Player

var mousePosition : Vector2

@export_subgroup("Stats")
@export var speed : float = 600
@export var accel : float = 20
var direction : Vector2
var steering : Vector2
@export var mass : float = 3

@export_subgroup("Inventory")
@export var uiPos : Node2D
@export var holdNode : Node2D
var holdPos : Vector2
@onready var inventory = get_node("/root/playerInventory")
var currentItem : Item

#Getting direction to face
var facing : Array[String] = ["Right", "Left", "Up", "Down", "BotRight", "BotLeft", "TopRight", "TopLeft"]

var currentFacingInt : int
var currentFacing : String
var directionVectors : Array[Vector2] = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN, Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]
var dotProducts : Array[float] = [0, 0, 0, 0, 0, 0, 0, 0]
var biggestDotIndex : int
var directionToMouse : Vector2

@export_subgroup("Holders")
@export var rightHold : Node2D
@export var leftHold : Node2D
@export var holder : Node2D

@export_subgroup("Animations")
@export var animator : Node2D



@export_subgroup("Debug")
@export var debugText : Label

func _ready() -> void:
	pass

func _process(_delta) -> void:
	currentItem = inventory.currentItem


	mousePosition = get_global_mouse_position()

	direction = Input.get_vector("left", "right", "up", "down")

	direction = direction.normalized() * speed

	steering = (direction - velocity) / mass

	velocity += steering * accel

	

	move_and_slide()







func getLargest(arr : Array[float]) -> int:
	var highest : float = -1
	var index : int = -1

	for i in range(len(arr)):
		if arr[i] > highest:
			highest = arr[i]
			index = i

	return index

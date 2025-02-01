extends Node

class_name Item

@export var itemName : String

@export var pickUpArea : Area2D
@export var pickUpBox : Area2D
var canPickUp : bool = false
var mouseTouching : bool
var mousePos : Vector2

func _ready() -> void:
	pickUpBox.connect("mouse_entered", mouseEnter)
	pickUpBox.connect("mouse_exited", mouseExit)


func _process(delta) -> void:
	pass

func mouseEnter() -> void:
	canPickUp = true

func mouseExit() -> void:
	canPickUp = false

func itemReady() -> void:
	pass

func itemProcess(delta) -> void:
	pass
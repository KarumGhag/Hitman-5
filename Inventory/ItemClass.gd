extends Node2D

class_name Item

@export_subgroup("Item")
@export var itemName : String

@export var pickUpArea : Area2D	## How close you have to be to pick up an item
@export var pickUpBox : Area2D	## The area you have to click on to pick up the item
var canPickUp : bool = false
var mouseTouching : bool
var mousePos : Vector2
var equipped : bool = false
var inInv : bool = false

func _ready() -> void:
	pickUpBox.connect("mouse_entered", mouseEnter)
	pickUpBox.connect("mouse_exited", mouseExit)


func _process(delta) -> void:
	if equipped:
		itemProcess(delta)
		show()
	elif inInv and not equipped:
		hide()
	else:
		show()


		
func mouseEnter() -> void:
	canPickUp = true

func mouseExit() -> void:
	canPickUp = false

func itemReady() -> void:
	pass

func itemProcess(delta) -> void:
	pass
extends Node2D

class_name Item

@export_subgroup("Item")
@export var itemName : String
@export var itemSprite : Sprite2D
@export var pickUpArea : Area2D	## How close you have to be to pick up an item
@export var pickUpBox : Area2D	## The area you have to click on to pick up the item
var canPickUp : bool = false
var mouseTouching : bool
var mousePos : Vector2
var equipped : bool = false
var inInv : bool = false

var player : Player
var inv : PlayerInv

var camera : Camera2D

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")

	pickUpBox.connect("mouse_entered", mouseEnter)
	pickUpBox.connect("mouse_exited", mouseExit)

	player = get_tree().get_first_node_in_group("Player")
	if player != null:
		inv = player.inventory

	itemReady()

func _process(delta) -> void:
	if equipped:
		itemProcess(delta)
		show()
	elif inInv and not equipped:
		hide()
	else:
		show()


	if Input.is_action_just_pressed("pickup"):
		pickup()

func pickup() -> void:
	if not canPickUp or inInv:
		return
	

	for i in range(len(inv.inv)):
		if inv.inv[i] == null:
			inv.inv[i] = self
			inInv = true

			inv.currentItem = inv.inv[i]
			equipped = true

			

			return


		
func mouseEnter() -> void:
	canPickUp = true

func mouseExit() -> void:
	canPickUp = false

func itemReady() -> void:
	pass

func itemProcess(delta) -> void:
	pass
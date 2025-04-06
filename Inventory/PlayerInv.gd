extends Node2D

class_name PlayerInv

var inv : Array[Item] = [null]
var invSize : int = 10
var currentItem : Item

var camera : Camera2D

var player : Player

var holstered : bool = false
var lastEquipedItem : int
var tempItem : Item

#for setting items position when dropping
var currentHoldPos : Vector2

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")
	player = get_tree().get_first_node_in_group("Player")

	inv.resize(invSize)
	for i in range(len(inv)):
		if inv[i] != null:
			currentItem = inv[i]
			break


	uiReady()


func _process(_delta) -> void:

	uiProcess()

	for i in range(len(inv)):
		if inv[i] != null and currentHoldPos != null:
				inv[i].global_position = currentHoldPos
			
		


	if Input.is_action_just_pressed("nextItem") and not holstered and currentItem != null:
		currentItem.equipped = false
		currentItem = inv[getNext(getCurrent())]
		currentItem.equipped = true
		uiUpdate()
	if Input.is_action_just_pressed("prevItem") and not holstered and currentItem != null:
		currentItem.equipped = false
		currentItem = inv[getPrev(getCurrent())]
		currentItem.equipped = true
		uiUpdate()

	if Input.is_action_just_pressed("drop") and currentItem != null:
		currentItem.drop()
		uiUpdate()


#if holstered a temp item is set to the next or prev and then the last equipped item is changed and the current item is re holstered
	if Input.is_action_just_pressed("nextItem") and holstered:
		tempItem = inv[getNext(getCurrent(tempItem))] #temp item is used so it can search for a specific item
		lastEquipedItem = getCurrent(tempItem) #updates what the item should be when un holstered
		uiUpdate()


	if Input.is_action_just_pressed("prevItem") and holstered:
		tempItem = inv[getPrev(getCurrent(tempItem))]
		lastEquipedItem = getCurrent(tempItem)
		uiUpdate()


	if Input.is_action_just_pressed("holster") and not isEmpty():
		if not holstered:
			lastEquipedItem = getCurrent()
			currentItem.equipped = false
			currentItem = null
		else:
			currentItem = inv[lastEquipedItem]
			currentItem.equipped = true

		holstered = not holstered #toggles the value
		uiUpdate()



	if currentItem != null:
		
		#if the mouse is behind the player then the sprite has to flip and move to the location of the left hand
		if get_global_mouse_position().x < player.global_position.x:
			currentItem.global_position = player.leftHold.global_position
			currentItem.itemSprite.flip_v = true
		else:
			currentItem.global_position = player.rightHold.global_position
			currentItem.itemSprite.flip_v = false
		
		#breaks if you try to look at and then change global position
		currentHoldPos = currentItem.global_position

		currentItem.look_at(get_global_mouse_position())
 
func getNext(currentPos) -> int:

	#means that there is nothing in the inventory
	if currentPos == -1:
		return -1

	
	while true:
		#if the next item location is the lenght of the inventory it has to loop back to the start
		if currentPos + 1 == len(inv):
			currentPos = 0
			#this means that item 0 is not null so its the next item
			if inv[currentPos] != null:
				break
		
		#adds 1 to the next item
		currentPos += 1

		#if the next item is not null then its the next item
		if inv[currentPos] != null:
			break


	return currentPos



#same as above but takes away instead of adding it takes away
func getPrev(currentPos) -> int:

	if currentPos == -1:
		return -1

	while true:

		if currentPos - 1 < 0:
			currentPos = len(inv) - 1
			if inv[currentPos] != null:
				break
		
		currentPos -= 1

		if inv[currentPos] != null:
			break

	
	return currentPos



func getCurrent(toFind : Item = null) -> int:

	#if the item is holstered then it searches for to find which is set to the last item before anything was holstered
	if toFind != null:
		for j in range(len(inv)):
			if inv[j] == toFind:
				return j

	#other wise it will search for the current item because nothing specified is being searched for
	for j in range(len(inv)):
		if inv[j] == currentItem and currentItem != null:
			return j

	for i in range(len(inv)):
		if inv[i] != null:
			return i
	
	return -1

#checks if the inventory is empty
func isEmpty() -> bool:
	for i in range(len(inv)):
		if inv[i] != null:
			return false
		
	return true


#inventory ui
@export_subgroup("UI")
var open : bool
@export var itemRepresent : Array[Sprite2D]
@export var itemButtons : Array[Button]
@export var ui : Control
var chosenPos : int


@export var currentRep : Sprite2D
@export var nextRep : Sprite2D
@export var prevRep : Sprite2D


func uiReady() -> void:
	open = false
	uiUpdate()


func uiProcess() -> void:

	if Input.is_action_just_pressed("pickup") or Input.is_action_just_pressed("drop") or Input.is_action_just_pressed("inventory") or Input.is_action_just_pressed("nextItem") or Input.is_action_just_pressed("prevItem"):
		uiUpdate()

	#swaps the open value and sets the visibility to the open
	if Input.is_action_just_pressed("inventory"):
		open = !open
		ui.visible = open


func uiUpdate() -> void:
	if not open:
		ui.visible = false

	#if the inventory is empty then it should set the sprites to nothing
	if isEmpty():
		currentRep.texture = null
		nextRep.texture = null
		prevRep.texture = null

	if currentItem == null:
		return
	

	currentRep.texture = currentItem.itemPNG.texture
	currentRep.scale = currentItem.itemPNG.scale * 2

	if getNext(getCurrent()) != getCurrent():
		nextRep.texture = inv[getNext(getCurrent())].itemPNG.texture 
		nextRep.scale = inv[getNext(getCurrent())].itemPNG.scale

	if getPrev(getCurrent()) != getCurrent() and getPrev(getCurrent()) != getNext(getCurrent()):
		prevRep.texture = inv[getNext(getCurrent())].itemPNG.texture
		prevRep.scale = inv[getNext(getCurrent())].itemPNG.scale

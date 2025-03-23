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


func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")
	player = get_tree().get_first_node_in_group("Player")

	inv.resize(invSize)
	for i in range(len(inv)):
		if inv[i] != null:
			currentItem = inv[i]
			break





func _process(_delta) -> void:
	for i in range(len(inv)):
		if inv[i] != null:
			inv[i].global_position = player.holdPos


	if Input.is_action_just_pressed("nextItem") and not holstered:
		currentItem = inv[getNext(getCurrent())]
	if Input.is_action_just_pressed("prevItem") and not holstered:
		currentItem = inv[getPrev(getCurrent())]



#if holstered a temp item is set to the next or prev and then the last equipped item is changed and the current item is re holstered
	if Input.is_action_just_pressed("nextItem") and holstered:
		tempItem = inv[getNext(getCurrent(tempItem))]
		lastEquipedItem = getCurrent(tempItem)


	if Input.is_action_just_pressed("prevItem") and holstered:
		tempItem = inv[getPrev(getCurrent(tempItem))]
		lastEquipedItem = getCurrent(tempItem)


	if Input.is_action_just_pressed("holster") and not isEmpty():
		if not holstered:
			lastEquipedItem = getCurrent()
			currentItem.equipped = false
			currentItem = null
		else:
			currentItem = inv[lastEquipedItem]
			currentItem.equipped = true

		holstered = not holstered #toggles the value


func getNext(currentPos) -> int:

	if currentPos == -1:
		return -1

	while true:

		if currentPos + 1 == len(inv):
			currentPos = 0
			if inv[currentPos] != null:
				break
		
		currentPos += 1

		if inv[currentPos] != null:
			break


	return currentPos



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

	if toFind != null:
		for j in range(len(inv)):
			if inv[j] == toFind:
				return j

	for j in range(len(inv)):
		if inv[j] == currentItem and currentItem != null:
			return j

	for i in range(len(inv)):
		if inv[i] != null:
			return i
	
	return -1


func isEmpty() -> bool:
	for i in range(len(inv)):
		if inv[i] != null:
			return false
		
	return true

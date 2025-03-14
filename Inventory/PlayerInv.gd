extends Node2D

class_name PlayerInv

var inv : Array[Item] = [null]
var invSize : int = 10
var currentItem : Item

var camera : Camera2D

var player : Player

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


    if Input.is_action_just_pressed("nextItem"):
        getNext()

func getNext() -> int:
    var currentPos : int = getCurrent()

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



func getPrev() -> int:
    var currentPos : int = getCurrent()

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



func getCurrent() -> int:
    for i in range(len(inv)):
        if inv[i] != null:
            return i
    
    return -1
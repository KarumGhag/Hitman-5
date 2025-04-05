extends Camera2D

class_name Camera

@export_subgroup("Camera")
@export var heldLean : float = 0.1
@export var unheldLean : float = 0.06


@export var leanSmoothness : float = 30
@export var player : Player


var mousePos : Vector2
var directionToMouse : Vector2
var distanceToMouse : float

var lean : Vector2

@export var offsetLabel : Label


#dear future me who will eventually have this same problem
#the fix is to use this exact code and do NOT make the camera a child of the player
#instead put it into the world and set the global positon equal to the player's global position

@export var active : bool = true

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(delta):
	mousePos = get_global_mouse_position()

	directionToMouse = (mousePos - position).normalized()
	distanceToMouse = mousePos.distance_to(position)

	#camera leans more when holding an item
	if active:
		if player.currentItem != null:
			lean = directionToMouse * distanceToMouse * heldLean
		else:
			lean = directionToMouse * distanceToMouse * unheldLean

	
	#lean = directionToMouse * distanceToMouse * unheldLean

	offset = lerp(offset, lean, delta * leanSmoothness)

	global_position = player.global_position

	

func shakeCam(shakeAmount) -> void:
	var rng = RandomNumberGenerator.new()
	
	var shake : Vector2 = Vector2(rng.randf_range(-shakeAmount, shakeAmount), rng.randf_range(-shakeAmount, shakeAmount))
	offset += shake

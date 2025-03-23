extends Node2D

var facing : Array[String] = ["Right", "Left", "Up", "Down", "BotRight", "BotLeft", "TopRight", "TopLeft"]

var currentFacingInt : int
var currentFacing : String
var directionVectors : Array[Vector2] = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN, Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]
var dotProducts : Array[float] = [0, 0, 0, 0, 0, 0, 0, 0]
var biggestDotIndex : int
var directionToMouse : Vector2



func _process(delta):
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
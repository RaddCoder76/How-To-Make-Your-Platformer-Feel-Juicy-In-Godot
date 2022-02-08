extends KinematicBody2D

var ghostScene = preload("res://Scenes/Ghost/Ghost.tscn").instance()

#players velocity
var velocity = Vector2()
#forces acted on the player
export var moveSpeed = 700
export var gravity = 20
export var jumpForce = 1500
#varibles to increase the min jumpheight and accleration/decceleration
export var minJump  = 1000
export (float, 0, 1) var moveAcceleration = .05
export (float, 0, 1) var moveDecceleration = .05

var canJump = false

export (float, 0, 1) var coyoteTime = 0.1
export var jumpBuffering = .2
var hasPressedJump = false


#runs every frame, mainly used for applying forces on player
func _physics_process(delta):
	
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

#runs every frame as well, used for checking inputs
func _process(delta):
	_checksIfPlayerOnFloor()
	_checkPlayerMovements()
	_checkJump()
	

#checks in the jump button is pressed and if its let go
func _checkJump():
	#checks if the player has pressed jump, if they did and the jump buffering timer has not started yet, start it.
	if Input.is_action_just_pressed("Jump") and hasPressedJump == false:
		_spawnGhost()
		hasPressedJump = true
		yield(get_tree().create_timer(jumpBuffering), "timeout")
		hasPressedJump = false
	
	#if is on ground and has pressed jump in the last ___ amount of seconds, jump
	if hasPressedJump and canJump:
		
		velocity.y = -jumpForce
		canJump = false
	#jump variation
	if Input.is_action_just_released("Jump") and velocity.y < -minJump:
		velocity.y = -minJump

#checks the players left and right inputs for movement
func _checkPlayerMovements():
	var xDir = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	
	if xDir != 0:
		velocity.x = lerp(velocity.x, xDir * moveSpeed, moveAcceleration)
	elif xDir == 0 and !is_on_floor():
		velocity.x = lerp(velocity.x, 0, moveDecceleration/2)
	else:
		velocity.x = lerp(velocity.x, 0, moveDecceleration)

#checks if player is on floor and controls coyote timer
func _checksIfPlayerOnFloor():
	if is_on_floor():
		canJump = true
	else:
		if canJump == true:
			#velocity.y = 0
			yield(get_tree().create_timer(coyoteTime), "timeout")
			canJump = false
	pass




var firstJump = false
func _spawnGhost():
	
	ghostScene.global_position = global_position
	if firstJump == false:
		get_tree().current_scene.add_child(ghostScene)
	firstJump = true

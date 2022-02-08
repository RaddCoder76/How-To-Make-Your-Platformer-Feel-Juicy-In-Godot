extends KinematicBody2D

var ghostScene = preload("res://Scenes/Ghost/Ghost.tscn").instance()

var velocity = Vector2()

export var moveSpeed = 10
export var gravity = 20
export var jumpForce = 1500


func _physics_process(delta):
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _process(delta):
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		_spawnGhost()
		velocity.y = -jumpForce
	
	var xDir = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	
	if xDir != 0:
		velocity.x = moveSpeed * xDir
	else:
		velocity.x = 0
		
func _spawnGhost():
	ghostScene.global_position = global_position
	get_tree().current_scene.add_child(ghostScene)

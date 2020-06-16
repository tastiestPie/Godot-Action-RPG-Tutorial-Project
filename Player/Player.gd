extends KinematicBody2D

const ACCELERATION = 10
const MAX_SPEED = 100
const FRICTION = 10

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	#This method accounts for the strength of both of the buttons pressed.
	#If only one button is pressed, the player will move that direction
	#If both buttons are pressed, then the player will not move since button
	#strength is 1 for both, thereby setting player velocity at 0
	
	#This method is more efficient than 4 or so lines of if and else if 
	#since it uses 2 lines of code rather than 8
	
	input_vector = input_vector.normalized()
	#This line makes it so that moving in the diagnols is the same speed as moving horizonally
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_collide(velocity)
	# "* delta" makes it so that movement speed is not tied to frame rate.
	#it changes movement from pixels per frame to x amount of time per frame

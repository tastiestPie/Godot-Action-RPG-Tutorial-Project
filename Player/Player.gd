extends KinematicBody2D

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
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector
	else:
		velocity = Vector2.ZERO
	
	move_and_collide(velocity)

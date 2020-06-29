extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500
const ROLL_SPEED = 120

enum {
	MOVE,
	ROLL,
	ATTACK
}

var velocity = Vector2.ZERO
var state = MOVE
var roll_vector = Vector2.LEFT

onready var animationPlayer = $AnimationPlayer
# the $ symbol connects a specific node to the script.
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)

func move_state(delta):
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
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func move():
	velocity = move_and_slide(velocity)
	# "* delta" makes it so that movement speed is not tied to frame rate.
	#it changes movement from pixels per frame to x amount of time per frame
	
	#move_and_slide uses delta automatically in the calculations. 
	#m and s allows detects collisions while also allowing sliding along it.

func roll_state (delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func roll_animation_finished():
	velocity = velocity * 0.75
	state = MOVE

func attack_animation_finished():
	state = MOVE

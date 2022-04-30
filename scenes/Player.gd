extends KinematicBody2D

var gravity = 300
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 100
var horizontalAcceleration = 1500
var jumpSpeed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var moveVector = Vector2.ZERO
	# will return either 0 or 1 
	# jump - 1 --> we want to go up on the y axis
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if  Input.is_action_just_pressed("jump") else 0 
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	# deacceleration
	if(moveVector.x == 0):
		# https://www.gamedeveloper.com/programming/improved-lerp-smoothing-
		velocity.x = lerp(velocity.x, 0, .1)
	
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	# we want to jump
	if (moveVector.y < 0 && is_on_floor()):
		velocity.y = moveVector.y * jumpSpeed

	velocity.y += gravity * delta
	# takes an input vector, moves the character by vector * delta - resets velocity to 0 after collision
	velocity = move_and_slide(velocity, Vector2.UP)

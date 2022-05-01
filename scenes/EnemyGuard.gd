extends KinematicBody2D
var maxSpeed = 25
var velocity = Vector2.ZERO
var direction = Vector2.RIGHT
var gravity = 500

######### IMPORTANT ######### 
# Removing layer: No longer collide with the player
# Removing mask: Detects collision but doesn't collide with the player


func _process(delta):
	velocity.x = (direction * maxSpeed).x
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# no longer on the platform
	if(!is_on_floor()):
		velocity.y += gravity * delta
		
	if(direction.x > 0):
		get_node("AnimatedSprite").flip_h = true
	else:
		get_node("AnimatedSprite").flip_h = false
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


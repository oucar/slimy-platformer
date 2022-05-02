extends KinematicBody2D
var maxSpeed = 25
var velocity = Vector2.ZERO
var direction = Vector2.ZERO

enum Direction {RIGHT, LEFT}
export(Direction) var startDirection

######### IMPORTANT ######### 
# Removing layer: No longer collide with the player
# Removing mask: Detects collision but doesn't collide with the player

func _process(delta):
	velocity.x = (direction * maxSpeed).x
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if(direction.x > 0):
		get_node("AnimatedSprite").flip_h = true
	else:
		get_node("AnimatedSprite").flip_h = false
	

# Called when the node enters the scene tree for the first time.
func _ready():
	# setting the starting direction
	if(startDirection == Direction.RIGHT):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
	
	get_node("GoalDetector").connect("area_entered", self, "on_goal_entered")
	get_node("HurtboxArea").connect("area_entered", self, "on_hurtbox_entered")
	
func on_goal_entered(_area2d):
	# flip the direction
	direction = direction * -1

func on_hurtbox_entered(_area2d):
	print("Fly has been killed!")
	queue_free()

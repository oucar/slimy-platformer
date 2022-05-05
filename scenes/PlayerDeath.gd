extends KinematicBody2D

var velocity = Vector2.ZERO
var gravity = 1000

func _process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (is_on_floor()):
		velocity.x = lerp(0, velocity.x, pow(2, -1 * delta))
		
	# facing and falling the correct way for the player death animation
	if (velocity.x > 0):
		get_node("Visuals").scale = Vector2(-1, 1)


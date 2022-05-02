extends Enemy

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

func on_hurtbox_entered(_area2d):
	print("Guard has been killed!")
	queue_free()

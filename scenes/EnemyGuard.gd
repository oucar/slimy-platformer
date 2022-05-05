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
	# shake the camera
	get_tree().get_root().get_node("Helpers").apply_camera_shake(1)
	
	# blood effect
	get_node("BloodSplatter").splatter()
	
	# accessing the methods of base level scene
	var baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.enemy_killed()
	queue_free()

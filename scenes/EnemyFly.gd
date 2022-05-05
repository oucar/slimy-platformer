extends Enemy

func on_hurtbox_entered(_area2d):
	# shake the camera
	get_tree().get_root().get_node("Helpers").apply_camera_shake(1)
	
	# blood effect
	get_node("BloodSplatter").splatter()
	
	# accessing the methods of base level scene
	var baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.enemy_killed()
	queue_free()

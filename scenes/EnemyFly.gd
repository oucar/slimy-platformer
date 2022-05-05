extends Enemy

var deathScene = preload("res://scenes/EnemyFlyDeath.tscn")

func on_hurtbox_entered(_area2d):
	# shake the camera
	get_tree().get_root().get_node("Helpers").apply_camera_shake(1)
	
	# blood effect
	get_node("BloodSplatter").splatter()
	
	# accessing the methods of base level scene
	var baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.enemy_killed()
	call_deferred("kill")
	
func kill():
	# Animating the enemy
	var deathInstance = deathScene.instance()
	get_parent().add_child(deathInstance)
	deathInstance.global_position = global_position
	
	queue_free()

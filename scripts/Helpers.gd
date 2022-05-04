extends Node

# for shaky camera
func apply_camera_shake(percentage):
	var cameras = get_tree().get_nodes_in_group("camera")
	# if there's a camera, just in case
	if (cameras.size() > 0):
		cameras[0].apply_shake(percentage)
		


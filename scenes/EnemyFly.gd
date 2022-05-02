extends Enemy

func on_hurtbox_entered(_area2d):
	print("Fly has been killed!")
	queue_free()

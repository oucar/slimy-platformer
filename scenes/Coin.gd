extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Area2D").connect("area_entered", self, "on_area_entered")
	
func on_area_entered(area2d):
	get_node("AnimationPlayer").play("pickedUp")
	call_deferred("disable_pickup")
	
func disable_pickup():
	get_node("Area2D/CollisionShape2D").disabled = true


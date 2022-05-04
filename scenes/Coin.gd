extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Area2D").connect("area_entered", self, "on_area_entered")
	
func on_area_entered(area2d):
	get_node("AnimationPlayer").play("pickedUp")
	call_deferred("disable_pickup")
	
	# accessing the methods of base level scene
	var baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.coin_collected()
	
func disable_pickup():
	get_node("Area2D/CollisionShape2D").disabled = true


extends Node

func _ready():
	get_tree().get_root().get_node("LevelManager").change_level(0)

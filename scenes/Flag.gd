extends Node2D

signal player_won

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Area2D").connect("area_entered", self, "on_area_entered")
	
func on_area_entered(_area2d):
	print("YOU DID IT!")
	emit_signal("player_won")

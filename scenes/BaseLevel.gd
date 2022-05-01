extends Node2D

var playerScene = preload("res://scenes/Player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null

func _ready():
	spawnPosition = get_node("Player").global_position
	register_player(get_node("Player"))
	
func register_player(player):
	currentPlayerNode = player
	currentPlayerNode.connect("died", self, "on_player_died")
	
func create_player():
	var playerInstance = playerScene.instance()
	# replaces the player node
	add_child_below_node(currentPlayerNode, playerInstance)
	register_player(playerInstance)
	
func on_player_died():
	currentPlayerNode.queue_free()
	create_player()

extends Node2D

var playerScene = preload("res://scenes/Player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null

func _ready():
	spawnPosition = get_node("Player").global_position
	register_player(get_node("Player"))
	
func register_player(player):
	currentPlayerNode = player
	# deferred means it'll go to the next idle frame 
	# you need an empty array to use 4th argument
	currentPlayerNode.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)
	
func create_player():
	var playerInstance = playerScene.instance()
	# replaces the player node
	add_child_below_node(currentPlayerNode, playerInstance)
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)
	
func on_player_died():
	currentPlayerNode.queue_free()
	create_player()

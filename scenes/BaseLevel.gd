extends Node2D

# for ui - we should know when to update counter in the ui
signal coin_total_changed
signal enemy_total_changed

export(PackedScene) var levelCompleteScene

var playerScene = preload("res://scenes/Player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null
var totalCoins = 0
var collectedCoins = 0
var totalEnemies = 0 
var enemiesKilled = 0

func _ready():
	spawnPosition = get_node("Player").global_position
	register_player(get_node("Player"))
	
	# total coins in the scene 
	# a group for the coins in the coin scene 
	coin_total_changed(get_tree().get_nodes_in_group("coin").size())
	
	# total enemies in the scene
	var guardTotal = get_tree().get_nodes_in_group("enemy_guard").size()
	var flyTotal = get_tree().get_nodes_in_group("enemy_guard").size()
	enemy_total_changed(guardTotal + flyTotal)
	
	# register a signal to listen for enemy reaching to the flag
	get_node("Flag").connect("player_won", self, "on_player_won")
	
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

# COUNTING COINS COLLECTED
func coin_collected():
	collectedCoins = collectedCoins + 1
	print("Coins: ", collectedCoins, "/", totalCoins)
	emit_signal("coin_total_changed", totalCoins, collectedCoins)

func coin_total_changed(newTotal):
	totalCoins = newTotal
	emit_signal("coin_total_changed", totalCoins, collectedCoins)
	
# COUNTING ENEMIES KILLED
func enemy_killed():
	enemiesKilled = enemiesKilled + 1
	print("Enemies: ", enemiesKilled, "/", totalEnemies)
	emit_signal("enemy_total_changed", totalEnemies, enemiesKilled)

func enemy_total_changed(newTotal):
	totalEnemies= newTotal
	emit_signal("enemy_total_changed", totalEnemies, enemiesKilled)
	
# FLAG, GAME WINNING CONDITION
func on_player_won():
	currentPlayerNode.queue_free()
	var levelComplete = levelCompleteScene.instance()
	add_child(levelComplete)
	# get to the root, find level manager and increment level
	# get_tree().get_root().get_node("LevelManager").increment_level()
	


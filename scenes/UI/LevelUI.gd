extends CanvasLayer

func _ready():
	# Connect to the signals in the base level scene
	var baseLevels = get_tree().get_nodes_in_group("base_level")
	
	# Doesn't required for the production unless you run this scene.
	if(baseLevels.size() > 0):
		print(baseLevels.size())
		baseLevels[0].connect("coin_total_changed", self, "on_coin_total_changed")
		baseLevels[0].connect("enemy_total_changed", self, "on_enemy_total_changed")
	
func on_coin_total_changed(totalCoins, collectedCoins):
	get_node("MarginContainer/Vertical/HorizontalCoin/CoinLabel").text = str(collectedCoins, "/", totalCoins)
	
func on_enemy_total_changed(totalEnemies, enemiesKilled):
	get_node("MarginContainer/Vertical/HorizontalEnemy/EnemyLabel").text = str(enemiesKilled, "/", totalEnemies)
	

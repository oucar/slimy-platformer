####### OPTIONAL ---- WILL NOT BE USED #######

extends Position2D

export(PackedScene) var enemyScene

# Brought here from the generic enemy class
enum Direction {RIGHT, LEFT}
export(Direction) var startDirection


var currentEnemyNode = null
var spawnOnNextTick = false

func _ready():
	get_node("SpawnTimer").connect("timeout", self, "on_spawn_timer_timeout")
	call_deferred("spawn_enemy")

func spawn_enemy():
	currentEnemyNode = enemyScene.instance()
	currentEnemyNode.startDirection = Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT
	get_parent().add_child(currentEnemyNode)
	currentEnemyNode.global_position = global_position

func check_enemy_spawn():
	# checking if the object exists or not
	if(!is_instance_valid(currentEnemyNode)):
		if(spawnOnNextTick == true):
			spawn_enemy()
			spawnOnNextTick = false
		else: 
			spawnOnNextTick = true

func on_spawn_timer_timeout():
	check_enemy_spawn()

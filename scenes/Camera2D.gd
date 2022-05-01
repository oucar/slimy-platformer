extends Camera2D

var targetPosition = Vector2.ZERO
export(Color, RGB) var backgroundColor


func _ready():
	# Change background color
	VisualServer.set_default_clear_color(backgroundColor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# LERK to make it look more professional
func _process(delta):
	get_target_position()
	global_position = lerp(targetPosition, global_position, pow(2, -10 * delta))


func get_target_position():
	# get the player group
	var players = get_tree().get_nodes_in_group("player")
	if(players.size() > 0):
		var player = players[0]
		targetPosition = player.global_position

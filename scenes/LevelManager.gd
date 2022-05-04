extends Node2D

export(Array, PackedScene) var levelScenes

var currentLevelIndex = 0

func _ready():
	change_level(currentLevelIndex)
	
func change_level(levelIndex):
	currentLevelIndex = levelIndex
	# Click on LevelManager node and inspect the given array
	get_tree().change_scene(levelScenes[levelIndex].resource_path)

func increment_level():
	change_level(currentLevelIndex + 1)

extends Node2D

export(Array, PackedScene) var levelScenes

var currentLevelIndex = 0
	
func change_level(levelIndex):
	
	currentLevelIndex = levelIndex
	
	# In order to cycle endlessly between the levels, I might update this in the future
	if(currentLevelIndex >= levelScenes.size()):
		currentLevelIndex = 0

	# Click on LevelManager node and inspect the given array
	get_tree().change_scene(levelScenes[currentLevelIndex].resource_path)

func increment_level():
	change_level(currentLevelIndex + 1)

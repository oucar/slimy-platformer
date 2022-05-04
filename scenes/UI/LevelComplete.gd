extends CanvasLayer

func _ready():
	get_node("PanelContainer/MarginContainer/VBoxContainer/Button").connect("pressed", self, "on_next_button_pressed")

func on_next_button_pressed():
	get_tree().get_root().get_node("LevelManager").increment_level()
